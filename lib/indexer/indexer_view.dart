import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:file_selector/file_selector.dart';
import 'package:sentio/constant.dart';
import 'package:sentio/utilties/enum.dart';
import 'package:sentio/utilties/utilities.dart';
import 'package:sentio/widgets/primary_cta.dart';
import 'package:sentio/widgets/secondary_cta.dart';

class IndexerView extends StatefulWidget {
  const IndexerView({super.key});

  @override
  State<IndexerView> createState() => _IndexerViewState();
}

class _IndexerViewState extends State<IndexerView> {
  final List<String> _selectedFolders = [];
  IndexerStatus _currentStatus = IndexerStatus.idle;
  int _indexedFilesCount = 0;
  IndexerFileType _selectedFileType = IndexerFileType.all;
  bool _isIndexing = false;

  Future<void> _addFolder() async {
    try {
      // Use file_selector to pick a directory
      final String? directoryPath = await getDirectoryPath(
        confirmButtonText: 'Select Folder',
      );

      if (directoryPath == null) {
        // User cancelled the picker
        return;
      }

      // Check if folder is already added
      if (_selectedFolders.contains(directoryPath)) {
        UIHelpers.showErrorSnackBar(context, FOLDER_ALREADY_ADDED);
        return;
      }

      setState(() {
        _selectedFolders.add(directoryPath);
      });

      UIHelpers.showSuccessSnackBar(context, FOLDER_ADDED);
    } catch (error) {
      UIHelpers.showErrorSnackBar(
        context,
        'Failed to select folder: ${error.toString()}',
      );
    }
  }

  void _removeFolder(String folder) {
    setState(() {
      _selectedFolders.remove(folder);
    });

    UIHelpers.showSuccessSnackBar(context, FOLDER_REMOVED);
  }

  void _startIndexing() async {
    if (_selectedFolders.isEmpty) {
      UIHelpers.showErrorSnackBar(context, SELECT_FOLDER_TO_INDEX);
      return;
    }

    setState(() {
      _isIndexing = true;
      _currentStatus = IndexerStatus.indexing;
      _indexedFilesCount = 0;
    });

    UIHelpers.showSuccessSnackBar(context, INDEXING_STARTED);

    try {
      // Simulate indexing process
      for (int i = 0; i < 10; i++) {
        await Future.delayed(const Duration(milliseconds: 500));
        setState(() {
          _indexedFilesCount = i + 1;
        });
      }

      setState(() {
        _currentStatus = IndexerStatus.completed;
        _isIndexing = false;
      });

      UIHelpers.showSuccessSnackBar(
        context,
        '$INDEXING_COMPLETED - $_indexedFilesCount $FILES_INDEXED',
      );
    } catch (error) {
      setState(() {
        _currentStatus = IndexerStatus.failed;
        _isIndexing = false;
      });

      UIHelpers.showErrorSnackBar(
        context,
        '$INDEXING_FAILED: ${error.toString()}',
      );
    }
  }

  void _stopIndexing() {
    setState(() {
      _isIndexing = false;
      _currentStatus = IndexerStatus.stopped;
    });

    UIHelpers.showSuccessSnackBar(context, INDEXING_STOPPED);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? Colors.grey[900] : Colors.grey[50],
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(doubleDefaultMargin),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            Text(
              INDEX_FILE,
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Select folders to index and manage your asset library',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: isDark ? Colors.grey[400] : Colors.grey[600],
              ),
            ),
            const SizedBox(height: 24),

            // Status Card
            Card(
              elevation: defaultElevation,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(defaultBorderRadius),
              ),
              child: Padding(
                padding: const EdgeInsets.all(doubleDefaultMargin),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          _currentStatus.icon,
                          color: theme.colorScheme.primary,
                          size: 24,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          INDEXING_STATUS,
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _currentStatus.label,
                          style: theme.textTheme.bodyLarge,
                        ),
                        if (_isIndexing)
                          Row(
                            children: [
                              SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    theme.colorScheme.primary,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                '$_indexedFilesCount $FILES_INDEXED',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: theme.colorScheme.primary,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // File Type Selection
            Card(
              elevation: defaultElevation,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(defaultBorderRadius),
              ),
              child: Padding(
                padding: const EdgeInsets.all(doubleDefaultMargin),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'File Types to Index',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 8,
                      children: IndexerFileType.values.map((fileType) {
                        final isSelected = _selectedFileType == fileType;
                        return ChoiceChip(
                          label: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(fileType.icon, size: 16),
                              const SizedBox(width: 4),
                              Text(fileType.label),
                            ],
                          ),
                          selected: isSelected,
                          onSelected: (selected) {
                            if (selected) {
                              setState(() {
                                _selectedFileType = fileType;
                              });
                            }
                          },
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Folders Section
            Card(
              elevation: defaultElevation,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(defaultBorderRadius),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Header
                  Container(
                    padding: const EdgeInsets.all(doubleDefaultMargin),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: theme.dividerColor, width: 1),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          FOLDERS_TO_INDEX,
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        PrimaryCTAButton(
                          onPressed: _addFolder,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.add, size: 20),
                              const SizedBox(width: 8),
                              Text(ADD_FOLDER),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Content
                  Container(
                    constraints: const BoxConstraints(minHeight: 200),
                    child: _selectedFolders.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.folder_open,
                                  size: 64,
                                  color: isDark
                                      ? Colors.grey[600]
                                      : Colors.grey[400],
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  NO_FOLDERS_SELECTED,
                                  style: theme.textTheme.bodyLarge?.copyWith(
                                    color: isDark
                                        ? Colors.grey[400]
                                        : Colors.grey[600],
                                  ),
                                ),
                                const SizedBox(height: 16),
                                SecondaryCTAButton(
                                  onPressed: _addFolder,
                                  child: Text(SELECT_FOLDER_TO_INDEX),
                                ),
                              ],
                            ),
                          )
                        : ListView.builder(
                            shrinkWrap: true,
                            physics: const ClampingScrollPhysics(),
                            padding: const EdgeInsets.all(doubleDefaultMargin),
                            itemCount: _selectedFolders.length,
                            itemBuilder: (context, index) {
                              final folder = _selectedFolders[index];
                              return Card(
                                elevation: 1,
                                margin: const EdgeInsets.only(bottom: 8),
                                child: ListTile(
                                  leading: Icon(
                                    Icons.folder,
                                    color: theme.colorScheme.primary,
                                  ),
                                  title: Text(
                                    folder,
                                    style: theme.textTheme.bodyLarge,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  trailing: IconButton(
                                    icon: const Icon(
                                      Icons.remove_circle_outline,
                                    ),
                                    color: Colors.red,
                                    onPressed: () => _removeFolder(folder),
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: SecondaryCTAButton(
                    onPressed: _selectedFolders.isNotEmpty && !_isIndexing
                        ? () {
                            setState(() {
                              _selectedFolders.clear();
                            });
                          }
                        : null,
                    child: const Text('Clear All'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: PrimaryCTAButton(
                    onPressed: _isIndexing ? _stopIndexing : _startIndexing,
                    isLoading: _isIndexing,
                    child: Text(_isIndexing ? STOP_INDEXING : START_INDEXING),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
