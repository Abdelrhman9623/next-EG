import 'package:flutter/material.dart';
import 'package:next_app/core/widgets/navigation_item.dart';

/// Base layout with app bar and bottom navigation
/// Provides a consistent layout structure across the app
class BaseLayout extends StatefulWidget {
  final String? title;
  final Widget body;
  final List<NavigationItem>? navigationItems;
  final int? currentIndex;
  final ValueChanged<int>? onNavigationTap;
  final List<Widget>? actions;
  final Widget? leading;
  final bool automaticallyImplyLeading;
  final PreferredSizeWidget? bottom;
  final Color? backgroundColor;
  final Color? appBarBackgroundColor;
  final bool showAppBar;
  final bool showBottomNavigation;

  const BaseLayout({
    super.key,
    this.title,
    required this.body,
    this.navigationItems,
    this.currentIndex,
    this.onNavigationTap,
    this.actions,
    this.leading,
    this.automaticallyImplyLeading = true,
    this.bottom,
    this.backgroundColor,
    this.appBarBackgroundColor,
    this.showAppBar = true,
    this.showBottomNavigation = true,
  });

  @override
  State<BaseLayout> createState() => _BaseLayoutState();
}

class _BaseLayoutState extends State<BaseLayout> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.currentIndex ?? 0;
  }

  @override
  void didUpdateWidget(BaseLayout oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.currentIndex != null && widget.currentIndex != _currentIndex) {
      _currentIndex = widget.currentIndex!;
    }
  }

  void _onNavigationTap(int index) {
    if (widget.onNavigationTap != null) {
      widget.onNavigationTap!(index);
    } else {
      setState(() {
        _currentIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentPage =
        widget.navigationItems != null && widget.navigationItems!.isNotEmpty
        ? widget.navigationItems![_currentIndex].page
        : widget.body;

    return Scaffold(
      backgroundColor:
          widget.backgroundColor ?? Theme.of(context).scaffoldBackgroundColor,
      appBar: widget.showAppBar
          ? AppBar(
              title: widget.title != null ? Text(widget.title!) : null,
              leading: widget.leading,
              automaticallyImplyLeading: widget.automaticallyImplyLeading,
              actions: widget.actions,
              bottom: widget.bottom,
              backgroundColor: widget.appBarBackgroundColor,
              elevation: 0,
            )
          : null,
      body: currentPage,
      bottomNavigationBar:
          widget.showBottomNavigation &&
              widget.navigationItems != null &&
              widget.navigationItems!.isNotEmpty
          ? BottomNavigationBar(
              currentIndex: _currentIndex,
              onTap: _onNavigationTap,
              type: BottomNavigationBarType.fixed,
              items: widget.navigationItems!.map((item) {
                return BottomNavigationBarItem(
                  icon: Icon(
                    _currentIndex == item.index
                        ? (item.selectedIcon ?? item.icon)
                        : item.icon,
                  ),
                  label: item.label,
                );
              }).toList(),
            )
          : null,
    );
  }
}
