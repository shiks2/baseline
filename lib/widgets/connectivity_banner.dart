/* import 'package:aureus/core/services/connectivity_service.dart';
import 'package:flutter/material.dart';

class ConnectivityBanner extends StatelessWidget {
  final Widget child;
  final bool showWhenOnline;
  
  const ConnectivityBanner({
    super.key,
    required this.child,
    this.showWhenOnline = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AnimatedBuilder(
          animation: ConnectivityService.instance,
          builder: (context, _) {
            final connectivityService = ConnectivityService.instance;
            
            // Don't show anything if not initialized yet
            if (!connectivityService.isInitialized) {
              return const SizedBox.shrink();
            }
            
            // Show online status if requested
            if (showWhenOnline && connectivityService.isOnline) {
              return _buildBanner(
                context,
                connectivityService.getConnectionDescription(),
                Colors.green,
                Icons.wifi,
              );
            }
            
            // Always show offline status
            if (connectivityService.isOffline) {
              return _buildBanner(
                context,
                connectivityService.getConnectionDescription(),
                Colors.red,
                Icons.wifi_off,
              );
            }
            
            return const SizedBox.shrink();
          },
        ),
        Expanded(child: child),
      ],
    );
  }

  Widget _buildBanner(
    BuildContext context,
    String message,
    Color color,
    IconData icon,
  ) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: color,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.white, size: 16),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              message,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}

class ConnectivityAwareWidget extends StatelessWidget {
  final Widget child;
  final Widget? offlineWidget;
  final String? offlineMessage;
  
  const ConnectivityAwareWidget({
    super.key,
    required this.child,
    this.offlineWidget,
    this.offlineMessage,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: ConnectivityService.instance,
      builder: (context, _) {
        final connectivityService = ConnectivityService.instance;
        
        if (!connectivityService.isInitialized) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        
        if (connectivityService.isOffline) {
          return offlineWidget ?? _buildDefaultOfflineWidget(context);
        }
        
        return child;
      },
    );
  }

  Widget _buildDefaultOfflineWidget(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.wifi_off,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No Internet Connection',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(
            offlineMessage ?? 'Please check your connection and try again',
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              ConnectivityService.instance.checkConnectivity();
            },
            icon: const Icon(Icons.refresh),
            label: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}

class ConnectivityIndicator extends StatelessWidget {
  final bool showAlways;
  
  const ConnectivityIndicator({
    super.key,
    this.showAlways = false,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: ConnectivityService.instance,
      builder: (context, _) {
        final connectivityService = ConnectivityService.instance;
        
        if (!connectivityService.isInitialized) {
          return const SizedBox.shrink();
        }
        
        if (!showAlways && connectivityService.isOnline) {
          return const SizedBox.shrink();
        }
        
        Color color;
        IconData icon;
        
        switch (connectivityService.status) {
          case ConnectivityStatus.online:
            color = Colors.green;
            icon = connectivityService.isWifi ? Icons.wifi : Icons.signal_cellular_4_bar;
            break;
          case ConnectivityStatus.offline:
            color = Colors.red;
            icon = Icons.wifi_off;
            break;
          case ConnectivityStatus.unknown:
            color = Colors.orange;
            icon = Icons.help_outline;
            break;
        }
        
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: color.withOpacity(0.3)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 12, color: color),
              const SizedBox(width: 4),
              Text(
                connectivityService.getConnectionDescription(),
                style: TextStyle(
                  fontSize: 10,
                  color: color,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
} */
