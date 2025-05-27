import 'package:bloc_test/bloc_test.dart';
import 'package:code_streak/core/data/failure.dart';
import 'package:code_streak/core/data/response_model.dart';
import 'package:code_streak/core/data/usecase.dart';
import 'package:code_streak/features/auth/domain/usecases/sign_out.dart';
import 'package:code_streak/features/auth/presentation/bloc/sign_out_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

// Mocks
class MockSignOutUseCase extends Mock implements SignOut {}

void main() {
  late SignOutBloc signOutBloc;
  late MockSignOutUseCase mockSignOutUseCase;

  setUp(() {
    mockSignOutUseCase = MockSignOutUseCase();
    signOutBloc = SignOutBloc(signOutUseCase: mockSignOutUseCase);
  });

  tearDown(() {
    signOutBloc.close();
  });

  final testFailure = AuthenticationFailure(message: 'Sign out failed');

  group('SignOutBloc', () {
    group('SignOutEvent.signOut', () {
      blocTest<SignOutBloc, SignOutState>(
        'emits [loading, success] when SignOutUseCase returns success',
        build: () {
          when(mockSignOutUseCase.call(const NoParams()))
              .thenAnswer((_) async => ResponseModel.success(true));
          return signOutBloc;
        },
        act: (bloc) => bloc.add(const SignOutEvent.signOut()),
        expect: () => [
          const SignOutState.loading(),
          const SignOutState.success(),
        ],
        verify: (_) {
          verify(mockSignOutUseCase.call(const NoParams())).called(1);
        },
      );

      blocTest<SignOutBloc, SignOutState>(
        'emits [loading, failed] when SignOutUseCase returns failure',
        build: () {
          when(mockSignOutUseCase.call(const NoParams()))
              .thenAnswer((_) async => ResponseModel.failed(testFailure));
          return signOutBloc;
        },
        act: (bloc) => bloc.add(const SignOutEvent.signOut()),
        expect: () => [
          const SignOutState.loading(),
          SignOutState.failed(failure: testFailure),
        ],
        verify: (_) {
          verify(mockSignOutUseCase.call(const NoParams())).called(1);
        },
      );
    });
  });
}
