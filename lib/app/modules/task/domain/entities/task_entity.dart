class TaskEntity {
  final int id;
  final String title;

  TaskEntity({required this.id, required this.title});

  factory TaskEntity.empty() => TaskEntity(id: -1, title: '');
}