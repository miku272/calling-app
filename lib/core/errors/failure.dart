class Failure {
  final int? statusCode;
  final String? firebaseErrorCode;
  final String message;

  Failure({this.statusCode, this.firebaseErrorCode, required this.message});
}
