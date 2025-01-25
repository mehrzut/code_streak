import 'package:bloc/bloc.dart';
import 'package:code_streak/core/extensions.dart';
import 'package:code_streak/features/home/domain/entities/contribution_day_data.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'calendar_month_state.dart';
part 'calendar_month_cubit.freezed.dart';

class CalendarMonthCubit extends Cubit<CalendarMonthState> {
  CalendarMonthCubit(
      List<ContributionDayData> allDaysContributionData, DateTime current)
      : super(CalendarMonthState(
          current: current,
          allDaysContributionData: allDaysContributionData,
        ));

  void nextMonth() {
    emit(state.copyWith(current: state.current.nextMonth));
  }

  void previousMonth() {
    emit(state.copyWith(current: state.current.previousMonth));
  }

  void goMonthsForwardOrBackward(int n) {
    emit(state.copyWith(current: state.current.goMonthsForwardOrBackward(n)));
  }
}
