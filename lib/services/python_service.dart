import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as path;

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

  /// Run the orchestrator to index a folder
  Future<Stream<String>> indexFolder(String folderPath) async {
    try {
      final orchestratorPath = path.join(_backendPath, 'orchestrator.py');

      if (!File(orchestratorPath).existsSync()) {
        throw Exception('Python orchestrator not found: $orchestratorPath');
      }

      final process = await Process.start(_pythonExecutable, [
        orchestratorPath,
        'index',
        'scan',
        folderPath,
      ], workingDirectory: _backendPath);

      return process.stdout
          .transform(utf8.decoder)
          .transform(const LineSplitter());
    } catch (e) {
      debugPrint('Error running orchestrator index: $e');
      return Stream.value('Error: $e');
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

/// Asset model to represent indexed files
class Asset {
  final int id;
  final String name;
  final String category;
  final List<String> tags;
  final String path;

  Asset({
    required this.id,
    required this.name,
    required this.category,
    required this.tags,
    required this.path,
  });

  factory Asset.fromJson(Map<String, dynamic> json) {
    return Asset(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      category: json['category'] ?? 'Uncategorized',
      tags: List<String>.from(json['tags'] ?? []),
      path: json['path'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'tags': tags,
      'path': path,
    };
  }

  @override
  String toString() {
    return 'Asset(id: $id, name: $name, category: $category, tags: $tags, path: $path)';
  }
}
