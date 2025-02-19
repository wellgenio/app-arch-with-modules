class CollectionDto {
  int id;
  String title;

  List<int> tasks;

  CollectionDto({required this.id, required this.title, required this.tasks});

  factory CollectionDto.empty() => CollectionDto(
        id: -1,
        title: '',
        tasks: const [],
      );

  setTitle(String value) => title = value;

  setTasks(List<int> value) => tasks = value;
}
