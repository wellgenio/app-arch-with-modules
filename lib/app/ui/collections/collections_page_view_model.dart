import 'package:flutter/cupertino.dart';
import 'package:result_dart/result_dart.dart';

import '../../modules/collection/domain/entities/collection_entity.dart';
import '../../modules/collection/data/repositories/collection_repository.dart';
import '../../utils/command.dart';

class CollectionsPageViewModel extends ChangeNotifier {
  final ICollectionRepository collectionRepository;

  CollectionsPageViewModel(this.collectionRepository) {
    getCollectionsCommand = Command0(_getTasks);

    collectionRepository.observerCollections().listen(updateScreen);
  }

  List<CollectionEntity> _collections = const [];

  List<CollectionEntity> get collections => _collections;

  late final Command0<List<CollectionEntity>> getCollectionsCommand;

  AsyncResult<List<CollectionEntity>> _getTasks() =>
      collectionRepository.getCollections().onSuccess(updateScreen);

  updateScreen(List<CollectionEntity> data) {
    _collections = data;
    notifyListeners();
  }
}
