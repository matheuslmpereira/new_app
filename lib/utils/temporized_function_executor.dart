import 'dart:async';

mixin TemporizedFunctionExecutor {
  Timer? photoTimer;

  void executeTemporizedFunction(Duration duration, void Function() action) {
    photoTimer?.cancel();

    // Call the action immediately
    action();

    // Then set up the Timer for subsequent calls
    photoTimer = Timer.periodic(duration, (timer) {
      action();
    });
  }
}
