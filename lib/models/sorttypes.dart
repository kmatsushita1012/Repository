import 'package:flutter/material.dart';

enum SortTypes {
  match,
  stars,
  forks,
  isuues,
  updated;

  String? toQueryString() {
    if (this == SortTypes.match) {
      return null;
    } else if (this == SortTypes.isuues) {
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
      case SortTypes.match:
        return "Best Match";
    }
  }

  IconData icon() {
    switch (this) {
      case SortTypes.stars:
        return Icons.star;
      case SortTypes.forks:
        return Icons.fork_right;
      case SortTypes.isuues:
        return Icons.adjust;
      case SortTypes.updated:
        return Icons.update;
      case SortTypes.match:
        return Icons.thumb_up;
    }
  }
}
