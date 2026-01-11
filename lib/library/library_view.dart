import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sentio/constant.dart';
import 'package:sentio/services/python_service.dart';
import 'package:sentio/utilties/responsive.dart';
import 'package:sentio/widgets/smart_asset_card.dart';

class LibraryView extends StatefulWidget {
  const LibraryView({super.key});

  @override
  State<LibraryView> createState() => _LibraryViewState();
}

class _LibraryViewState extends State<LibraryView> {
  final TextEditingController _searchController = TextEditingController();
  final PythonService _pythonService = PythonService.instance;
  List<Asset> _assets = [];
  List<Asset> _filteredAssets = [];
  bool _isLoading = false;
  bool _hasError = false;
  bool _pythonAvailable = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _checkPythonAvailability();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _checkPythonAvailability() async {
    final isAvailable = await _pythonService.isPythonAvailable();
    setState(() {
      _pythonAvailable = isAvailable;
    });
  }

  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase().trim();
    if (query.isEmpty) {
      setState(() {
        _filteredAssets = List.from(_assets);
      });
    } else {
      setState(() {
        _filteredAssets = _assets.where((asset) {
          return asset.name.toLowerCase().contains(query) ||
              asset.category.toLowerCase().contains(query) ||
              asset.tags.any((tag) => tag.toLowerCase().contains(query));
        }).toList();
      });
    }
  }

  Future<void> _searchAssets() async {
    final query = _searchController.text.trim();
    if (query.isEmpty) return;

    setState(() {
      _isLoading = true;
      _hasError = false;
      _errorMessage = '';
    });

    try {
      final assets = await _pythonService.searchAssets(query);
      setState(() {
        _assets = assets;
        _filteredAssets = List.from(assets);
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _hasError = true;
        _errorMessage = e.toString();
        _isLoading = false;
        _assets = [];
        _filteredAssets = [];
      });
    }
  }

  void _clearSearch() {
    _searchController.clear();
    setState(() {
      _assets = [];
      _filteredAssets = [];
      _hasError = false;
      _errorMessage = '';
    });
  }

  void _copyPathToClipboard(String path) {
    Clipboard.setData(ClipboardData(text: path));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Path copied to clipboard'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _openAsset(String assetPath) async {
    try {
      if (Platform.isWindows) {
        await Process.run('explorer', [assetPath]);
      } else if (Platform.isMacOS) {
        await Process.run('open', [assetPath]);
      } else if (Platform.isLinux) {
        await Process.run('xdg-open', [assetPath]);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Could not open file: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = Responsive.isDesktop(context);

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(defaultMargin),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Text(
              LIBRARY,
              style: Theme.of(
                context,
              ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: defaultMargin),

            // Search Bar
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: SEARCH_PLACEHOLDER,
                      prefixIcon: Icon(Icons.search),
                      suffixIcon: _searchController.text.isNotEmpty
                          ? IconButton(
                              icon: Icon(Icons.clear),
                              onPressed: _clearSearch,
                            )
                          : null,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                          defaultBorderRadius,
                        ),
                      ),
                      filled: true,
                      fillColor: Theme.of(context).colorScheme.surface,
                    ),
                    onSubmitted: (_) => _searchAssets(),
                  ),
                ),
                SizedBox(width: defaultMargin),
                ElevatedButton.icon(
                  onPressed: _pythonAvailable ? _searchAssets : null,
                  icon: Icon(Icons.search),
                  label: Text(SEARCH_ASSETS),
                ),
              ],
            ),

            if (!_pythonAvailable) ...[
              SizedBox(height: doubleDefaultMargin),
              Card(
                color: Colors.orange.shade50,
                child: Padding(
                  padding: EdgeInsets.all(defaultMargin),
                  child: Row(
                    children: [
                      Icon(Icons.warning, color: Colors.orange),
                      SizedBox(width: defaultMargin),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              PYTHON_NOT_AVAILABLE,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.orange.shade700,
                              ),
                            ),
                            Text(PYTHON_NOT_AVAILABLE_MESSAGE),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],

            SizedBox(height: doubleDefaultMargin),

            // Results
            if (_isLoading)
              Center(
                child: Column(
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: defaultMargin),
                    Text(LOADING_ASSETS),
                  ],
                ),
              )
            else if (_hasError)
              Center(
                child: Column(
                  children: [
                    Icon(Icons.error_outline, size: 64, color: Colors.red),
                    SizedBox(height: defaultMargin),
                    Text(ERROR_LOADING_ASSETS),
                    SizedBox(height: halfDefaultMargin),
                    Text(
                      _errorMessage,
                      style: TextStyle(color: Colors.red),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: defaultMargin),
                    ElevatedButton.icon(
                      onPressed: _searchAssets,
                      icon: Icon(Icons.refresh),
                      label: Text(RETRY),
                    ),
                  ],
                ),
              )
            else if (_filteredAssets.isEmpty &&
                _searchController.text.isNotEmpty)
              Center(
                child: Column(
                  children: [
                    Icon(Icons.search_off, size: 64, color: Colors.grey),
                    SizedBox(height: defaultMargin),
                    Text(NO_RESULTS_FOUND),
                  ],
                ),
              )
            else if (_filteredAssets.isNotEmpty) ...[
              Text(
                '$SEARCH_RESULTS (${_filteredAssets.length})',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: defaultMargin),
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final crossAxisCount = isDesktop
                        ? (constraints.maxWidth / 400).floor().clamp(1, 4)
                        : 1;

                    return GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        childAspectRatio: 3,
                        crossAxisSpacing: defaultMargin,
                        mainAxisSpacing: defaultMargin,
                      ),
                      itemCount: _filteredAssets.length,
                      itemBuilder: (context, index) {
                        final asset = _filteredAssets[index];
                        return SmartAssetCard(
                          asset: asset,
                          onCopyPath: () => _copyPathToClipboard(asset.path),
                          onOpen: () => _openAsset(asset.path),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
