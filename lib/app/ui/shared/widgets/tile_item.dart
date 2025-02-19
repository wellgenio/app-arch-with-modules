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
    bool? value,
  }) =>
      TileItem._(
        onTap: onTap,
        title: title,
        menuChildren: menuChildren,
        verifiable: false,
        value: value,
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
          if (verifiable) Checkbox(value: value, onChanged: onChanged),
          SizedBox(width: 12.0),
          if (!verifiable) SizedBox(width: 12.0),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 20,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
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
          if (verifiable == false && value == true)
            Container(
              color: Colors.black87,
              margin: EdgeInsets.only(right: 24),
              child: Icon(Icons.check, color: Colors.white),
            )
        ]),
      ),
    );
  }
}
