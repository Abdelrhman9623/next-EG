import 'package:flutter/material.dart';
import 'package:next_app/core/widgets/base_layout.dart';
import 'package:next_app/core/widgets/navigation_item.dart';
import 'package:next_app/l10n/app_localizations.dart';

/// Example usage of BaseLayout
/// This file demonstrates different ways to use the BaseLayout widget

// Example 1: Simple layout with title and body
class SimpleLayoutExample extends StatelessWidget {
  const SimpleLayoutExample({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseLayout(
      title: 'Simple Page',
      body: const Center(child: Text('This is a simple layout example')),
    );
  }
}

// Example 2: Layout with bottom navigation
class NavigationLayoutExample extends StatelessWidget {
  const NavigationLayoutExample({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BaseLayout(
      title: l10n.appTitle,
      body:
          const SizedBox(), // Body required but not used when navigationItems provided
      navigationItems: [
        NavigationItem(
          label: l10n.home,
          icon: Icons.home,
          selectedIcon: Icons.home_outlined,
          index: 0,
          page: const HomePageExample(),
        ),
        NavigationItem(
          label: l10n.search,
          icon: Icons.search,
          selectedIcon: Icons.search_outlined,
          index: 1,
          page: const SearchPageExample(),
        ),
        NavigationItem(
          label: l10n.profile,
          icon: Icons.person,
          selectedIcon: Icons.person_outline,
          index: 2,
          page: const ProfilePageExample(),
        ),
      ],
    );
  }
}

// Example 3: Layout with custom app bar actions
class CustomAppBarExample extends StatelessWidget {
  const CustomAppBarExample({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseLayout(
      title: 'Custom App Bar',
      actions: [
        IconButton(
          icon: const Icon(Icons.notifications),
          onPressed: () {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(const SnackBar(content: Text('Notifications')));
          },
        ),
        IconButton(
          icon: const Icon(Icons.settings),
          onPressed: () {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(const SnackBar(content: Text('Settings')));
          },
        ),
      ],
      body: const Center(child: Text('Custom App Bar Example')),
    );
  }
}

// Example 4: Layout without app bar
class NoAppBarExample extends StatelessWidget {
  const NoAppBarExample({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseLayout(
      showAppBar: false,
      body: const Center(child: Text('No App Bar Example')),
    );
  }
}

// Example 5: Layout with tabs in app bar
class TabsLayoutExample extends StatelessWidget {
  const TabsLayoutExample({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: BaseLayout(
        title: 'Tabs Example',
        bottom: const TabBar(
          tabs: [
            Tab(text: 'Tab 1'),
            Tab(text: 'Tab 2'),
            Tab(text: 'Tab 3'),
          ],
        ),
        body: const TabBarView(
          children: [
            Center(child: Text('Tab 1 Content')),
            Center(child: Text('Tab 2 Content')),
            Center(child: Text('Tab 3 Content')),
          ],
        ),
      ),
    );
  }
}

// Example pages for navigation
class HomePageExample extends StatelessWidget {
  const HomePageExample({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.home, size: 64),
          SizedBox(height: 16),
          Text('Home Page'),
        ],
      ),
    );
  }
}

class SearchPageExample extends StatelessWidget {
  const SearchPageExample({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search, size: 64),
          SizedBox(height: 16),
          Text('Search Page'),
        ],
      ),
    );
  }
}

class ProfilePageExample extends StatelessWidget {
  const ProfilePageExample({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.person, size: 64),
          SizedBox(height: 16),
          Text('Profile Page'),
        ],
      ),
    );
  }
}
