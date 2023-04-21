class ErrorModel {
  final String? error;
  ErrorModel({required this.error,});
   toJson() {
    return {
      "Error": error,
    };
  }
}
