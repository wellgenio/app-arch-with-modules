import 'package:flutter/material.dart';

class TileItem extends StatelessWidget {
  const TileItem._({
    required this.onTap,
    required this.title,
    this.onChanged,
    this.value,
    this.menuChildren,
    required this.verifiable,
  });

  factory TileItem.preview({
    required VoidCallback onTap,
    required String title,
    List<MenuItemButton>? menuChildren,
  }) =>
      TileItem._(
        onTap: onTap,
        title: title,
        menuChildren: menuChildren,
        verifiable: false,
      );

  factory TileItem.verifiable({
    required VoidCallback onTap,
    required String title,
    List<MenuItemButton>? menuChildren,
    required ValueChanged<bool?> onChanged,
    required bool value,
  }) =>
      TileItem._(
        onChanged: onChanged,
        value: value,
        onTap: onTap,
        title: title,
        menuChildren: menuChildren,
        verifiable: true,
      );

  final bool verifiable;

  final VoidCallback onTap;

  final ValueChanged<bool?>? onChanged;

  final bool? value;

  final List<MenuItemButton>? menuChildren;

  final String title;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 80,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.black, width: 1),
        ),
        margin: EdgeInsets.symmetric(vertical: 12.0),
        child: Row(mainAxisSize: MainAxisSize.max, children: [
          Container(
            margin: EdgeInsets.all(8.0),
            width: 70,
            child: const Placeholder(),
          ),
          SizedBox(width: 12.0),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 20,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          if (verifiable) Checkbox(value: value, onChanged: onChanged),
          if (menuChildren != null)
            MenuAnchor(
              style: MenuStyle(
                backgroundColor: WidgetStateProperty.all(Colors.white),
              ),
              menuChildren: menuChildren ?? [],
              builder: (context, controller, __) {
                return IconButton(
                  icon: Icon(Icons.more_vert, color: Colors.black),
                  onPressed: controller.open,
                );
              },
            ),
        ]),
      ),
    );
  }
}
