import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../modules/task/domain/dtos/task_dto.dart';
import '../../../../modules/task/domain/entities/task_entity.dart';

import '../../../shared/widgets/primary_button.dart';
import 'form_task_bottom_sheet_view_model.dart';

class FormTaskBottomSheet extends StatefulWidget {
  const FormTaskBottomSheet._({
    required this.editable,
    this.task,
  });

  factory FormTaskBottomSheet.create() => FormTaskBottomSheet._(
        editable: false,
      );

  factory FormTaskBottomSheet.editable({
    required TaskEntity task,
  }) =>
      FormTaskBottomSheet._(
        editable: true,
        task: task,
      );

  final bool editable;

  final TaskEntity? task;

  @override
  State<FormTaskBottomSheet> createState() => _FormTaskBottomSheetState();
}

class _FormTaskBottomSheetState extends State<FormTaskBottomSheet> {
  late final FormTaskBottomSheetViewModel viewModel =
      context.read<FormTaskBottomSheetViewModel>();

  final formKey = GlobalKey<FormState>();
  TaskDto dto = TaskDto.empty();

  @override
  void initState() {
    super.initState();
    viewModel.addTaskCommand.addListener(listenerAdd);
    viewModel.updateTaskCommand.addListener(listenerUpdate);

    if (widget.editable) {
      dto = TaskDto(id: widget.task!.id, title: widget.task!.title);
    }
  }

  listenerAdd() {
    if (viewModel.addTaskCommand.completed) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: Duration(seconds: 1),
          content: Text('Success!'),
        ),
      );
    }

    if (viewModel.addTaskCommand.error) {
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
    if (viewModel.updateTaskCommand.completed) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: Duration(milliseconds: 800),
          content: Text('Success!'),
        ),
      );
    }

    if (viewModel.updateTaskCommand.error) {
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
    viewModel.addTaskCommand.removeListener(listenerAdd);
    viewModel.updateTaskCommand.removeListener(listenerUpdate);
    super.dispose();
  }

  onSubmit(TaskDto dto) {
    if (formKey.currentState!.validate()) {
      if (widget.editable) {
        viewModel.updateTaskCommand.execute(dto);
      } else {
        viewModel.addTaskCommand.execute(dto);
        Future.microtask(() {
          if (context.mounted) {
            Navigator.of(context).pop();
          }
        });
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
                widget.editable ? 'Edit Task' : 'Add Task',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              TextFormField(
                initialValue: dto.title,
                onChanged: dto.setTitle,
                decoration: InputDecoration(
                  hintText: 'Digite o nome da task',
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
