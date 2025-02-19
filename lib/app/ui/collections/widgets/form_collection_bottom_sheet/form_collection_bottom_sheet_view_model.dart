import 'package:flutter/material.dart';
import 'package:modular_di_app/app/modules/collection/domain/dtos/collection_dto.dart';
import 'package:result_dart/result_dart.dart';

import '../../../../modules/collection/data/repositories/collection_repository.dart';
import '../../../../utils/command.dart';

class FormCollectionBottomSheetViewModel extends ChangeNotifier {
  final ICollectionRepository collectionRepository;

  FormCollectionBottomSheetViewModel(this.collectionRepository) {
    addCollectionCommand = Command1(collectionRepository.addCollection);
    updateCollectionCommand = Command1(collectionRepository.updateCollection);
  }

  late final Command1<Unit, CollectionDto> addCollectionCommand;

  late final Command1<Unit, CollectionDto> updateCollectionCommand;
}
