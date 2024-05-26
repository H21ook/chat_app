class HttpResponseModel {
  final bool isOK;
  final String? errorText;
  final dynamic data;

  const HttpResponseModel({required this.isOK, this.errorText, this.data});
}
