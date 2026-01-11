import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as path;
import 'package:sentio/asset/asset.dart';

/// Service class to handle communication with Python backend scripts
class PythonService {
  static PythonService? _instance;
  static PythonService get instance => _instance ??= PythonService._internal();

  PythonService._internal();

  /// Get the path to the Python backend directory
  String get _backendPath {
    // Handle different execution contexts (debug/release)
    if (kDebugMode) {
      // In debug mode, backend is in the project directory
      return 'lib/backend';
    } else {
      // In release mode, we need to handle platform-specific paths
      if (Platform.isWindows) {
        return path.join(
          Directory.current.path,
          'data',
          'flutter_assets',
          'lib',
          'backend',
        );
      } else if (Platform.isMacOS) {
        return path.join(
          Directory.current.path,
          'Contents',
          'Frameworks',
          'App.framework',
          'Resources',
          'flutter_assets',
          'lib',
          'backend',
        );
      } else if (Platform.isLinux) {
        return path.join(
          Directory.current.path,
          'data',
          'flutter_assets',
          'lib',
          'backend',
        );
      }
    }
    return 'lib/backend';
  }

  /// Get the path to the Python executable
  String get _pythonExecutable {
    if (Platform.isWindows) {
      return 'python';
    } else {
      return 'python3';
    }
  }

  /// Run the orchestrator to search for assets
  Future<List<Asset>> searchAssets(String query) async {
    try {
      final orchestratorPath = path.join(_backendPath, 'orchestrator.py');

      if (!File(orchestratorPath).existsSync()) {
        throw Exception('Python orchestrator not found: $orchestratorPath');
      }

      final result = await Process.run(_pythonExecutable, [
        orchestratorPath,
        'search',
        query,
      ], workingDirectory: _backendPath);

      if (result.exitCode != 0) {
        throw Exception('Python orchestrator failed: ${result.stderr}');
      }

      final output = result.stdout.toString().trim();
      if (output.isEmpty) {
        return [];
      }

      // Parse JSON output
      final Map<String, dynamic> response = jsonDecode(output);
      if (response['success'] == true && response['results'] != null) {
        final List<dynamic> results = response['results'];
        return results.map((json) => Asset.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      debugPrint('Error running orchestrator search: $e');
      return [];
    }
  }

  /// Run the orchestrator to scan a folder (non-blocking, returns stream)
  Stream<Map<String, dynamic>> indexFolder(String folderPath) async* {
    try {
      final orchestratorPath = path.join(_backendPath, 'orchestrator.py');

      if (!File(orchestratorPath).existsSync()) {
        throw Exception('Python orchestrator not found: $orchestratorPath');
      }

      debugPrint("📂 PythonService: Scanning folder $folderPath");

      final process = await Process.start(_pythonExecutable, [
        orchestratorPath,
        'index',
        'scan',
        folderPath,
      ], workingDirectory: _backendPath);

      // Read output line by line with debug logging
      await for (final line
          in process.stdout
              .transform(utf8.decoder)
              .transform(const LineSplitter())) {
        debugPrint("🐍 Python Output: $line");
        if (line.trim().isEmpty) continue;

        try {
          final jsonOutput = jsonDecode(line);
          if (jsonOutput is Map<String, dynamic>) {
            yield jsonOutput;
          }
        } catch (e) {
          debugPrint("❌ JSON Parse Error: $e | Line: $line");
        }
      }

      // Check stderr for crashes
      final stderr = await process.stderr.transform(utf8.decoder).join();
      if (stderr.isNotEmpty) {
        debugPrint("❌ Python Error: $stderr");
      }
    } catch (e) {
      debugPrint('Error running orchestrator index: $e');
      yield {'event': 'error', 'message': e.toString()};
    }
  }

  /// Start background watching for folders (fire and forget)
  void startBackgroundWatcher(List<String> paths) {
    for (final folderPath in paths) {
      debugPrint("👀 Starting background watcher for: $folderPath");
      try {
        final orchestratorPath = path.join(_backendPath, 'orchestrator.py');
        Process.start(
          _pythonExecutable,
          [orchestratorPath, 'index', 'watch', folderPath],
          workingDirectory: _backendPath,
          mode: ProcessStartMode.detached,
        );
      } catch (e) {
        debugPrint('Error starting background watcher: $e');
      }
    }
  }

  /// Check if Python is available on the system
  Future<bool> isPythonAvailable() async {
    try {
      final result = await Process.run(_pythonExecutable, ['--version']);
      return result.exitCode == 0;
    } catch (e) {
      return false;
    }
  }

  /// Inject asset into AutoCAD
  Future<void> injectAsset(String filePath) async {
    try {
      final orchestratorPath = path.join(_backendPath, 'orchestrator.py');

      if (!File(orchestratorPath).existsSync()) {
        throw Exception('Python orchestrator not found: $orchestratorPath');
      }

      debugPrint("💉 Injecting asset: $filePath");

      final result = await Process.run(_pythonExecutable, [
        orchestratorPath,
        'inject',
        filePath,
      ], workingDirectory: _backendPath);

      debugPrint("💉 Injection result: ${result.stdout}");

      if (result.exitCode != 0) {
        throw Exception('Python injector failed: ${result.stderr}');
      }
    } catch (e) {
      debugPrint('Error running injector: $e');
      rethrow;
    }
  }

  /// Get the path to the database file
  String getDatabasePath() {
    if (kDebugMode) {
      return path.join(_backendPath, 'imperium1.db');
    } else {
      // In release mode, use the config-based path
      return path.join(Directory.current.path, 'imperium1.db');
    }
  }
}
