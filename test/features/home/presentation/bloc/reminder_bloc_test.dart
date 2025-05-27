import 'package:bloc_test/bloc_test.dart';
import 'package:code_streak/core/data/failure.dart';
import 'package:code_streak/core/data/response_model.dart';
import 'package:code_streak/features/home/domain/usecases/set_user_reminders.dart';
import 'package:code_streak/features/home/presentation/bloc/reminder_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

// Mocks
class MockSetUserRemindersUseCase extends Mock implements SetUserRemindersUseCase {}

void main() {
  late ReminderBloc reminderBloc;
  late MockSetUserRemindersUseCase mockSetUserRemindersUseCase;

  setUp(() {
    mockSetUserRemindersUseCase = MockSetUserRemindersUseCase();
    reminderBloc = ReminderBloc(setUserRemindersUseCase: mockSetUserRemindersUseCase);
  });

  tearDown(() {
    reminderBloc.close();
  });

  const bool testEnable = true;
  const String testTime = '10:00';
  const String testUsername = 'testuser';
  final params = SetUserRemindersUseCaseParams(enable: testEnable, time: testTime, username: testUsername);
  
  final testFailure = PermissionFailure(message: 'Failed to set reminder');

  group('ReminderBloc', () {
    group('SetReminderEvent', () {
      blocTest<ReminderBloc, ReminderState>(
        'emits [loading, success] when SetUserRemindersUseCase returns success',
        build: () {
          when(mockSetUserRemindersUseCase.call(params))
              .thenAnswer((_) async => ResponseModel.success(true));
          return reminderBloc;
        },
        act: (bloc) => bloc.add(const ReminderEvent.set(enable: testEnable, time: testTime, username: testUsername)),
        expect: () => [
          const ReminderState.loading(),
          const ReminderState.success(),
        ],
        verify: (_) {
          verify(mockSetUserRemindersUseCase.call(params)).called(1);
        },
      );

      blocTest<ReminderBloc, ReminderState>(
        'emits [loading, failed] when SetUserRemindersUseCase returns failure',
        build: () {
          when(mockSetUserRemindersUseCase.call(params))
              .thenAnswer((_) async => ResponseModel.failed(testFailure));
          return reminderBloc;
        },
        act: (bloc) => bloc.add(const ReminderEvent.set(enable: testEnable, time: testTime, username: testUsername)),
        expect: () => [
          const ReminderState.loading(),
          ReminderState.failed(failure: testFailure),
        ],
        verify: (_) {
          verify(mockSetUserRemindersUseCase.call(params)).called(1);
        },
      );
    });
  });
}
