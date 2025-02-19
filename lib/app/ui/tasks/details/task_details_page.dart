import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../modules/collection/data/repositories/collection_repository.dart';
import '../../../modules/task/data/repositories/task_repository.dart';
import '../widgets/add_collection_bottom_sheet/add_collection_bottom_sheet_view_model.dart';
import '../widgets/add_collection_bottom_sheet/add_collection_bottom_sheet.dart';
import '../widgets/delete_task_bottom_sheet/delete_task_bottom_sheet.dart';
import '../widgets/delete_task_bottom_sheet/delete_task_bottom_sheet_view_model.dart';
import '../widgets/form_task_bottom_sheet/form_task_bottom_sheet.dart';
import '../widgets/form_task_bottom_sheet/form_task_bottom_sheet_view_model.dart';

import 'task_details_page_view_model.dart';

class TaskDetailsArgument {
  final int taskId;

  TaskDetailsArgument({required this.taskId});
}

class TaskDetailsPage extends StatefulWidget {
  final TaskDetailsArgument argument;

  TaskDetailsPage({super.key, required this.argument}) //
      : assert(argument.taskId > 0);

  @override
  State<TaskDetailsPage> createState() => _TaskDetailsPageState();
}

class _TaskDetailsPageState extends State<TaskDetailsPage> {
  TaskDetailsArgument get argument => widget.argument;

  late final TaskDetailsPageViewModel viewModel =
      context.read<TaskDetailsPageViewModel>();

  @override
  void initState() {
    super.initState();
    viewModel.getTaskCommand.execute(argument.taskId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListenableBuilder(
          listenable: viewModel,
          builder: (context, _) {
            final task = viewModel.task;

            return CustomScrollView(
              slivers: [
                SliverAppBar(
                  centerTitle: true,
                  title: Container(
                    padding:
                        EdgeInsets.symmetric(vertical: 8.0, horizontal: 24.0),
                    decoration: BoxDecoration(
                      color: Colors.black87,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Text(
                      'Details Task',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  leading: Padding(
                    padding: const EdgeInsets.only(left: 12),
                    child: Center(
                      child: GestureDetector(
                        onTap: Navigator.of(context).pop,
                        child: Container(
                          height: 36,
                          width: 36,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(36),
                            border: Border.all(color: Colors.black, width: 1),
                          ),
                          child: Icon(Icons.arrow_back),
                        ),
                      ),
                    ),
                  ),
                  actions: [
                    MenuAnchor(
                      style: MenuStyle(
                        backgroundColor: WidgetStateProperty.all(Colors.white),
                      ),
                      menuChildren: [
                        MenuItemButton(
                          child: Text('Adicionar na coleção'),
                          onPressed: () {
                            showModalBottomSheet(
                                context: context,
                                useRootNavigator: true,
                                isScrollControlled: true,
                                builder: (_) {
                                  return ChangeNotifierProvider(
                                    create: (_) =>
                                        AddCollectionBottomSheetViewModel(
                                      context.read<ICollectionRepository>(),
                                    ),
                                    child: AddCollectionBottomSheet(
                                      task: task,
                                      onSuccess: () => viewModel.getTaskCommand
                                          .execute(task.id),
                                    ),
                                  );
                                });
                          },
                        ),
                        MenuItemButton(
                          child: Text('Editar'),
                          onPressed: () {
                            showModalBottomSheet(
                                context: context,
                                useRootNavigator: true,
                                builder: (_) {
                                  return ChangeNotifierProvider(
                                    create: (_) => FormTaskBottomSheetViewModel(
                                      context.read<ITaskRepository>(),
                                    ),
                                    child: FormTaskBottomSheet.editable(
                                      task: task,
                                      onSuccess: () {
                                        viewModel.getTaskCommand
                                            .execute(task.id);
                                      },
                                    ),
                                  );
                                });
                          },
                        ),
                        MenuItemButton(
                          child: Text(
                            'Deletar',
                            style: TextStyle(color: Colors.red),
                          ),
                          onPressed: () {
                            showModalBottomSheet(
                              context: context,
                              useRootNavigator: true,
                              builder: (_) {
                                return ChangeNotifierProvider(
                                  create: (_) => DeleteTaskBottomSheetViewModel(
                                    context.read<ITaskRepository>(),
                                  ),
                                  child: DeleteTaskBottomSheet(
                                    task: task,
                                    onSuccess: Navigator.of(context).pop,
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ],
                      builder: (context, controller, __) {
                        return IconButton(
                          icon: Icon(Icons.more_vert, color: Colors.black),
                          onPressed: controller.open,
                        );
                      },
                    ),
                  ],
                ),
                SliverFillRemaining(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12) +
                        EdgeInsets.only(top: 24),
                    child: Column(
                      spacing: 12,
                      children: [
                        Flexible(
                          flex: 1,
                          child: ColoredBox(
                            color: Colors.white,
                            child: Placeholder(),
                          ),
                        ),
                        Flexible(
                          flex: 2,
                          child: Text(
                            task.title,
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 24),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }),
    );
  }
}
