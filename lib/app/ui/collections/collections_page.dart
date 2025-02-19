import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../modules/collection/data/repositories/collection_repository.dart';
import '../collections/collections_page_view_model.dart';
import '../collections/widgets/form_collection_bottom_sheet/form_collection_bottom_sheet_view_model.dart';
import '../../app_widget.dart';
import '../shared/widgets/tile_item.dart';

import 'widgets/form_collection_bottom_sheet/form_collection_bottom_sheet.dart';

class CollectionsPage extends StatefulWidget {
  const CollectionsPage({super.key});

  @override
  State<CollectionsPage> createState() => _CollectionsPageState();
}

class _CollectionsPageState extends State<CollectionsPage> {
  late final CollectionsPageViewModel viewModel =
      context.read<CollectionsPageViewModel>();

  @override
  void initState() {
    super.initState();
    viewModel.getCollectionsCommand.execute();
  }

  void goToDetails([int collectionId = 1]) => //
      Navigator.of(context).pushNamed(
        RoutePaths.collectionDetails.path,
        arguments: collectionId,
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
        child: ElevatedButton(
          onPressed: () {
            showModalBottomSheet(
              context: context,
              useRootNavigator: true,
              builder: (_) {
                return ChangeNotifierProvider(
                  create: (_) => FormCollectionBottomSheetViewModel(
                      context.read<ICollectionRepository>()),
                  child: FormCollectionBottomSheet.create(
                    onSuccess: viewModel.getCollectionsCommand.execute,
                  ),
                );
              },
            );
          },
          child: Text('Add Collection'),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: ListenableBuilder(
            listenable: viewModel,
            builder: (context, _) {
              return CustomScrollView(
                slivers: [
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                        childCount: viewModel.collections.length,
                        (context, index) {
                      final collection = viewModel.collections[index];

                      return TileItem.preview(
                        onTap: () => goToDetails(collection.id),
                        title: collection.title,
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
