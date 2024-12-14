import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

enum SortTypes {
  match,
  updated,
  stars,
  forks,
  isuues;

  String? toQueryString() {
    if (this == SortTypes.match) {
      return null;
    } else if (this == SortTypes.isuues) {
      return "help-wanted-issues";
    } else {
      return name;
    }
  }

  String text(BuildContext context) {
    switch (this) {
      case SortTypes.stars:
        return AppLocalizations.of(context)!.stars;
      case SortTypes.forks:
        return AppLocalizations.of(context)!.forks;
      case SortTypes.isuues:
        return AppLocalizations.of(context)!.issues;
      case SortTypes.updated:
        return AppLocalizations.of(context)!.last_updated;
      case SortTypes.match:
        return AppLocalizations.of(context)!.best_match;
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
