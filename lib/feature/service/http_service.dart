import 'package:arcane/feature/service/logging_service.dart';
import 'package:dio/dio.dart';
import 'package:http_interceptor/http/intercepted_client.dart';
import 'package:serviced/serviced.dart';
import 'package:talker_dio_logger/talker_dio_logger.dart';
import 'package:talker_http_logger/talker_http_logger.dart';

class HTTPService extends Service {
  Dio? _dio;
  InterceptedClient? _client;

  Dio get dio => _dio!;

  InterceptedClient get client => _client!;

  @override
  void onStart() {
    _client = InterceptedClient.build(interceptors: [
      TalkerHttpLogger(),
    ]);

    // Create the main dio client with the talker logger routing
    _dio = Dio()
      ..interceptors.add(TalkerDioLogger(
        settings: const TalkerDioLoggerSettings(
          printRequestData: true,
          printRequestHeaders: true,
          printResponseData: true,
          printResponseHeaders: true,
          printResponseMessage: true,
        ),
        talker: talker,
      ));
  }

  @override
  void onStop() {
    _dio!.close();
  }
}
