import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';
import 'package:mobileapp/core/constants/log_level.dart';
import 'package:mobileapp/core/exceptions/app_exceptions.dart';
import 'package:mobileapp/core/logger/app_logger.dart';
import 'package:mobileapp/core/storage/secure_storage_service.dart';
import 'package:mobileapp/network/base_api.dart';

class NetworkApi extends BaseApi {
  NetworkApi._();

  static final NetworkApi _networkApi = NetworkApi._();

  static NetworkApi get instance => _networkApi;

  String _getResponseBody({required Response response}) {
    String? message = jsonDecode(response.body)["message"];
    switch (response.statusCode) {
      case HttpStatus.ok:
      case HttpStatus.created:
        return response.body;
      case HttpStatus.badRequest:
        throw BadRequestException(message: message);
      case HttpStatus.unauthorized:
        throw UnauthorizedException(message: message);
      case HttpStatus.forbidden:
        throw ForbiddenException(message: message);
      case HttpStatus.notFound:
        throw ResourceNotFoundException(message: message);
      case HttpStatus.conflict:
        throw ResourceConflictException(message: message);
      case HttpStatus.internalServerError:
        throw InternalServerException(message: message);
      default:
        throw AppException(message: "Something went wrong!");
    }
  }

  @override
  Future<String> deleteRequest({
    Map<String, String>? headers,
    required Map<String, dynamic> data,
    required String endPoint,
    Duration? timeout,
  }) async {
    AppLogger.logMessage(
      LogLevel.info,
      "DELETE request is initiated at $endPoint",
    );
    try {
      Response response =
          await delete(
            Uri.parse(endPoint),
            headers: {
              ...headers ?? {},
              HttpHeaders.contentTypeHeader: "application/json",
            },
            body: jsonEncode(data),
          ).timeout(
            timeout ?? const Duration(seconds: 20),
            onTimeout: () => throw TimeoutException(),
          );
      return _getResponseBody(response: response);
    } on SocketException {
      return Future.error(NoInternetException());
    } on ClientException {
      return Future.error(NoInternetException());
    } catch (e) {
      AppLogger.logMessage(
        LogLevel.error,
        "An error occured while making a DELETE request",
        error: e,
      );
      return Future.error(e);
    }
  }

  @override
  Future<String> getRequest({
    Map<String, String>? headers,
    required String endPoint,
    Duration? timeout,
  }) async {
    AppLogger.logMessage(
      LogLevel.info,
      "GET request is initiated at $endPoint",
    );
    try {
      Response response =
          await get(
            Uri.parse(endPoint),
            headers: {...headers ?? <String, String>{}},
          ).timeout(
            timeout ?? const Duration(seconds: 20),
            onTimeout: () =>
                throw TimeoutException(message: "Server request timeout"),
          );
      return _getResponseBody(response: response);
    } on NoInternetException {
      return Future.error(NoInternetException());
    } on ClientException {
      return Future.error(NoInternetException());
    } catch (e) {
      AppLogger.logMessage(
        LogLevel.error,
        "An error occured while making a GET request",
        error: e,
      );
      return Future.error(e);
    }
  }

  @override
  Future<String> patchRequest({
    Map<String, String>? headers,
    required Map<String, dynamic> data,
    required String endPoint,
    Duration? timeout,
  }) async {
    AppLogger.logMessage(
      LogLevel.info,
      "PATCH request is initiated at $endPoint",
    );

    try {
      Response response =
          await patch(
            Uri.parse(endPoint),
            headers: {
              ...headers ?? {},
              HttpHeaders.contentTypeHeader: "application/json",
            },
            body: jsonEncode(data),
          ).timeout(
            timeout ?? const Duration(seconds: 20),
            onTimeout: () => throw TimeoutException(),
          );
      return _getResponseBody(response: response);
    } on SocketException {
      return Future.error(NoInternetException());
    } on ClientException {
      return Future.error(NoInternetException());
    } catch (e) {
      AppLogger.logMessage(
        LogLevel.error,
        "An error occured while making a PATCH request",
        error: e,
      );
      return Future.error(e);
    }
  }

  @override
  Future<String> postRequest({
    Map<String, String>? headers,
    required Map<String, dynamic> data,
    required String endPoint,
    Duration? timeout,
  }) async {
    AppLogger.logMessage(
      LogLevel.info,
      "POST request is initiated at $endPoint",
    );

    AppLogger.logMessage(LogLevel.info, "The data is $data");

    try {
      String? token = await SecureStorageService.readValue(
        key: SecureStorageService.jwtKey,
      );
      Response response =
          await post(
            Uri.parse(endPoint),
            headers: {
              ...?headers,
              "token": token ?? "",
              HttpHeaders.contentTypeHeader: "application/json",
            },
            body: jsonEncode(data),
          ).timeout(
            timeout ?? const Duration(seconds: 20),
            onTimeout: () => throw TimeoutException(),
          );
      return _getResponseBody(response: response);
    } on SocketException {
      return Future.error(NoInternetException());
    } on ClientException {
      return Future.error(NoInternetException());
    } catch (e) {
      AppLogger.logMessage(
        LogLevel.error,
        "An error occured while making a POST request",
        error: e,
      );
      return Future.error(e);
    }
  }

  @override
  Future<String> putRequest({
    Map<String, String>? headers,
    required Map<String, dynamic> data,
    required String endPoint,
    Duration? timeout,
  }) async {
    AppLogger.logMessage(
      LogLevel.info,
      "PUT request is initiated at $endPoint",
    );
    try {
      Response response = await put(
        Uri.parse(endPoint),
        headers: headers ?? <String, String>{},
        body: jsonEncode(data),
      ).timeout(timeout ?? const Duration(seconds: 20));
      return _getResponseBody(response: response);
    } on SocketException {
      return Future.error(NoInternetException());
    } on ClientException {
      return Future.error(NoInternetException());
    } catch (e) {
      AppLogger.logMessage(
        LogLevel.error,
        "An error occured while making a PUT request",
        error: e,
      );
      return Future.error(e);
    }
  }
}
