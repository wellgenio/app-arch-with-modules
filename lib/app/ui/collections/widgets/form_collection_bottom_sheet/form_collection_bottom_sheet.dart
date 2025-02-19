import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../modules/collection/domain/dtos/collection_dto.dart';
import '../../../../modules/collection/domain/entities/collection_entity.dart';

import '../../../shared/widgets/primary_button.dart';
import 'form_collection_bottom_sheet_view_model.dart';

class FormCollectionBottomSheet extends StatefulWidget {
  const FormCollectionBottomSheet._({
    required this.editable,
    this.collection,
    this.onSuccess,
  });

  factory FormCollectionBottomSheet.create({
    VoidCallback? onSuccess,
  }) => //
      FormCollectionBottomSheet._(
        editable: false,
        onSuccess: onSuccess,
      );

  factory FormCollectionBottomSheet.editable({
    required CollectionEntity collection,
    VoidCallback? onSuccess,
  }) => //
      FormCollectionBottomSheet._(
        editable: true,
        collection: collection,
        onSuccess: onSuccess,
      );

  final bool editable;

  final CollectionEntity? collection;

  final VoidCallback? onSuccess;

  @override
  State<FormCollectionBottomSheet> createState() =>
      _FormCollectionBottomSheetState();
}

class _FormCollectionBottomSheetState extends State<FormCollectionBottomSheet> {
  late final FormCollectionBottomSheetViewModel viewModel =
      context.read<FormCollectionBottomSheetViewModel>();

  final formKey = GlobalKey<FormState>();
  CollectionDto dto = CollectionDto.empty();

  @override
  void initState() {
    super.initState();
    viewModel.addCollectionCommand.addListener(listenerAdd);
    viewModel.updateCollectionCommand.addListener(listenerUpdate);

    if (widget.editable) {
      dto = CollectionDto(
        id: widget.collection!.id,
        title: widget.collection!.title,
        tasks: widget.collection!.tasks,
      );
    }
  }

  listenerAdd() {
    if (viewModel.addCollectionCommand.completed) {
      widget.onSuccess?.call();
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: Duration(seconds: 1),
          content: Text('Success!'),
        ),
      );
    }

    if (viewModel.addCollectionCommand.error) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: Duration(seconds: 1),
          content: Text('Error!'),
        ),
      );
    }
  }

  listenerUpdate() {
    if (viewModel.updateCollectionCommand.completed) {
      widget.onSuccess?.call();
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: Duration(milliseconds: 800),
          content: Text('Success!'),
        ),
      );
    }

    if (viewModel.updateCollectionCommand.error) {
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
    viewModel.addCollectionCommand.removeListener(listenerAdd);
    viewModel.updateCollectionCommand.removeListener(listenerUpdate);
    super.dispose();
  }

  onSubmit(CollectionDto dto) {
    if (formKey.currentState!.validate()) {
      if (widget.editable) {
        viewModel.updateCollectionCommand.execute(dto);
      } else {
        viewModel.addCollectionCommand.execute(dto);
      }
    }
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
      child: Form(
        key: formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            spacing: 24.0,
            children: [
              Text(
                widget.editable ? 'Edit Collection' : 'Add Collection',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              TextFormField(
                initialValue: dto.title,
                onChanged: dto.setTitle,
                decoration: InputDecoration(
                  hintText: 'Digite o nome da collection',
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
              SizedBox(
                width: double.infinity,
                height: 50,
                child: PrimaryButton(
                  onPressed: () => onSubmit(dto),
                  child: Text(widget.editable ? 'Edit' : 'Add'),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
