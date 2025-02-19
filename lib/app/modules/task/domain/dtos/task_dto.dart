class TaskDto {
  int? id;
  String title;

  TaskDto({this.id, required this.title});

  factory TaskDto.empty() => TaskDto(title: '');

  setTitle(String value) => title = value;
}
