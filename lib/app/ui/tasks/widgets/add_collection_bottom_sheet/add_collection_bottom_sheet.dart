import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../modules/task/domain/entities/task_entity.dart';
import '../../../../utils/functions.dart';
import '../../../shared/widgets/tile_item.dart';

import 'add_collection_bottom_sheet_view_model.dart';

class AddCollectionBottomSheet extends StatefulWidget {
  final TaskEntity task;

  final VoidCallback? onSuccess;

  const AddCollectionBottomSheet({
    super.key,
    this.onSuccess,
    required this.task,
  });

  @override
  State<AddCollectionBottomSheet> createState() =>
      _AddCollectionBottomSheetState();
}

class _AddCollectionBottomSheetState extends State<AddCollectionBottomSheet> {
  late final AddCollectionBottomSheetViewModel viewModel =
      context.read<AddCollectionBottomSheetViewModel>();

  final Debouncer deboucer = Debouncer(delay: Duration(milliseconds: 800));

  @override
  void initState() {
    super.initState();
    viewModel.addTaskOnCollectionCommand.addListener(listener);
    viewModel.getCollectionsCommand.execute();
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

  void onSelect(int collectionId) => //
      viewModel.addTaskOnCollectionCommand.execute((
        collectionId: collectionId,
        task: widget.task,
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
                    hintText: 'Buscar collection',
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
                    itemCount: viewModel.collections.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      final collection = viewModel.collections[index];
                      return TileItem.preview(
                        onTap: () => onSelect(collection.id),
                        title: collection.title,
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        });
  }
}
