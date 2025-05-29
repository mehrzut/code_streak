// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:code_streak/core/controllers/client_handler.dart' as _i3;
import 'package:code_streak/core/controllers/local_database.dart' as _i8;
import 'package:code_streak/core/controllers/navigation_helper.dart' as _i7;
import 'package:code_streak/features/auth/data/datasources/auth_data_source.dart'
    as _i6;
import 'package:code_streak/features/auth/data/repositories/auth_repo_impl.dart'
    as _i22;
import 'package:code_streak/features/auth/domain/repositories/auth_repo.dart'
    as _i21;
import 'package:code_streak/features/auth/domain/usecases/load_session.dart'
    as _i26;
import 'package:code_streak/features/auth/domain/usecases/login_with_github.dart'
    as _i27;
import 'package:code_streak/features/auth/domain/usecases/sign_out.dart'
    as _i28;
import 'package:code_streak/features/auth/presentation/bloc/auth_bloc.dart'
    as _i31;
import 'package:code_streak/features/auth/presentation/bloc/sign_out_bloc.dart'
    as _i29;
import 'package:code_streak/features/home/data/datasources/home_data_source.dart'
    as _i4;
import 'package:code_streak/features/home/data/repositories/home_repo_impl.dart'
    as _i10;
import 'package:code_streak/features/home/domain/repositories/home_repo.dart'
    as _i9;
import 'package:code_streak/features/home/domain/usecases/get_contributions_data.dart'
    as _i13;
import 'package:code_streak/features/home/domain/usecases/get_notification_time.dart'
    as _i17;
import 'package:code_streak/features/home/domain/usecases/get_user_info.dart'
    as _i14;
import 'package:code_streak/features/home/domain/usecases/set_notification_time.dart'
    as _i15;
import 'package:code_streak/features/home/domain/usecases/set_user_reminders.dart'
    as _i16;
import 'package:code_streak/features/home/presentation/bloc/contributions_bloc.dart'
    as _i25;
import 'package:code_streak/features/home/presentation/bloc/notification_time_bloc.dart'
    as _i18;
import 'package:code_streak/features/home/presentation/bloc/reminder_bloc.dart'
    as _i24;
import 'package:code_streak/features/home/presentation/bloc/user_info_bloc.dart'
    as _i23;
import 'package:code_streak/features/theme/data/datasources/theme_data_source.dart'
    as _i5;
import 'package:code_streak/features/theme/data/repositories/theme_repo_impl.dart'
    as _i12;
import 'package:code_streak/features/theme/domain/repositories/theme_repo.dart'
    as _i11;
import 'package:code_streak/features/theme/domain/usecases/check_theme.dart'
    as _i19;
import 'package:code_streak/features/theme/domain/usecases/save_theme.dart'
    as _i20;
import 'package:code_streak/features/theme/presentation/bloc/theme_bloc.dart'
    as _i30;
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;

extension GetItInjectableX on _i1.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  _i1.GetIt init({
    String? environment,
    _i2.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i2.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    gh.lazySingleton<_i3.ClientHandler>(() => _i3.ClientHandler());
    gh.lazySingleton<_i4.HomeDataSource>(() => _i4.HomeDataSourceImpl());
    gh.lazySingleton<_i5.ThemeDataSource>(() => _i5.ThemeDataSourceImpl());
    gh.lazySingleton<_i6.AuthDataSource>(() => _i6.AuthDataSourceImpl());
    gh.lazySingleton<_i7.NavigationHelper>(() => _i7.NavigationHelperImpl());
    gh.lazySingleton<_i8.LocalDatabase>(() => const _i8.LocalDatabaseImpl());
    gh.lazySingleton<_i9.HomeRepo>(() => _i10.HomeRepoImpl(
          dataSource: gh<_i4.HomeDataSource>(),
          localDatabase: gh<_i8.LocalDatabase>(),
        ));
    gh.lazySingleton<_i11.ThemeRepo>(
        () => _i12.ThemeRepoImpl(localDatabase: gh<_i8.LocalDatabase>()));
    gh.lazySingleton<_i13.GetContributionsData>(
        () => _i13.GetContributionsData(repo: gh<_i9.HomeRepo>()));
    gh.lazySingleton<_i14.GetUserInfo>(
        () => _i14.GetUserInfo(repo: gh<_i9.HomeRepo>()));
    gh.lazySingleton<_i15.SetNotificationTime>(
        () => _i15.SetNotificationTime(repo: gh<_i9.HomeRepo>()));
    gh.lazySingleton<_i16.SetUserReminders>(
        () => _i16.SetUserReminders(repo: gh<_i9.HomeRepo>()));
    gh.lazySingleton<_i17.GetNotificationTime>(
        () => _i17.GetNotificationTime(repo: gh<_i9.HomeRepo>()));
    gh.factory<_i18.NotificationTimeBloc>(() => _i18.NotificationTimeBloc(
          gh<_i15.SetNotificationTime>(),
          gh<_i17.GetNotificationTime>(),
        ));
    gh.lazySingleton<_i19.CheckTheme>(
        () => _i19.CheckTheme(repo: gh<_i11.ThemeRepo>()));
    gh.lazySingleton<_i20.SaveTheme>(
        () => _i20.SaveTheme(repo: gh<_i11.ThemeRepo>()));
    gh.lazySingleton<_i21.AuthRepo>(() => _i22.AuthRepoImpl(
          dataSource: gh<_i6.AuthDataSource>(),
          localDatabase: gh<_i8.LocalDatabase>(),
        ));
    gh.factory<_i23.UserInfoBloc>(
        () => _i23.UserInfoBloc(gh<_i14.GetUserInfo>()));
    gh.factory<_i24.ReminderBloc>(
        () => _i24.ReminderBloc(gh<_i16.SetUserReminders>()));
    gh.factory<_i25.ContributionsBloc>(
        () => _i25.ContributionsBloc(gh<_i13.GetContributionsData>()));
    gh.lazySingleton<_i26.LoadSession>(
        () => _i26.LoadSession(repo: gh<_i21.AuthRepo>()));
    gh.lazySingleton<_i27.LoginWithGitHub>(
        () => _i27.LoginWithGitHub(repo: gh<_i21.AuthRepo>()));
    gh.lazySingleton<_i28.SignOut>(
        () => _i28.SignOut(repo: gh<_i21.AuthRepo>()));
    gh.factory<_i29.SignOutBloc>(() => _i29.SignOutBloc(gh<_i28.SignOut>()));
    gh.lazySingleton<_i30.ThemeBloc>(() => _i30.ThemeBloc(
          gh<_i19.CheckTheme>(),
          gh<_i20.SaveTheme>(),
        ));
    gh.factory<_i31.AuthBloc>(() => _i31.AuthBloc(
          gh<_i27.LoginWithGitHub>(),
          gh<_i26.LoadSession>(),
        ));
    return this;
  }
}
