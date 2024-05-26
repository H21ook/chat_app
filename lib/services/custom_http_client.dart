import 'dart:convert';
import 'package:chat_app/models/http_response_model.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class CustomHttpClient extends http.BaseClient {
  late http.Client _httpClient;

  // wireless debugging localhost
  static String messageServiceUrl = '192.168.68.62:8000';

  CustomHttpClient() {
    _httpClient = http.Client();
  }

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    return _httpClient.send(request);
  }

  Future<HttpResponseModel> getRequest(Uri url,
      {Map<String, String>? headers}) async {
    // final authHeaders = await headerWithToken(headers);
    try {
      http.Response response = await _httpClient.get(url);
      return httpResponseConvertToResponseModel(response);
    } catch (err) {
      return HttpResponseModel(isOK: false, errorText: err.toString());
    }
  }

  Future<HttpResponseModel> postRequest(Uri url,
      {Map<String, String>? headers, Object? body, Encoding? encoding}) async {
    // final authHeaders = await headerWithToken(headers);
    try {
      http.Response response =
          await _httpClient.post(url, body: body, encoding: encoding);
      return httpResponseConvertToResponseModel(response);
    } catch (err) {
      return HttpResponseModel(isOK: false, errorText: err.toString());
    }
  }

  Future<Map<String, String>?> headerWithToken(
      Map<String, String>? headers) async {
    final prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString("token");
    if (token != null) {
      if (headers == null) {
        headers = {'Authorization': 'Bearer $token'};
      } else {
        headers['Authorization'] = 'Bearer $token';
      }
    }
    return headers;
  }

  httpResponseConvertToResponseModel(http.Response response) {
    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      final isOK = responseData["code"] == 200;
      dynamic data;
      String? errorText;
      if (responseData["code"] == 200) {
        data = responseData["data"];
      } else {
        errorText = responseData["message"];
      }
      return HttpResponseModel(isOK: isOK, data: data, errorText: errorText);
    }
    return const HttpResponseModel(
        isOK: false, errorText: "Системийн админд хандана уу!");
  }
}
