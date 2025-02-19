import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:result_dart/result_dart.dart';

typedef CommandAction0<T extends Object> = AsyncResult<T> Function();
typedef CommandAction1<T extends Object, A> = AsyncResult<T> Function(A);

abstract class Command<T extends Object> extends ChangeNotifier {
  Command();

  bool _running = false;

  bool get running => _running;

  bool _error = false;

  bool get error => _error;

  bool _completed = false;

  bool get completed => _completed;

  Future<void> _execute(CommandAction0<T> action) async {
    if (_running) return;

    _running = true;
    _error = false;
    _completed = false;
    notifyListeners();

    (await action()).onSuccess((_) {
      _completed = true;
      _running = false;
      notifyListeners();
    }).onFailure((_) {
      _error = true;
      _running = false;
      notifyListeners();
    });
  }
}

class Command0<T extends Object> extends Command<T> {
  Command0(this._action);

  final CommandAction0<T> _action;

  Future<void> execute() async {
    await _execute(_action);
  }
}

class Command1<T extends Object, A> extends Command<T> {
  Command1(this._action);

  final CommandAction1<T, A> _action;

  Future<void> execute(A argument) async {
    await _execute(() => _action(argument));
  }
}
