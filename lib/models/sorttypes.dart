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
