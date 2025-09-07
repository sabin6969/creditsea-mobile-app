/// An abstract class defining the contract for making HTTP requests.
/// This serves as a base class for API implementations, ensuring
/// a consistent interface for network operations.
abstract class BaseApi {
  /// Sends an HTTP GET request to the specified [endPoint].
  ///
  /// - [headers] (optional): HTTP headers to include in the request.
  /// - [endPoint]: The URL of the API endpoint.
  /// - [timeout] (optional): Duration before the request times out.
  ///
  /// Returns a `Future<String>` containing the response body.
  /// Throws an exception if the request fails.
  Future<String> getRequest({
    Map<String, String>? headers,
    required String endPoint,
    Duration? timeout,
  });

  /// Sends an HTTP POST request to the specified [endPoint] with [data].
  ///
  /// - [headers] (optional): HTTP headers to include in the request.
  /// - [data]: The request body, encoded as JSON.
  /// - [endPoint]: The URL of the API endpoint.
  /// - [timeout] (optional): Duration before the request times out.
  ///
  /// Returns a `Future<String>` containing the response body.
  /// Throws an exception if the request fails.
  Future<String> postRequest({
    Map<String, String>? headers,
    required Map<String, dynamic> data,
    required String endPoint,
    Duration? timeout,
  });

  /// Sends an HTTP PATCH request to the specified [endPoint] with [data].
  ///
  /// - [headers] (optional): HTTP headers to include in the request.
  /// - [data]: The request body, encoded as JSON.
  /// - [endPoint]: The URL of the API endpoint.
  /// - [timeout] (optional): Duration before the request times out.
  ///
  /// Returns a `Future<String>` containing the response body.
  /// Throws an exception if the request fails.
  Future<String> patchRequest({
    Map<String, String>? headers,
    required Map<String, dynamic> data,
    required String endPoint,
    Duration? timeout,
  });

  /// Sends an HTTP PUT request to the specified [endPoint] with [data].
  ///
  /// - [headers] (optional): HTTP headers to include in the request.
  /// - [data]: The request body, encoded as JSON.
  /// - [endPoint]: The URL of the API endpoint.
  /// - [timeout] (optional): Duration before the request times out.
  ///
  /// Returns a `Future<String>` containing the response body.
  /// Throws an exception if the request fails.
  Future<String> putRequest({
    Map<String, String>? headers,
    required Map<String, dynamic> data,
    required String endPoint,
    Duration? timeout,
  });

  /// Sends an HTTP DELETE request to the specified [endPoint] with [data].
  ///
  /// - [headers] (optional): HTTP headers to include in the request.
  /// - [data]: The request body, encoded as JSON.
  /// - [endPoint]: The URL of the API endpoint.
  /// - [timeout] (optional): Duration before the request times out.
  ///
  /// Returns a `Future<String>` containing the response body.
  /// Throws an exception if the request fails.
  Future<String> deleteRequest({
    Map<String, String>? headers,
    required Map<String, dynamic> data,
    required String endPoint,
    Duration? timeout,
  });
}
