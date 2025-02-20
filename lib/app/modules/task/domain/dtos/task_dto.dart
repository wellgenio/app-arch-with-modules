class TaskDto {
  String? id;
  String title;
  bool value;

  TaskDto({this.id, required this.title, this.value = false});

  factory TaskDto.empty() => TaskDto(title: '');

  setTitle(String value) => title = value;

  setValue(bool newValue) => value = newValue;

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'value': value
  };
}
