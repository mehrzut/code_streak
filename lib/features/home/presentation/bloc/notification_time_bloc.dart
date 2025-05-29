import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:code_streak/core/data/failure.dart';
import 'package:code_streak/core/data/usecase.dart';
import 'package:code_streak/features/home/domain/usecases/get_notification_time.dart';
import 'package:code_streak/features/home/domain/usecases/set_notification_time.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part 'notification_time_event.dart';
part 'notification_time_state.dart';
part 'notification_time_bloc.freezed.dart';

@injectable
class NotificationTimeBloc
    extends Bloc<NotificationTimeEvent, NotificationTimeState> {
  final SetNotificationTime _setNotificationTime;
  final GetNotificationTime _getNotificationTime;

  NotificationTimeBloc(
    this._setNotificationTime,
    this._getNotificationTime,
  ) : super(_InitialState()) {
    on<_SetNotificationTimeEvent>(_onSetNotificationTimeEvent);
    on<_GetNotificationTimeEvent>(_onGetNotificationTimeEvent);

    // Fetch notification time when bloc is created
    add(NotificationTimeEvent.get());
  }

  Future<void> _onSetNotificationTimeEvent(_SetNotificationTimeEvent event,
      Emitter<NotificationTimeState> emit) async {
    if (state is _SuccessState &&
        (state as _SuccessState).notificationTime == event.notificationTime) {
      return;
    }
    emit(NotificationTimeState.loading());
    final response = await _setNotificationTime(Params(
      notificationTime: event.notificationTime,
    ));
    final newState = response.when(
      failed: (failure) => NotificationTimeState.failed(failure: failure),
      success: (data) => NotificationTimeState.success(
        notificationTime: event.notificationTime,
        recentlyChanged: true,
      ),
    );
    emit(newState);
  }

  Future<void> _onGetNotificationTimeEvent(_GetNotificationTimeEvent event,
      Emitter<NotificationTimeState> emit) async {
    emit(NotificationTimeState.loading());
    final response = await _getNotificationTime(NoParams());
    final newState = response.when(
      failed: (failure) => NotificationTimeState.failed(failure: failure),
      success: (data) => NotificationTimeState.success(
        notificationTime: data,
        recentlyChanged: false,
      ),
    );
    emit(newState);
  }
}
