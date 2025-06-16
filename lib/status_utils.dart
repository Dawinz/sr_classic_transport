import 'package:flutter/material.dart';

/// Determines if a cargo has arrived based on the status string.
/// Currently checks for common keywords like "arrived", "delivered" or "out".
bool cargoArrived(String? status) {
  if (status == null) return false;
  final lower = status.toLowerCase();
  return lower.contains('arrived') ||
      lower.contains('delivered') ||
      lower.contains('out');
}

/// Returns the color to use for a cargo based on arrival status.
Color statusColor(String? status) {
  return cargoArrived(status) ? Colors.red : Colors.blue;
}
