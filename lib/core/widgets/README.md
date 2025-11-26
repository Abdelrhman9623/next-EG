# Base Layout Widget

A reusable layout component that provides a consistent structure with app bar and bottom navigation across the app.

## Features

- **App Bar**: Customizable title, actions, and leading widget
- **Bottom Navigation**: Multi-page navigation with icons and labels
- **Flexible Body**: Changeable content area
- **RTL Support**: Automatically adapts to Arabic layout
- **Localization Ready**: Works with app localization

## Usage

### Basic Usage (Single Page)

```dart
import 'package:next_app/core/widgets/base_layout.dart';

BaseLayout(
  title: 'Home',
  body: Center(
    child: Text('Home Content'),
  ),
)
```

### With Bottom Navigation

```dart
import 'package:next_app/core/widgets/base_layout.dart';
import 'package:next_app/core/widgets/navigation_item.dart';
import 'package:next_app/l10n/app_localizations.dart';

BaseLayout(
  title: AppLocalizations.of(context)!.appTitle,
  navigationItems: [
    NavigationItem(
      label: AppLocalizations.of(context)!.home,
      icon: Icons.home,
      selectedIcon: Icons.home_outlined,
      index: 0,
      page: HomePage(),
    ),
    NavigationItem(
      label: AppLocalizations.of(context)!.search,
      icon: Icons.search,
      selectedIcon: Icons.search_outlined,
      index: 1,
      page: SearchPage(),
    ),
    NavigationItem(
      label: AppLocalizations.of(context)!.profile,
      icon: Icons.person,
      selectedIcon: Icons.person_outline,
      index: 2,
      page: ProfilePage(),
    ),
  ],
  currentIndex: 0,
  onNavigationTap: (index) {
    // Handle navigation
    print('Navigated to index: $index');
  },
)
```

### With Custom App Bar Actions

```dart
BaseLayout(
  title: 'My Page',
  actions: [
    IconButton(
      icon: Icon(Icons.notifications),
      onPressed: () {
        // Handle notification
      },
    ),
    IconButton(
      icon: Icon(Icons.settings),
      onPressed: () {
        // Handle settings
      },
    ),
  ],
  body: MyContent(),
)
```

### Without App Bar

```dart
BaseLayout(
  showAppBar: false,
  body: MyFullScreenContent(),
)
```

### Without Bottom Navigation

```dart
BaseLayout(
  showBottomNavigation: false,
  title: 'Single Page',
  body: MyContent(),
)
```

## Parameters

### BaseLayout

| Parameter | Type | Description |
|-----------|------|-------------|
| `title` | `String?` | App bar title |
| `body` | `Widget` | Main content (required) |
| `navigationItems` | `List<NavigationItem>?` | Bottom navigation items |
| `currentIndex` | `int?` | Current selected navigation index |
| `onNavigationTap` | `ValueChanged<int>?` | Callback when navigation item tapped |
| `actions` | `List<Widget>?` | App bar action buttons |
| `leading` | `Widget?` | App bar leading widget |
| `automaticallyImplyLeading` | `bool` | Show back button automatically (default: true) |
| `bottom` | `PreferredSizeWidget?` | App bar bottom widget (e.g., TabBar) |
| `backgroundColor` | `Color?` | Scaffold background color |
| `appBarBackgroundColor` | `Color?` | App bar background color |
| `showAppBar` | `bool` | Show/hide app bar (default: true) |
| `showBottomNavigation` | `bool` | Show/hide bottom navigation (default: true) |

### NavigationItem

| Parameter | Type | Description |
|-----------|------|-------------|
| `label` | `String` | Navigation item label |
| `icon` | `IconData` | Navigation item icon |
| `selectedIcon` | `IconData?` | Icon when item is selected (optional) |
| `index` | `int` | Navigation item index |
| `page` | `Widget` | Page to display when item is selected |

## Examples

### Example 1: Home Screen with Navigation

```dart
class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return BaseLayout(
      title: l10n.appTitle,
      navigationItems: [
        NavigationItem(
          label: l10n.home,
          icon: Icons.home,
          index: 0,
          page: HomePage(),
        ),
        NavigationItem(
          label: l10n.search,
          icon: Icons.search,
          index: 1,
          page: SearchPage(),
        ),
        NavigationItem(
          label: l10n.profile,
          icon: Icons.person,
          index: 2,
          page: ProfilePage(),
        ),
      ],
    );
  }
}
```

### Example 2: With State Management

```dart
class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NavigationCubit, NavigationState>(
      builder: (context, state) {
        return BaseLayout(
          title: 'My App',
          navigationItems: navigationItems,
          currentIndex: state.currentIndex,
          onNavigationTap: (index) {
            context.read<NavigationCubit>().navigateTo(index);
          },
          body: Container(), // Body is handled by navigationItems
        );
      },
    );
  }
}
```

### Example 3: Custom App Bar with Tabs

```dart
BaseLayout(
  title: 'My App',
  bottom: TabBar(
    tabs: [
      Tab(text: 'Tab 1'),
      Tab(text: 'Tab 2'),
      Tab(text: 'Tab 3'),
    ],
  ),
  body: TabBarView(
    children: [
      Tab1Content(),
      Tab2Content(),
      Tab3Content(),
    ],
  ),
)
```

## Best Practices

1. **Use Localization**: Always use `AppLocalizations` for labels
2. **Consistent Icons**: Use Material Icons for consistency
3. **State Management**: Use BLoC/Cubit for navigation state if needed
4. **RTL Support**: Icons and layout automatically adapt to RTL
5. **Performance**: Navigation items create pages on demand

## Notes

- Bottom navigation shows only when `navigationItems` is provided
- Body is required even when using navigation items
- Navigation automatically switches between pages
- RTL layout is handled automatically for Arabic

