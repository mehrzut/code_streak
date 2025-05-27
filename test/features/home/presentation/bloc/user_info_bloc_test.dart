import 'package:bloc_test/bloc_test.dart';
import 'package:code_streak/core/data/failure.dart';
import 'package:code_streak/core/data/response_model.dart';
import 'package:code_streak/features/home/domain/entities/user_info.dart';
import 'package:code_streak/features/home/domain/usecases/get_user_info.dart';
import 'package:code_streak/features/home/presentation/bloc/user_info_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

// Mocks
class MockGetUserInfoUseCase extends Mock implements GetUserInfoUseCase {}
class MockUserInfo extends Mock implements UserInfo {} // If UserInfo needs specific mock behavior

void main() {
  late UserInfoBloc userInfoBloc;
  late MockGetUserInfoUseCase mockGetUserInfoUseCase;

  setUp(() {
    mockGetUserInfoUseCase = MockGetUserInfoUseCase();
    userInfoBloc = UserInfoBloc(getUserInfoUseCase: mockGetUserInfoUseCase);
  });

  tearDown(() {
    userInfoBloc.close();
  });

  const String testUsername = 'testuser';
  final params = GetUserInfoUseCaseParams(username: testUsername);
  
  final mockUserInfo = MockUserInfo(); // Or a real UserInfo instance if simpler
  final testFailure = APIErrorFailure(message: 'Failed to fetch user info');

  group('UserInfoBloc', () {
    group('GetUserInfoEvent', () {
      blocTest<UserInfoBloc, UserInfoState>(
        'emits [loading, success] when GetUserInfoUseCase returns success',
        build: () {
          when(mockGetUserInfoUseCase.call(params))
              .thenAnswer((_) async => ResponseModel.success(mockUserInfo));
          return userInfoBloc;
        },
        act: (bloc) => bloc.add(const UserInfoEvent.getUserInfo(username: testUsername)),
        expect: () => [
          const UserInfoState.loading(),
          UserInfoState.success(data: mockUserInfo),
        ],
        verify: (_) {
          verify(mockGetUserInfoUseCase.call(params)).called(1);
        },
      );

      blocTest<UserInfoBloc, UserInfoState>(
        'emits [loading, failed] when GetUserInfoUseCase returns failure',
        build: () {
          when(mockGetUserInfoUseCase.call(params))
              .thenAnswer((_) async => ResponseModel.failed(testFailure));
          return userInfoBloc;
        },
        act: (bloc) => bloc.add(const UserInfoEvent.getUserInfo(username: testUsername)),
        expect: () => [
          const UserInfoState.loading(),
          UserInfoState.failed(failure: testFailure),
        ],
        verify: (_) {
          verify(mockGetUserInfoUseCase.call(params)).called(1);
        },
      );
    });
  });
}
