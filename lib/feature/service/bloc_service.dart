import 'package:arcane/feature/login/login_bloc.dart';
import 'package:fast_log/fast_log.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:serviced/serviced.dart';

class BlocService extends StatelessService {
  Iterable<BlocProvider> onRegisterProviders() sync* {
    yield _provide<LoginBloc>((context) => LoginBloc());
    verbose("  Registered Bloc providers");
  }

  BlocProvider<T> _provide<T extends StateStreamableSource<Object?>>(
          T Function(BuildContext context) b) =>
      BlocProvider<T>(
        create: b,
        lazy: true,
      );
}
