import 'package:flutter/material.dart';

class TileItem extends StatelessWidget {
  const TileItem(
      {super.key, required this.onTap, required this.title, this.menuChildren});

  final VoidCallback onTap;

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
          Text(title, style: TextStyle(fontSize: 20)),
          Spacer(),
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
