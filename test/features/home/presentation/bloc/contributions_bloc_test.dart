import 'package:bloc_test/bloc_test.dart';
import 'package:code_streak/core/data/failure.dart';
import 'package:code_streak/core/data/response_model.dart';
import 'package:code_streak/features/home/domain/entities/contributions_data.dart';
import 'package:code_streak/features/home/domain/usecases/get_contributions_data.dart';
import 'package:code_streak/features/home/presentation/bloc/contributions_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

// Mocks
class MockGetContributionsDataUseCase extends Mock implements GetContributionsDataUseCase {}
class MockContributionsData extends Mock implements ContributionsData {
  // Mock the append method
  @override
  ContributionsData append(ContributionsData? other) {
    // For testing, we can return a new mock or a specific pre-configured mock
    // if we need to verify properties of the appended data.
    // Or, if 'other' is the existing state.data, and 'this' is the new data,
    // then it should be this.append(other). Let's assume 'this' is new, 'other' is old.
    // The BLoC logic is: `response.data!.append(state.data)`
    // So, if `response.data` is `mockNewData` and `state.data` is `mockOldData`,
    // we'd mock `mockNewData.append(mockOldData)`.
    if (other == null) return this; // If old data is null, new data is just itself
    
    // Create a new mock that represents the combined data for verification simplicity.
    final combinedMock = MockContributionsData();
    // Optionally, set some properties on combinedMock if needed for expect()
    return combinedMock; 
  }
  
  // Stub other methods that might be called if not using strict mocks or if state uses them
  @override
  List<dynamic> get contributions => []; // Default to empty
  
  @override
  bool get stringify => true; // For Equatable
  
  @override
  List<Object?> get props => []; // For Equatable
}


void main() {
  late ContributionsBloc contributionsBloc;
  late MockGetContributionsDataUseCase mockGetContributionsDataUseCase;

  setUp(() {
    mockGetContributionsDataUseCase = MockGetContributionsDataUseCase();
    // Initialize with a default empty ContributionsData for the initial state
    contributionsBloc = ContributionsBloc(
        getContributionsDataUseCase: mockGetContributionsDataUseCase,
        initialData: ContributionsData.empty(), // Provide an initial empty state
    );
  });

  tearDown(() {
    contributionsBloc.close();
  });

  const String testUsername = 'testuser';
  final GetContributionsDataUseCaseParams params = GetContributionsDataUseCaseParams(username: testUsername);
  
  final mockInitialData = ContributionsData.empty(); // Matches the one in setUp
  final mockNewData = MockContributionsData(); // Data returned by the use case
  final mockAppendedData = MockContributionsData(); // Result of mockNewData.append(mockInitialData)
  
  final testFailure = APIErrorFailure(message: 'Failed to fetch contributions');

  group('ContributionsBloc', () {
    // Initial state test
    test('initial state is loading with initialData and then transitions to initial after 0 duration', () async {
      // The BLoC constructor sets state to loading(initialData) and then _changeToInitialState.
      // We need to wait for that timer to fire.
      expect(contributionsBloc.state, ContributionsState.loading(data: mockInitialData));
      await Future.delayed(Duration.zero); // Allow timer to complete
      expect(contributionsBloc.state, ContributionsState.initial(data: mockInitialData));
    });


    group('GetContributions event', () {
      // Setup for append mock: newData.append(initialData) returns appendedData
      setUp(() {
         when(mockNewData.append(mockInitialData)).thenReturn(mockAppendedData);
         // If initial state's data could be null and append handles it:
         when(mockNewData.append(null)).thenReturn(mockNewData); 
      });
      
      blocTest<ContributionsBloc, ContributionsState>(
        'emits [loading(currentData), success(appendedData)] when GetContributionsDataUseCase returns success',
        build: () {
          when(mockGetContributionsDataUseCase.call(params))
              .thenAnswer((_) async => ResponseModel.success(mockNewData));
          // Make sure the initial state's data is what we expect for append
          contributionsBloc.emit(ContributionsState.initial(data: mockInitialData)); // Set known current state
          return contributionsBloc;
        },
        act: (bloc) => bloc.add(ContributionsEvent.get(username: testUsername)),
        expect: () => [
          ContributionsState.loading(data: mockInitialData), // loading with existing data
          ContributionsState.success(data: mockAppendedData), // success with appended data
        ],
        verify: (_) {
          verify(mockGetContributionsDataUseCase.call(params)).called(1);
          // Verify that mockNewData.append(mockInitialData) was called
          verify(mockNewData.append(mockInitialData)).called(1);
        },
      );
      
      blocTest<ContributionsBloc, ContributionsState>(
        'emits [loading(currentData), success(newData)] when GetContributionsDataUseCase returns success and current state.data is null',
        build: () {
          when(mockGetContributionsDataUseCase.call(params))
              .thenAnswer((_) async => ResponseModel.success(mockNewData));
          // Ensure append(null) is properly mocked if needed.
          when(mockNewData.append(null)).thenReturn(mockNewData); 
          
          contributionsBloc.emit(const ContributionsState.initial(data: null)); // Set current state.data to null
          return contributionsBloc;
        },
        act: (bloc) => bloc.add(ContributionsEvent.get(username: testUsername)),
        expect: () => [
          const ContributionsState.loading(data: null), // loading with null data
          ContributionsState.success(data: mockNewData), // success with new data (append(null) behavior)
        ],
        verify: (_) {
          verify(mockGetContributionsDataUseCase.call(params)).called(1);
          verify(mockNewData.append(null)).called(1);
        },
      );

      blocTest<ContributionsBloc, ContributionsState>(
        'emits [loading(currentData), failed(failure, currentData)] when GetContributionsDataUseCase returns failure',
        build: () {
          when(mockGetContributionsDataUseCase.call(params))
              .thenAnswer((_) async => ResponseModel.failed(testFailure));
          contributionsBloc.emit(ContributionsState.initial(data: mockInitialData)); // Set known current state
          return contributionsBloc;
        },
        act: (bloc) => bloc.add(ContributionsEvent.get(username: testUsername)),
        expect: () => [
          ContributionsState.loading(data: mockInitialData), // loading with existing data
          ContributionsState.failed(failure: testFailure, data: mockInitialData), // failed, but preserves existing data
        ],
        verify: (_) {
          verify(mockGetContributionsDataUseCase.call(params)).called(1);
        },
      );
    });
  });
}
