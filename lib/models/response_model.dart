class ResponseModel {
  final int code;
  final String? errorText;
  final dynamic data;

  const ResponseModel({required this.code, this.errorText, this.data});
}
