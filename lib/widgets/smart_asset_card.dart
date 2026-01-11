import 'package:flutter/material.dart';
import 'package:sentio/asset/asset.dart';
import 'package:sentio/constant.dart';

/// Smart Asset Card that visualizes the intelligent metadata from the backend
/// Shows category icons, colored badges, smart tags, and provides rich interactions
class SmartAssetCard extends StatelessWidget {
  final Asset asset;
  final VoidCallback onCopyPath;
  final VoidCallback onOpen;

  const SmartAssetCard({
    super.key,
    required this.asset,
    required this.onCopyPath,
    required this.onOpen,
  });

  /// Get appropriate icon based on file category
  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'image':
        return Icons.image;
      case 'document':
        return Icons.description;
      case 'video':
        return Icons.videocam;
      case 'audio':
        return Icons.audiotrack;
      case 'archive':
        return Icons.folder_zip;
      case 'code':
        return Icons.code;
      case 'cad':
        return Icons.architecture; // Special icon for CAD files
      default:
        return Icons.insert_drive_file;
    }
  }

  /// Get color based on category
  Color _getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'image':
        return Colors.purple;
      case 'document':
        return Colors.blue;
      case 'video':
        return Colors.red;
      case 'audio':
        return Colors.green;
      case 'archive':
        return Colors.orange;
      case 'code':
        return Colors.teal;
      case 'cad':
        return Colors.indigo; // Special color for CAD files
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final categoryColor = _getCategoryColor(asset.category);

    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: categoryColor.withOpacity(0.2), width: 1),
      ),
      child: InkWell(
        onTap: onOpen,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Header: Icon + Name + Category Badge + Actions
              Row(
                children: [
                  // Category Icon
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: categoryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      _getCategoryIcon(asset.category),
                      color: categoryColor,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),

                  // Name and Category
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          asset.name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),

                        // Category Badge
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: categoryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(
                              color: categoryColor.withOpacity(0.3),
                            ),
                          ),
                          child: Text(
                            asset.category.toUpperCase(),
                            style: TextStyle(
                              fontSize: 10,
                              color: categoryColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Action Buttons
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Inject Button (for future AutoCAD integration)
                      IconButton(
                        icon: const Icon(Icons.add_circle_outline),
                        onPressed: () {
                          // TODO: Connect to Injector Service
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Injecting ${asset.name} into AutoCAD...',
                              ),
                              duration: Duration(seconds: 2),
                            ),
                          );
                        },
                        tooltip: 'Inject into AutoCAD',
                        color: Colors.blue,
                      ),

                      // More Options Menu
                      PopupMenuButton<String>(
                        icon: const Icon(Icons.more_vert),
                        onSelected: (value) {
                          switch (value) {
                            case 'open':
                              onOpen();
                              break;
                            case 'copy':
                              onCopyPath();
                              break;
                            case 'details':
                              _showAssetDetails(context);
                              break;
                          }
                        },
                        itemBuilder: (context) => [
                          PopupMenuItem(
                            value: 'open',
                            child: ListTile(
                              leading: const Icon(Icons.open_in_new),
                              title: Text('Open'),
                              dense: true,
                            ),
                          ),
                          PopupMenuItem(
                            value: 'copy',
                            child: ListTile(
                              leading: const Icon(Icons.content_copy),
                              title: Text('Copy Path'),
                              dense: true,
                            ),
                          ),
                          PopupMenuItem(
                            value: 'details',
                            child: ListTile(
                              leading: const Icon(Icons.info_outline),
                              title: Text('View Details'),
                              dense: true,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // 2. Tags Section (Only show if tags exist)
              if (asset.tags.isNotEmpty) ...[
                const Text(
                  'Tags:',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 4),

                // Smart Tags with Colors
                Wrap(
                  spacing: 8.0, // Gap between adjacent chips
                  runSpacing: 4.0, // Gap between lines
                  children: asset.tags.map((tag) {
                    // Generate a consistent color for each tag
                    final tagColor = _generateTagColor(tag);
                    return Chip(
                      label: Text(tag, style: const TextStyle(fontSize: 11)),
                      backgroundColor: tagColor.withOpacity(0.1),
                      side: BorderSide(
                        color: tagColor.withOpacity(0.3),
                        width: 1,
                      ),
                      padding: EdgeInsets.zero,
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      visualDensity: VisualDensity.compact,
                    );
                  }).toList(),
                ),
                const SizedBox(height: 8),
              ],

              // 3. File Path (Collapsible)
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.folder, size: 16, color: Colors.grey),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        asset.path,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey.shade600,
                          fontSize: 11,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Generate a consistent color for each tag
  Color _generateTagColor(String tag) {
    // Use a simple hash to generate consistent colors for tags
    final hash = tag.hashCode;
    final colors = [
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.teal,
      Colors.pink,
      Colors.indigo,
      Colors.cyan,
    ];
    return colors[hash.abs() % colors.length];
  }

  /// Show detailed asset information
  void _showAssetDetails(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(asset.name),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDetailRow('Category', asset.category),
              _buildDetailRow('File Type', _getFileExtension()),
              if (asset.tags.isNotEmpty) ...[
                const SizedBox(height: 8),
                const Text(
                  'Tags:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Wrap(
                  spacing: 4,
                  children: asset.tags
                      .map(
                        (tag) => Chip(
                          label: Text(tag),
                          backgroundColor: _generateTagColor(
                            tag,
                          ).withOpacity(0.1),
                        ),
                      )
                      .toList(),
                ),
              ],
              const SizedBox(height: 8),
              _buildDetailRow('Full Path', asset.path),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  /// Build a detail row for the dialog
  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label:',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
          ),
          const SizedBox(height: 2),
          Text(value, style: const TextStyle(fontSize: 14)),
        ],
      ),
    );
  }

  /// Get file extension
  String _getFileExtension() {
    return asset.path.split('.').last.toUpperCase();
  }
}
