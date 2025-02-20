/// Atraves do Event Bus
/// Notifica para quem estiver ouvindo que uma task foi atualizada
/// passando o ID da task que foi atualizada
class UpdatedTaskEvent {
  final String taskId;

  UpdatedTaskEvent(this.taskId);
}