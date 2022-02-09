class BaseApiException {
  final String title;
  final String message;
  final int statusCode;

  BaseApiException({required this.title, required this.message, required this.statusCode});
}
