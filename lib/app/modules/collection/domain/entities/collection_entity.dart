class CollectionEntity {
  final String id;
  final String title;
  final List<String> tasks;

  CollectionEntity({
    required this.id,
    required this.title,
    required this.tasks,
  });

  factory CollectionEntity.empty() => CollectionEntity(
        id: '-1',
        title: '',
        tasks: const [],
      );
}
