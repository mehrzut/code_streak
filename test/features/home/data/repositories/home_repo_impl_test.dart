import 'package:code_streak/core/data/failure.dart';
import 'package:code_streak/core/data/response_model.dart';
import 'package:code_streak/core/controllers/local_database.dart';
import 'package:code_streak/features/home/data/datasources/home_data_source.dart';
import 'package:code_streak/features/home/data/repositories/home_repo_impl.dart';
import 'package:code_streak/features/home/domain/entities/contributions_data.dart';
import 'package:code_streak/features/home/domain/entities/range_data.dart';
import 'package:code_streak/features/home/domain/entities/user_info.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

// Mocks
class MockHomeDataSource extends Mock implements HomeDataSource {}
class MockLocalDatabase extends Mock implements LocalDatabase {}
class MockContributionsData extends Mock implements ContributionsData {
  // Mock methods that are called on ContributionsData instances
  @override
  RangeData getNotExistingRange(DateTime from, DateTime till) => RangeData.empty(); // Default to empty range

  @override
  ContributionsData append(ContributionsData? other) => this; // Default to returning self

  @override
  ContributionsData withoutToday() => this; // Default to returning self
  
  // Mocking contributions getter for hasRange check in some scenarios
  @override
  List<dynamic> get contributions => []; // Default to empty list
}

class MockUserInfo extends Mock implements UserInfo {}

void main() {
  late HomeRepoImpl homeRepo;
  late MockHomeDataSource mockHomeDataSource;
  late MockLocalDatabase mockLocalDatabase;

  setUp(() {
    mockHomeDataSource = MockHomeDataSource();
    mockLocalDatabase = MockLocalDatabase();
    homeRepo = HomeRepoImpl(
      dataSource: mockHomeDataSource,
      localDB: mockLocalDatabase,
    );
  });

  const String testUsername = 'testuser';
  final testFailure = APIErrorFailure(message: 'Test API Failure');
  final mockUserInfo = MockUserInfo();
  final mockContributions = MockContributionsData();
  final mockFetchedContributions = MockContributionsData(); // For data fetched from source

  group('HomeRepoImpl', () {
    group('getUserInfo', () {
      test('returns ResponseModel.success when dataSource succeeds', () async {
        // Arrange
        when(mockHomeDataSource.fetchUserInfo(username: testUsername))
            .thenAnswer((_) async => ResponseModel.success(mockUserInfo));

        // Act
        final result = await homeRepo.getUserInfo(username: testUsername);

        // Assert
        expect(result.isSuccess, isTrue);
        expect(result.data, mockUserInfo);
        verify(mockHomeDataSource.fetchUserInfo(username: testUsername)).called(1);
      });

      test('returns ResponseModel.failed when dataSource fails', () async {
        // Arrange
        when(mockHomeDataSource.fetchUserInfo(username: testUsername))
            .thenAnswer((_) async => ResponseModel.failed(testFailure));

        // Act
        final result = await homeRepo.getUserInfo(username: testUsername);

        // Assert
        expect(result.isFailed, isTrue);
        expect(result.failure, testFailure);
        verify(mockHomeDataSource.fetchUserInfo(username: testUsername)).called(1);
      });
    });

    group('getContributionsData', () {
      final DateTime fromDate = DateTime.now().subtract(const Duration(days: 364));
      final DateTime tillDate = DateTime.now();

      group('when localDatabase.getContributions returns null (no local data)', () {
        setUp(() {
          when(mockLocalDatabase.getContributions()).thenAnswer((_) async => null);
        });

        test('fetches full range, saves (without today), and returns success', () async {
          // Arrange
          when(mockHomeDataSource.fetchGithubContributions(username: testUsername, from: fromDate, till: tillDate))
              .thenAnswer((_) async => ResponseModel.success(mockFetchedContributions));
          when(mockFetchedContributions.withoutToday()).thenReturn(mockFetchedContributions); // Simpler mock

          // Act
          final result = await homeRepo.getContributionsData(username: testUsername);

          // Assert
          expect(result.isSuccess, isTrue);
          expect(result.data, mockFetchedContributions);
          verify(mockHomeDataSource.fetchGithubContributions(username: testUsername, from: fromDate, till: tillDate)).called(1);
          verify(mockLocalDatabase.saveContributions(mockFetchedContributions)).called(1);
          verify(mockFetchedContributions.withoutToday()).called(1);
        });

        test('returns failure if dataSource fetch fails', () async {
          // Arrange
          when(mockHomeDataSource.fetchGithubContributions(username: testUsername, from: fromDate, till: tillDate))
              .thenAnswer((_) async => ResponseModel.failed(testFailure));

          // Act
          final result = await homeRepo.getContributionsData(username: testUsername);

          // Assert
          expect(result.isFailed, isTrue);
          expect(result.failure, testFailure);
          verifyNever(mockLocalDatabase.saveContributions(any));
        });
      });

      group('when localDatabase.getContributions returns data', () {
        final RangeData emptyRange = RangeData.empty();
        final DateTime rangeFrom = DateTime(2023, 1, 1);
        final DateTime rangeTill = DateTime(2023, 1, 5);
        final RangeData nonEmptyRange = RangeData.range(from: rangeFrom, till: rangeTill);

        setUp(() {
          when(mockLocalDatabase.getContributions()).thenAnswer((_) async => mockContributions);
        });

        test('if getNotExistingRange returns empty range, returns local data successfully', () async {
          // Arrange
          when(mockContributions.getNotExistingRange(fromDate, tillDate)).thenReturn(emptyRange);
          
          // Act
          final result = await homeRepo.getContributionsData(username: testUsername);

          // Assert
          expect(result.isSuccess, isTrue);
          expect(result.data, mockContributions);
          verifyNever(mockHomeDataSource.fetchGithubContributions(
              username: anyNamed('username'), from: anyNamed('from'), till: anyNamed('till')));
          verifyNever(mockLocalDatabase.saveContributions(any));
        });

        test('if getNotExistingRange returns non-empty range, fetches missing, appends, saves, and returns success', () async {
          // Arrange
          final appendedData = MockContributionsData(); // Data after appending fetched to local
          when(mockContributions.getNotExistingRange(fromDate, tillDate)).thenReturn(nonEmptyRange);
          when(mockHomeDataSource.fetchGithubContributions(username: testUsername, from: rangeFrom, till: rangeTill))
              .thenAnswer((_) async => ResponseModel.success(mockFetchedContributions));
          when(mockFetchedContributions.append(mockContributions)).thenReturn(appendedData);
          when(appendedData.withoutToday()).thenReturn(appendedData); // Simpler mock

          // Act
          final result = await homeRepo.getContributionsData(username: testUsername);

          // Assert
          expect(result.isSuccess, isTrue);
          expect(result.data, appendedData);
          verify(mockHomeDataSource.fetchGithubContributions(username: testUsername, from: rangeFrom, till: rangeTill)).called(1);
          verify(mockFetchedContributions.append(mockContributions)).called(1);
          verify(mockLocalDatabase.saveContributions(appendedData)).called(1);
          verify(appendedData.withoutToday()).called(1);
        });
        
        test('if getNotExistingRange returns non-empty range, but fetch fails, returns failure', () async {
          // Arrange
          when(mockContributions.getNotExistingRange(fromDate, tillDate)).thenReturn(nonEmptyRange);
          when(mockHomeDataSource.fetchGithubContributions(username: testUsername, from: rangeFrom, till: rangeTill))
              .thenAnswer((_) async => ResponseModel.failed(testFailure));

          // Act
          final result = await homeRepo.getContributionsData(username: testUsername);

          // Assert
          expect(result.isFailed, isTrue);
          expect(result.failure, testFailure);
          verifyNever(mockLocalDatabase.saveContributions(any));
        });
      });
    });
    
    group('setUserReminders', () {
      final bool enable = true;
      final String time = '10:00';

      test('returns ResponseModel.success when dataSource succeeds', () async {
        // Arrange
        when(mockHomeDataSource.setUserReminders(enable: enable, time: time, username: testUsername))
            .thenAnswer((_) async => ResponseModel.success(true));

        // Act
        final result = await homeRepo.setUserReminders(enable: enable, time: time, username: testUsername);

        // Assert
        expect(result.isSuccess, isTrue);
        expect(result.data, true);
        verify(mockHomeDataSource.setUserReminders(enable: enable, time: time, username: testUsername)).called(1);
      });

      test('returns ResponseModel.failed when dataSource fails', () async {
        // Arrange
        final reminderFailure = PermissionFailure(message: 'Reminder permission denied');
        when(mockHomeDataSource.setUserReminders(enable: enable, time: time, username: testUsername))
            .thenAnswer((_) async => ResponseModel.failed(reminderFailure));

        // Act
        final result = await homeRepo.setUserReminders(enable: enable, time: time, username: testUsername);

        // Assert
        expect(result.isFailed, isTrue);
        expect(result.failure, reminderFailure);
        verify(mockHomeDataSource.setUserReminders(enable: enable, time: time, username: testUsername)).called(1);
      });
    });
  });
}
