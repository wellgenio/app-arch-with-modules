import 'package:flutter/material.dart';
import 'package:result_dart/result_dart.dart';

import '../../../../modules/collection/data/repositories/collection_repository.dart';
import '../../../../modules/collection/domain/entities/collection_entity.dart';
import '../../../../utils/command.dart';

class DeleteCollectionBottomSheetViewModel extends ChangeNotifier {
  final ICollectionRepository collectionRepository;

  DeleteCollectionBottomSheetViewModel(this.collectionRepository) {
    deleteCollectionCommand = Command1(_deleteCollection);
  }

  late final Command1<Unit, CollectionEntity> deleteCollectionCommand;

  AsyncResult<Unit> _deleteCollection(CollectionEntity entity) =>
      collectionRepository //
          .deleteCollection(entity)
          .onSuccess(updateListCollections);

  updateListCollections(_) => collectionRepository.getCollections();
}
