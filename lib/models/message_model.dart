class MessageModel {
  final String message;
  final String sentAt;
  final String sentBy;
  final String messageType;

  MessageModel(
      {required this.message,
      required this.sentAt,
      required this.sentBy,
      required this.messageType});
}
