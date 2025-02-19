import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../modules/task/domain/entities/task_entity.dart';

import 'delete_task_bottom_sheet_view_model.dart';

class DeleteTaskBottomSheet extends StatefulWidget {
  const DeleteTaskBottomSheet({
    super.key,
    required this.task,
    this.onSuccess,
  });

  final TaskEntity task;

  final VoidCallback? onSuccess;


  @override
  State<DeleteTaskBottomSheet> createState() => _DeleteTaskBottomSheetState();
}

class _DeleteTaskBottomSheetState extends State<DeleteTaskBottomSheet> {
  late final DeleteTaskBottomSheetViewModel viewModel = context.read<DeleteTaskBottomSheetViewModel>();

  @override
  void initState() {
    super.initState();
    viewModel.deleteTaskCommand.addListener(listener);
  }

  listener() {
    if (viewModel.deleteTaskCommand.completed) {
      widget.onSuccess?.call();
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: Duration(milliseconds: 800),
          content: Text('Success!'),
        ),
      );
    }

    if (viewModel.deleteTaskCommand.error) {
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
    viewModel.deleteTaskCommand.removeListener(listener);
    super.dispose();
  }

  onConfirm() {
    viewModel.deleteTaskCommand.execute(widget.task);
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
            'Deletar Task',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            'Tem certeza que seja deletar essa task?',
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
