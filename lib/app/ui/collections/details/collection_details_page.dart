import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../modules/task/data/repositories/task_repository.dart';
import '../../../modules/collection/data/repositories/collection_repository.dart';
import '../../collections/widgets/add_task_bottom_sheet/add_task_bottom_sheet_view_model.dart';
import '../../collections/widgets/delete_collection_bottom_sheet/delete_collection_bottom_sheet_view_model.dart';
import '../../../app_widget.dart';
import '../../shared/widgets/filter_tabs.dart';
import '../../shared/widgets/tile_item.dart';
import '../widgets/add_task_bottom_sheet/add_task_bottom_sheet.dart';
import '../widgets/delete_collection_bottom_sheet/delete_collection_bottom_sheet.dart';
import '../widgets/form_collection_bottom_sheet/form_collection_bottom_sheet.dart';
import '../widgets/form_collection_bottom_sheet/form_collection_bottom_sheet_view_model.dart';

import 'collection_details_page_view_model.dart';

class CollectionDetailsArgument {
  final int taskId;

  CollectionDetailsArgument({required this.taskId});
}

class CollectionDetailsPage extends StatefulWidget {
  final CollectionDetailsArgument argument;

  CollectionDetailsPage({
    super.key,
    required this.argument,
  }) : assert(argument.taskId > 0);

  @override
  State<CollectionDetailsPage> createState() => _CollectionDetailsPageState();
}

class _CollectionDetailsPageState extends State<CollectionDetailsPage> {
  CollectionDetailsArgument get argument => widget.argument;

  late final CollectionDetailsPageViewModel viewModel =
      context.read<CollectionDetailsPageViewModel>();

  @override
  void initState() {
    super.initState();
    viewModel.getCollectionCommand.execute(argument.taskId);
  }

  void goToDetailsTask([int taskId = 1]) => //
      Navigator.of(context).pushNamed(
        RoutePaths.taskDetails.path,
        arguments: taskId,
      );

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
        listenable: viewModel,
        builder: (context, _) {
          final collection = viewModel.collection;
          final tasks = viewModel.tasks;

          return Scaffold(
            bottomNavigationBar: Container(
              height: 90,
              width: double.infinity,
              padding: EdgeInsets.all(12) + EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(top: BorderSide(width: 1, color: Colors.black)),
              ),
              child: ElevatedButton(
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    useRootNavigator: true,
                    isScrollControlled: true,
                    builder: (_) {
                      return ChangeNotifierProvider(
                        create: (_) => AddTaskBottomSheetViewModel(
                          context.read<ICollectionRepository>(),
                          context.read<ITaskRepository>(),
                        ),
                        child: AddTaskBottomSheet(
                          collection: collection,
                          onSuccess: () => //
                              viewModel.getCollectionCommand
                                  .execute(collection.id),
                        ),
                      );
                    },
                  );
                },
                child: Text('Add Task'),
              ),
            ),
            body: SafeArea(
              child: CustomScrollView(
                slivers: [
                  SliverAppBar(
                    centerTitle: true,
                    title: Text('Details Collection'),
                    leading: Padding(
                      padding: const EdgeInsets.only(left: 12),
                      child: Center(
                        child: GestureDetector(
                          onTap: Navigator.of(context).pop,
                          child: Container(
                            height: 42,
                            width: 42,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8)),
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
                          backgroundColor:
                              WidgetStateProperty.all(Colors.white),
                        ),
                        menuChildren: [
                          MenuItemButton(
                            child: Text('Editar'),
                            onPressed: () {
                              showModalBottomSheet(
                                  context: context,
                                  useRootNavigator: true,
                                  builder: (_) {
                                    return ChangeNotifierProvider(
                                      create: (_) =>
                                          FormCollectionBottomSheetViewModel(
                                        context.read<ICollectionRepository>(),
                                      ),
                                      child: FormCollectionBottomSheet.editable(
                                        collection: collection,
                                        onSuccess: () => viewModel
                                            .getCollectionCommand
                                            .execute(collection.id),
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
                                    create: (_) =>
                                        DeleteCollectionBottomSheetViewModel(
                                      context.read<ICollectionRepository>(),
                                    ),
                                    child: DeleteCollectionBottomSheet(
                                      collection: collection,
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
                  if (tasks.isNotEmpty)
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
                      childCount: tasks.length,
                      (context, index) {
                        final task = tasks[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12.0),
                          child: TileItem.verifiable(
                            onTap: () => goToDetailsTask(task.id),
                            title: task.title,
                            value: task.value,
                            onChanged: (_) {},
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
