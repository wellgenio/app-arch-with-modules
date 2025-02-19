class CollectionEntity {
  final int id;
  final String title;
  final List<int> tasks;

  CollectionEntity({
    required this.id,
    required this.title,
    required this.tasks,
  });

  factory CollectionEntity.empty() => CollectionEntity(
        id: -1,
        title: '',
        tasks: const [],
      );
}
