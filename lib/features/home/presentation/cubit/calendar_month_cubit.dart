import 'package:bloc/bloc.dart';
import 'package:code_streak/core/extensions.dart';
import 'package:code_streak/features/home/domain/entities/contribution_day_data.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'calendar_month_state.dart';
part 'calendar_month_cubit.freezed.dart';

class CalendarMonthCubit extends Cubit<CalendarMonthState> {
  CalendarMonthCubit(List<ContributionDayData> allDaysContributionData)
      : super(CalendarMonthState(
          current: DateTime.now(),
          allDaysContributionData: allDaysContributionData,
        ));

  void nextMonth() {
    emit(state.copyWith(current: state.current.nextMonth));
  }

  void previousMonth() {
    emit(state.copyWith(current: state.current.previousMonth));
  }
}
