import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../modules/collection/domain/entities/collection_entity.dart';
import '../../../../modules/task/domain/entities/task_entity.dart';
import '../../../shared/widgets/tile_item.dart';
import '../../../../utils/functions.dart';

import 'add_task_bottom_sheet_view_model.dart';

class AddTaskBottomSheet extends StatefulWidget {
  final CollectionEntity collection;

  final VoidCallback? onSuccess;

  const AddTaskBottomSheet({
    super.key,
    required this.collection,
    this.onSuccess,
  });

  @override
  State<AddTaskBottomSheet> createState() => _AddTaskBottomSheetState();
}

class _AddTaskBottomSheetState extends State<AddTaskBottomSheet> {
  late final AddTaskBottomSheetViewModel viewModel =
      context.read<AddTaskBottomSheetViewModel>();

  final Debouncer deboucer = Debouncer(delay: Duration(milliseconds: 800));

  @override
  void initState() {
    super.initState();

    viewModel.addTaskOnCollectionCommand.addListener(listener);
    viewModel.getTasksCommand.execute();
  }

  listener() {
    if (viewModel.addTaskOnCollectionCommand.completed) {
      widget.onSuccess?.call();
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: Duration(milliseconds: 800),
          content: Text('Success!'),
        ),
      );
    }

    if (viewModel.addTaskOnCollectionCommand.error) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: Duration(seconds: 1),
          content: Text('Error!'),
        ),
      );
    }
  }

  @override
  void dispose() {
    viewModel.addTaskOnCollectionCommand.removeListener(listener);
    deboucer.cancel();
    super.dispose();
  }

  void search(String term) => deboucer.run(() => viewModel.search(term));

  void onSelect(TaskEntity task) => //
      viewModel.addTaskOnCollectionCommand.execute((
        collectionId: widget.collection.id,
        task: task,
      ));

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
        listenable: viewModel,
        builder: (context, _) {
          return Container(
            width: double.infinity,
            padding: EdgeInsets.all(12.0) + EdgeInsets.symmetric(vertical: 24),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12.0),
                topRight: Radius.circular(12.0),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  onChanged: search,
                  decoration: InputDecoration(
                    hintText: 'Buscar task',
                    fillColor: Colors.white,
                    filled: true,
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        width: 1,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 12),
                ConstrainedBox(
                  constraints: BoxConstraints(
                      maxHeight: MediaQuery.sizeOf(context).height * 0.75),
                  child: ListView.builder(
                    itemCount: viewModel.tasks.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      final task = viewModel.tasks[index];
                      return TileItem(
                          onTap: () => onSelect(task), title: task.title);
                    },
                  ),
                ),
              ],
            ),
          );
        });
  }
}
