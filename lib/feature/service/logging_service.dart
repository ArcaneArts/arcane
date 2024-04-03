import 'package:fast_log/fast_log.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';
import 'package:serviced/serviced.dart';
import 'package:talker_bloc_logger/talker_bloc_logger.dart';
import 'package:talker_flutter/talker_flutter.dart';

Talker get talker => services().get<LoggingService>()._talker!;
Stream<FlutterErrorDetails> get streamErrors =>
    services().get<LoggingService>()._errorStream!.stream;

class LoggingService extends Service {
  Talker? _talker;
  BehaviorSubject<FlutterErrorDetails>? _errorStream;

  @override
  void onStart() {
    // Configure talker logging instance
    _errorStream = BehaviorSubject<FlutterErrorDetails>();
    _talker = TalkerFlutter.init(
      settings: TalkerSettings(
          maxHistoryItems: 10000,
          useHistory: true,
          enabled: true,
          useConsoleLogs: true),
      logger: TalkerLogger(
        settings: const TalkerLoggerSettings(
          enableColors: true,
          level: LogLevel.verbose,
        ),
      ),
    );

    // Configure bloc observer to log to talker
    Bloc.observer = TalkerBlocObserver(
        talker: talker,
        settings: const TalkerBlocLoggerSettings(
          enabled: true,
          printChanges: true,
          printEventFullData: true,
          printEvents: true,
          printStateFullData: true,
          printTransitions: true,
        ));

    // Configure fast_log package to route to talker
    lDebugMode = true;
    lLogOverride = (type, message) {
      switch (type) {
        case LogCategory.info:
          talker.info(message);
          break;
        case LogCategory.success:
          talker.info(message);
          break;
        case LogCategory.warning:
          talker.warning(message);
          break;
        case LogCategory.error:
          talker.error(message);
          break;
        case LogCategory.verbose:
          talker.verbose(message);
          break;
        case LogCategory.navigation:
          talker.info(message);
          break;
        case LogCategory.actioned:
          talker.info(message);
          break;
        case LogCategory.network:
          talker.info(message);
          break;
      }
    };

    FlutterError.onError = (d) => _errorStream!.add(d);
  }

  void onError(Object error, StackTrace stack) {
    _talker!.handle(error, stack, "Unknown Error");
  }

  @override
  void onStop() {
    _talker!.cleanHistory();
    _errorStream!.close();
  }
}
