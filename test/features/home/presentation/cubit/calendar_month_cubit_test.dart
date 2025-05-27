import 'package:bloc_test/bloc_test.dart';
import 'package:code_streak/core/extensions.dart'; // For DateTime extensions
import 'package:code_streak/features/home/domain/entities/contribution_day_data.dart';
import 'package:code_streak/features/home/presentation/cubit/calendar_month_cubit.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CalendarMonthCubit', () {
    final initialDate = DateTime(2023, 10, 15); // October 15, 2023
    final initialContributions = [
      ContributionDayData(date: DateTime(2023, 10, 1), count: 1),
      ContributionDayData(date: DateTime(2023, 9, 5), count: 5),
      ContributionDayData(date: DateTime(2023, 11, 10), count: 3),
    ];

    CalendarMonthCubit buildCubit() {
      return CalendarMonthCubit(
        allDaysContributionData: initialContributions,
        current: initialDate,
      );
    }

    test('initial state is correct', () {
      final cubit = buildCubit();
      expect(cubit.state.current, initialDate);
      expect(cubit.state.allDaysContributionData, initialContributions);
      // Verify derived properties from initial state
      expect(cubit.state.currentMonthContributionData, [initialContributions[0]]); // Only Oct data
      expect(cubit.state.maxContributeInCurrentMonth, 1);
      cubit.close();
    });

    blocTest<CalendarMonthCubit, CalendarMonthState>(
      'nextMonth() emits state with current date moved to next month',
      build: buildCubit,
      act: (cubit) => cubit.nextMonth(),
      expect: () => [
        CalendarMonthState(
          allDaysContributionData: initialContributions,
          current: initialDate.nextMonth, // November 15, 2023
        ),
      ],
      verify: (cubit) {
        expect(cubit.state.currentMonthContributionData, [initialContributions[2]]); // Only Nov data
        expect(cubit.state.maxContributeInCurrentMonth, 3);
      }
    );

    blocTest<CalendarMonthCubit, CalendarMonthState>(
      'previousMonth() emits state with current date moved to previous month',
      build: buildCubit,
      act: (cubit) => cubit.previousMonth(),
      expect: () => [
        CalendarMonthState(
          allDaysContributionData: initialContributions,
          current: initialDate.previousMonth, // September 15, 2023
        ),
      ],
       verify: (cubit) {
        expect(cubit.state.currentMonthContributionData, [initialContributions[1]]); // Only Sep data
        expect(cubit.state.maxContributeInCurrentMonth, 5);
      }
    );

    blocTest<CalendarMonthCubit, CalendarMonthState>(
      'goMonthsForwardOrBackward(2) emits state with current date moved 2 months forward',
      build: buildCubit,
      act: (cubit) => cubit.goMonthsForwardOrBackward(2),
      expect: () => [
        CalendarMonthState(
          allDaysContributionData: initialContributions,
          current: initialDate.monthsAfter(2), // December 15, 2023
        ),
      ],
      verify: (cubit) {
        expect(cubit.state.currentMonthContributionData, isEmpty); 
        expect(cubit.state.maxContributeInCurrentMonth, 0);
      }
    );

    blocTest<CalendarMonthCubit, CalendarMonthState>(
      'goMonthsForwardOrBackward(-1) emits state with current date moved 1 month backward',
      build: buildCubit,
      act: (cubit) => cubit.goMonthsForwardOrBackward(-1),
      expect: () => [
        CalendarMonthState(
          allDaysContributionData: initialContributions,
          current: initialDate.monthsBefore(1), // September 15, 2023
        ),
      ],
       verify: (cubit) {
        expect(cubit.state.currentMonthContributionData, [initialContributions[1]]); 
        expect(cubit.state.maxContributeInCurrentMonth, 5);
      }
    );
    
    blocTest<CalendarMonthCubit, CalendarMonthState>(
      'goMonthsForwardOrBackward(0) emits state with current date unchanged',
      build: buildCubit,
      act: (cubit) => cubit.goMonthsForwardOrBackward(0),
      expect: () => [
        CalendarMonthState(
          allDaysContributionData: initialContributions,
          current: initialDate, // October 15, 2023
        ),
      ],
       verify: (cubit) {
        expect(cubit.state.currentMonthContributionData, [initialContributions[0]]); 
        expect(cubit.state.maxContributeInCurrentMonth, 1);
      }
    );

    // Test derived getters in CalendarMonthState directly for robustness
    group('CalendarMonthState derived getters', () {
      test('currentMonthContributionData filters correctly', () {
        final state = CalendarMonthState(allDaysContributionData: initialContributions, current: initialDate);
        expect(state.currentMonthContributionData.length, 1);
        expect(state.currentMonthContributionData.first, initialContributions[0]);
      });
      
      test('maxContributeInCurrentMonth calculates correctly', () {
        final state = CalendarMonthState(allDaysContributionData: initialContributions, current: initialDate);
        expect(state.maxContributeInCurrentMonth, 1);

        final contributionsForMaxTest = [
           ContributionDayData(date: DateTime(2023, 10, 5), count: 5),
           ContributionDayData(date: DateTime(2023, 10, 10), count: 10),
           ContributionDayData(date: DateTime(2023, 10, 15), count: 2),
           ContributionDayData(date: DateTime(2023, 9, 1), count: 20), // Different month
        ];
        final stateWithMoreData = CalendarMonthState(allDaysContributionData: contributionsForMaxTest, current: initialDate);
        expect(stateWithMoreData.maxContributeInCurrentMonth, 10);
      });

      test('maxContributeInCurrentMonth is 0 if no contributions in current month', () {
         final state = CalendarMonthState(allDaysContributionData: initialContributions, current: DateTime(2023, 1, 1)); // January
         expect(state.currentMonthContributionData, isEmpty);
         expect(state.maxContributeInCurrentMonth, 0);
      });
    });
  });
}
