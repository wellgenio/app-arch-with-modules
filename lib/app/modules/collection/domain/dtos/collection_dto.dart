class CollectionDto {
  String id;
  String title;

  List<String> tasks;

  CollectionDto({required this.id, required this.title, required this.tasks});

  factory CollectionDto.empty() => CollectionDto(
        id: '-1',
        title: '',
        tasks: const [],
      );

  setTitle(String value) => title = value;

  setTasks(List<String> value) => tasks = value;

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'tasks': tasks,
  };
}
