import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:repository/models/sorttypes.dart';
import 'package:repository/providers/repository_provider.dart';

//ソート方法選択
class SortButton extends StatelessWidget {
  final void Function(SortTypes) onSelected;
  const SortButton({super.key, required this.onSelected});

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Consumer<RepositoryProvider>(
      builder: (context, provider, _) => PopupMenuButton<SortTypes>(
        onSelected: onSelected,
        itemBuilder: (BuildContext context) {
          //Popup時
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
                      item.toText(context),
                      style: const TextStyle(fontSize: 16),
                    )
                  ],
                ));
          }).toList();
        },
        //通常時
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
