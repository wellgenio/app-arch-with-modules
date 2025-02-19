import 'package:flutter/material.dart';

enum FilterTabsValue {
  all,
  doValue,
  completed,
}

class FilterTabs extends StatefulWidget {
  const FilterTabs({
    super.key,
    this.initialValue = FilterTabsValue.all,
    required this.onAll,
    required this.onDo,
    required this.onCompleted,
  });

  final FilterTabsValue initialValue;

  final VoidCallback onAll;
  final VoidCallback onDo;
  final VoidCallback onCompleted;

  @override
  State<FilterTabs> createState() => _FilterTabsState();
}

class _FilterTabsState extends State<FilterTabs> {
  final tabValue = ValueNotifier(FilterTabsValue.all);

  @override
  void initState() {
    super.initState();

    if (widget.initialValue != FilterTabsValue.all) {
      tabValue.value = widget.initialValue;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: tabValue,
        builder: (context, state, _) {
          return Row(
            children: [
              TextButton(
                onPressed: () {
                  tabValue.value = FilterTabsValue.all;
                  widget.onAll();
                },
                child: Text(
                  'All',
                  style: TextStyle(
                    color: state == FilterTabsValue.all
                        ? Colors.purple
                        : Colors.black87,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  tabValue.value = FilterTabsValue.doValue;
                  widget.onDo();
                },
                child: Text(
                  'Do',
                  style: TextStyle(
                    color: state == FilterTabsValue.doValue
                        ? Colors.purple
                        : Colors.black87,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  tabValue.value = FilterTabsValue.completed;
                  widget.onCompleted();
                },
                child: Text(
                  'Completed',
                  style: TextStyle(
                    color: state == FilterTabsValue.completed
                        ? Colors.purple
                        : Colors.black87,
                  ),
                ),
              ),
            ],
          );
        });
  }
}
