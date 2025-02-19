import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../modules/collection/domain/entities/collection_entity.dart';
import 'delete_collection_bottom_sheet_view_model.dart';

class DeleteCollectionBottomSheet extends StatefulWidget {
  final CollectionEntity collection;

  final VoidCallback? onSuccess;

  const DeleteCollectionBottomSheet({
    super.key,
    this.onSuccess,
    required this.collection,
  });

  @override
  State<DeleteCollectionBottomSheet> createState() =>
      _DeleteCollectionBottomSheetState();
}

class _DeleteCollectionBottomSheetState
    extends State<DeleteCollectionBottomSheet> {
  late final DeleteCollectionBottomSheetViewModel viewModel = context.read<DeleteCollectionBottomSheetViewModel>();

  @override
  void initState() {
    super.initState();
    viewModel.deleteCollectionCommand.addListener(listener);
  }

  listener() {
    if (viewModel.deleteCollectionCommand.completed) {
      widget.onSuccess?.call();
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: Duration(milliseconds: 800),
          content: Text('Success!'),
        ),
      );
    }

    if (viewModel.deleteCollectionCommand.error) {
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
  dispose() {
    viewModel.deleteCollectionCommand.removeListener(listener);
    super.dispose();
  }

  onConfirm() {
    viewModel.deleteCollectionCommand.execute(widget.collection);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(12.0) + EdgeInsets.symmetric(vertical: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12.0),
          topRight: Radius.circular(12.0),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        spacing: 24.0,
        children: [
          Text(
            'Deletar Collection',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            'Tem certeza que seja deletar essa collection?',
            style: TextStyle(
              fontSize: 18,
            ),
          ),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: onConfirm,
              child: Text('Confirmar'),
            ),
          )
        ],
      ),
    );
  }
}
