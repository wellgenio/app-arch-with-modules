import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../modules/collection/data/repositories/collection_repository.dart';
import '../../modules/task/data/repositories/task_repository.dart';
import '../../modules/task/domain/dtos/task_dto.dart';
import '../../routing/router.dart';
import '../shared/widgets/filter_tabs.dart';
import '../shared/widgets/primary_button.dart';
import '../tasks/tasks_page_view_model.dart';
import '../tasks/widgets/add_collection_bottom_sheet/add_collection_bottom_sheet.dart';
import '../tasks/widgets/add_collection_bottom_sheet/add_collection_bottom_sheet_view_model.dart';
import '../tasks/widgets/form_task_bottom_sheet/form_task_bottom_sheet_view_model.dart';
import '../shared/widgets/tile_item.dart';

import 'widgets/delete_task_bottom_sheet/delete_task_bottom_sheet.dart';
import 'widgets/delete_task_bottom_sheet/delete_task_bottom_sheet_view_model.dart';
import 'widgets/form_task_bottom_sheet/form_task_bottom_sheet.dart';

class TasksPage extends StatefulWidget {
  const TasksPage({super.key});

  @override
  State<TasksPage> createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage> {
  late final TasksPageViewModel viewModel = context.read<TasksPageViewModel>();

  final formKey = GlobalKey<FormState>();
  final dto = TaskDto.empty();

  @override
  void initState() {
    super.initState();
    viewModel.getTasksCommand.execute();
  }

  void goToDetails([String taskId = '1']) => //
      Navigator.of(context).pushNamed(
        RoutePaths.taskDetails.path,
        arguments: taskId,
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Container(
        height: 80,
        width: double.infinity,
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(width: 1, color: Colors.black)),
        ),
        child: PrimaryButton(
          onPressed: () {
            showModalBottomSheet(
              context: context,
              useRootNavigator: true,
              builder: (_) {
                return ChangeNotifierProvider(
                  create: (_) => FormTaskBottomSheetViewModel(
                    context.read<ITaskRepository>(),
                  ),
                  child: FormTaskBottomSheet.create(
                  ),
                );
              },
            );
          },
          child: Text('Add Task'),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: ListenableBuilder(
            listenable: Listenable.merge([
              viewModel,
              viewModel.getTasksCommand,
            ]),
            builder: (context, _) {
              return CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 12.0),
                      child: FilterTabs(
                        onAll: viewModel.onAll,
                        onDo: viewModel.onDo,
                        onCompleted: viewModel.onCompleted,
                      ),
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                        childCount: viewModel.tasks.length, (context, index) {
                      final task = viewModel.tasks[index];
                      return TileItem.verifiable(
                        onTap: () => goToDetails(task.id),
                        title: task.title,
                        value: task.value,
                        disable: (viewModel.optimisticKey == task.id),
                        onChanged: (value) => viewModel.checkedCommand
                            .execute((value: value ?? false, task: task)),
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
                                        onSuccess:
                                            viewModel.getTasksCommand.execute,
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
                                    ),
                                  );
                                },
                              );
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
                                    create: (_) =>
                                        DeleteTaskBottomSheetViewModel(
                                      context.read<ITaskRepository>(),
                                    ),
                                    child: DeleteTaskBottomSheet(
                                      task: task,
                                      onSuccess:
                                          viewModel.getTasksCommand.execute,
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        ],
                      );
                    }),
                  ),
                ],
              );
            }),
      ),
    );
  }
}
