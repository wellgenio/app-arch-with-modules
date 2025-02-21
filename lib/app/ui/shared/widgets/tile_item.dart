import 'package:flutter/material.dart';

class TileItem extends StatefulWidget {
  const TileItem._({
    required this.onTap,
    required this.title,
    this.onChanged,
    this.value,
    this.menuChildren,
    required this.verifiable,
    required this.disable,
  });

  factory TileItem.preview({
    required VoidCallback onTap,
    required String title,
    List<MenuItemButton>? menuChildren,
    bool? value,
    bool? disable,
  }) =>
      TileItem._(
        onTap: onTap,
        title: title,
        menuChildren: menuChildren,
        verifiable: false,
        value: value,
        disable: disable ?? false,
      );

  factory TileItem.verifiable({
    required VoidCallback onTap,
    required String title,
    List<MenuItemButton>? menuChildren,
    required ValueChanged<bool?> onChanged,
    required bool value,
    bool? disable,
  }) =>
      TileItem._(
        onChanged: onChanged,
        value: value,
        onTap: onTap,
        title: title,
        menuChildren: menuChildren,
        verifiable: true,
        disable: disable ?? false,
      );

  final bool verifiable;

  final VoidCallback onTap;

  final ValueChanged<bool?>? onChanged;

  final bool? value;

  final List<MenuItemButton>? menuChildren;

  final String title;

  final bool disable;

  @override
  State<TileItem> createState() => _TileItemState();
}

class _TileItemState extends State<TileItem> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );

    _animation = Tween<double>(begin: 0.97, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    if (widget.disable) {
      _controller.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(covariant TileItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.disable) {
      _controller.repeat(reverse: true);
    } else {
      _controller.stop();
      _controller.value = 1.0;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.scale(
            scale: widget.disable ? _animation.value : 1.0,
            child: child,
          );
        },
        child: Container(
          height: 80,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.black, width: 1),
          ),
          margin: EdgeInsets.symmetric(vertical: 12.0),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              if (widget.verifiable)
                Checkbox(
                  value: widget.value,
                  onChanged: widget.disable ? null : widget.onChanged,
                ),
              SizedBox(width: 12.0),
              if (!widget.verifiable) SizedBox(width: 12.0),
              Expanded(
                child: Text(
                  widget.title,
                  style: TextStyle(
                    fontSize: 20,
                    overflow: TextOverflow.ellipsis,
                    color: widget.disable ? Colors.grey : Colors.black,
                  ),
                ),
              ),
              if (widget.menuChildren != null && !widget.disable)
                MenuAnchor(
                  style: MenuStyle(
                    backgroundColor: WidgetStateProperty.all(Colors.white),
                  ),
                  menuChildren: widget.menuChildren ?? [],
                  builder: (context, controller, __) {
                    return IconButton(
                      icon: Icon(Icons.more_vert, color: Colors.black),
                      onPressed: controller.open,
                    );
                  },
                ),
              if (widget.verifiable == false && widget.value == true)
                Container(
                  color: Colors.black87,
                  margin: EdgeInsets.only(right: 24),
                  child: Icon(Icons.check, color: Colors.white),
                )
            ],
          ),
        ),
      ),
    );
  }
}
