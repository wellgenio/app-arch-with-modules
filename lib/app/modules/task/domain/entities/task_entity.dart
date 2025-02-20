class TaskEntity {
  final String id;
  final String title;
  final bool value;

  TaskEntity({
    required this.id,
    required this.title,
    required this.value,
  });

  factory TaskEntity.empty() => TaskEntity(id: '-1', title: '', value: false);
}
