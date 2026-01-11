import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sentio/constant.dart';
import 'package:sentio/utilties/enum.dart';

class MainShell extends StatefulWidget {
  final Widget? child;
  const MainShell({super.key, this.child});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  bool isNavigationRailExtended = false;
  double sidebarWidth = 200;
  int _selectedIndex = 0;

  // Use enums for navigation configuration
  final List<AppNavigationDestination> _destinations =
      AppNavigationDestination.values;

  void _onDestinationSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // Navigate to the corresponding route based on destination
    if (index < _destinations.length) {
      final destination = _destinations[index];
      switch (destination) {
        case AppNavigationDestination.library:
          context.go(LIBRARY_ROUTE);
          break;
        case AppNavigationDestination.assets:
          context.go(DASHBOARD); // Temporarily map assets to dashboard
          break;
        case AppNavigationDestination.profile:
          context.go(PROFILE_ROUTE);
          break;
        case AppNavigationDestination.indexFile:
          context.go(INDEXER_ROUTE);
          break;
        case AppNavigationDestination.settings:
          context.go(PROFILE_SETTINGS_ROUTE);
          break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(APP_NAME), centerTitle: true),
      body: Row(
        children: [
          NavigationRail(
            minExtendedWidth: sidebarWidth,
            extended: isNavigationRailExtended,
            leading: isNavigationRailExtended
                ? Container(
                    width: sidebarWidth,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(NAV_MENU, style: TextStyle(fontSize: 20)),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              isNavigationRailExtended =
                                  !isNavigationRailExtended;
                            });
                          },
                          icon: Icon(
                            isNavigationRailExtended
                                ? Icons.arrow_back
                                : Icons.arrow_forward,
                          ),
                        ),
                      ],
                    ),
                  )
                : IconButton(
                    onPressed: () {
                      setState(() {
                        isNavigationRailExtended = !isNavigationRailExtended;
                      });
                    },
                    icon: Icon(
                      isNavigationRailExtended
                          ? Icons.arrow_back
                          : Icons.arrow_forward,
                    ),
                  ),
            labelType: isNavigationRailExtended
                ? NavigationRailLabelType.none
                : NavigationRailLabelType.all,
            destinations: _buildNavigationDestinations(),
            selectedIndex: _selectedIndex,
            onDestinationSelected: _onDestinationSelected,
          ),
          // Main content area
          Expanded(
            child: Container(
              child:
                  widget.child ??
                  Container(
                    child: Center(
                      child: Text(
                        DEFAULT_PAGE_CONTENT,
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                    ),
                  ),
            ),
          ),
        ],
      ),
    );
  }

  List<NavigationRailDestination> _buildNavigationDestinations() {
    return _destinations.map((destination) {
      return NavigationRailDestination(
        icon: Icon(destination.icon),
        label: Text(destination.label),
      );
    }).toList();
  }
}
