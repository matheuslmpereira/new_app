import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:new_app/utils/temporized_function_executor.dart';

class Executor with TemporizedFunctionExecutor {}

class ActionMock extends Mock {
  void call();
}

void main() {
  late Executor executor;
  late ActionMock action;

  setUp(() {
    executor = Executor();
    action = ActionMock();
  });

  tearDown(() {
    executor.photoTimer?.cancel();
  });

  test('executeTemporizedFunction should call the action immediately', () async {
    executor.executeTemporizedFunction(const Duration(seconds: 1), action);

    verify(action.call());
  });

  test('executeTemporizedFunction should call the action periodically', () async {
    executor.executeTemporizedFunction(const Duration(milliseconds: 50), action);

    await Future.delayed(const Duration(milliseconds: 110));

    verify(action.call()).called(3);
  });

  test('executeTemporizedFunction should cancel the previous timer', () async {
    executor.executeTemporizedFunction(const Duration(milliseconds: 50), action);
    await Future.delayed(const Duration(milliseconds: 60));

    executor.executeTemporizedFunction(const Duration(milliseconds: 100), action);
    await Future.delayed(const Duration(milliseconds: 110));

    verify(action.call()).called(4);
  });
}
