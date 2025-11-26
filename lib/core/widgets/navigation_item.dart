import 'package:flutter/material.dart';

/// Model for bottom navigation items
class NavigationItem {
  final String label;
  final IconData icon;
  final IconData? selectedIcon;
  final int index;
  final Widget page;

  const NavigationItem({
    required this.label,
    required this.icon,
    this.selectedIcon,
    required this.index,
    required this.page,
  });
}
