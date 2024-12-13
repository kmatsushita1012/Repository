import 'package:flutter/material.dart';

enum SortTypes {
  stars,
  forks,
  isuues,
  updated;

  String toString() {
    if (this == SortTypes.isuues) {
      return "help-wanted-issues";
    } else {
      return name;
    }
  }

  String text() {
    switch (this) {
      case SortTypes.stars:
        return "Stars";
      case SortTypes.forks:
        return "Forks";
      case SortTypes.isuues:
        return "Issues";
      case SortTypes.updated:
        return "Last Updated";
    }
  }

  IconData icon() {
    switch (this) {
      case SortTypes.stars:
        return Icons.star;
      case SortTypes.forks:
        return Icons.fork_right;
      case SortTypes.isuues:
        return Icons.priority_high;
      case SortTypes.updated:
        return Icons.update;
    }
  }
}
