import 'package:flutter/cupertino.dart';
import 'package:result_dart/result_dart.dart';

import '../../../../modules/collection/data/repositories/collection_repository.dart';
import '../../../../modules/collection/domain/entities/collection_entity.dart';
import '../../../../modules/task/domain/entities/task_entity.dart';
import '../../../../utils/command.dart';

typedef AddTaskParam = ({CollectionEntity collection, TaskEntity task});

class AddCollectionBottomSheetViewModel extends ChangeNotifier {
  final ICollectionRepository collectionRepository;

  AddCollectionBottomSheetViewModel(this.collectionRepository) {
    getCollectionsCommand = Command0(_getCollections);
    addTaskOnCollectionCommand = Command1(_addTaskOnCollection);
  }

  List<CollectionEntity> _collections = const [];

  List<CollectionEntity> _filteredCollections = const [];

  List<CollectionEntity> get collections => _filteredCollections.isNotEmpty //
      ? _filteredCollections
      : _collections;

  late final Command0<List<CollectionEntity>> getCollectionsCommand;

  late final Command1<Unit, AddTaskParam> addTaskOnCollectionCommand;

  AsyncResult<List<CollectionEntity>> _getCollections() => //
      collectionRepository
          .getCollections()
          .onSuccess(_updateCollectionsOnScreen);

  AsyncResult<Unit> _addTaskOnCollection(AddTaskParam params) => //
      collectionRepository.addTask(params.collection, params.task.id);

  _updateCollectionsOnScreen(List<CollectionEntity> collections) {
    _collections = collections;
    notifyListeners();
  }

  search(String term) {
    if (term.isNotEmpty) {
      _filteredCollections = _collections
          .where(
              (data) => data.title.toLowerCase().contains(term.toLowerCase()))
          .toList();
    } else {
      _filteredCollections = [];
    }
    notifyListeners();
  }
}
