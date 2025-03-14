import 'package:flutter/material.dart';
import 'package:modular_di_app/app/ui/shared/widgets/primary_button.dart';
import 'package:provider/provider.dart';

import '../../../modules/task/data/repositories/task_repository.dart';
import '../../../modules/collection/data/repositories/collection_repository.dart';
import '../../../routing/router.dart';
import '../../collections/widgets/add_task_bottom_sheet/add_task_bottom_sheet_view_model.dart';
import '../../collections/widgets/delete_collection_bottom_sheet/delete_collection_bottom_sheet_view_model.dart';
import '../../shared/widgets/filter_tabs.dart';
import '../../shared/widgets/tile_item.dart';
import '../widgets/add_task_bottom_sheet/add_task_bottom_sheet.dart';
import '../widgets/delete_collection_bottom_sheet/delete_collection_bottom_sheet.dart';
import '../widgets/form_collection_bottom_sheet/form_collection_bottom_sheet.dart';
import '../widgets/form_collection_bottom_sheet/form_collection_bottom_sheet_view_model.dart';

import 'collection_details_page_view_model.dart';

class CollectionDetailsArgument {
  final String collectionId;

  CollectionDetailsArgument({required this.collectionId});
}

class CollectionDetailsPage extends StatefulWidget {
  final CollectionDetailsArgument argument;

  CollectionDetailsPage({
    super.key,
    required this.argument,
  }) : assert(argument.collectionId.isNotEmpty);

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
    viewModel.getCollectionCommand.execute(argument.collectionId);
  }

  void goToDetailsTask([String taskId = '1']) => //
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
              child: PrimaryButton(
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
                    title: Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 8.0, horizontal: 24.0),
                      decoration: BoxDecoration(
                        color: Colors.black87,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Text(
                        collection.title,
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
                  if (viewModel.hasTasks)
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
                            onChanged: (value) =>
                                viewModel.checkedCommand.execute((
                              task: task,
                              value: value!,
                              collectionId: collection.id,
                            )),
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
