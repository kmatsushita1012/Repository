import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:repository/models/sorttypes.dart';
import 'package:repository/providers/repository_provider.dart';

class SortButton extends StatelessWidget {
  const SortButton({super.key});

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Consumer<RepositoryProvider>(
      builder: (context, provider, _) => PopupMenuButton<SortTypes>(
        onSelected: (value) => provider.setSortType(value),
        itemBuilder: (BuildContext context) {
          return SortTypes.values.map((item) {
            return PopupMenuItem<SortTypes>(
                value: item,
                child: Row(
                  children: [
                    Icon(item.icon()),
                    const SizedBox(
                      width: 8,
                    ),
                    Text(
                      item.text(),
                      style: const TextStyle(fontSize: 16),
                    )
                  ],
                ));
          }).toList();
        },
        child: Container(
            decoration: BoxDecoration(
                color: colorScheme.secondaryContainer,
                border: Border.all(color: colorScheme.onSurface),
                borderRadius: BorderRadius.circular(8)),
            child: Icon(
              provider.sortType.icon(),
              size: 32,
            )),
      ),
    );
  }
}
