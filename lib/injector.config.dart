// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:code_streak/core/controllers/api_handler.dart' as _i3;
import 'package:code_streak/core/controllers/local_database.dart' as _i6;
import 'package:code_streak/features/auth/data/datasources/auth_data_source.dart'
    as _i5;
import 'package:code_streak/features/auth/data/repositories/auth_repo_impl.dart'
    as _i13;
import 'package:code_streak/features/auth/domain/repositories/auth_repo.dart'
    as _i12;
import 'package:code_streak/features/auth/domain/usecases/load_session.dart'
    as _i17;
import 'package:code_streak/features/auth/domain/usecases/login_with_github.dart'
    as _i18;
import 'package:code_streak/features/auth/presentation/bloc/auth_bloc.dart'
    as _i19;
import 'package:code_streak/features/home/data/datasources/home_data_source.dart'
    as _i4;
import 'package:code_streak/features/home/data/repositories/home_repo_impl.dart'
    as _i8;
import 'package:code_streak/features/home/domain/repositories/home_repo.dart'
    as _i7;
import 'package:code_streak/features/home/domain/usecases/get_contributions_data.dart'
    as _i9;
import 'package:code_streak/features/home/domain/usecases/get_user_info.dart'
    as _i10;
import 'package:code_streak/features/home/domain/usecases/set_user_reminders.dart'
    as _i11;
import 'package:code_streak/features/home/presentation/bloc/contributions_bloc.dart'
    as _i16;
import 'package:code_streak/features/home/presentation/bloc/reminder_bloc.dart'
    as _i15;
import 'package:code_streak/features/home/presentation/bloc/user_info_bloc.dart'
    as _i14;
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
    gh.lazySingleton<_i3.ApiHandler>(() => _i3.ApiHandler());
    gh.lazySingleton<_i4.HomeDataSource>(() => _i4.HomeDataSourceImpl());
    gh.lazySingleton<_i5.AuthDataSource>(() => _i5.AuthDataSourceImpl());
    gh.lazySingleton<_i6.LocalDatabase>(() => const _i6.LocalDatabaseImpl());
    gh.lazySingleton<_i7.HomeRepo>(
        () => _i8.HomeRepoImpl(dataSource: gh<_i4.HomeDataSource>()));
    gh.lazySingleton<_i9.GetContributionsData>(
        () => _i9.GetContributionsData(repo: gh<_i7.HomeRepo>()));
    gh.lazySingleton<_i10.GetUserInfo>(
        () => _i10.GetUserInfo(repo: gh<_i7.HomeRepo>()));
    gh.lazySingleton<_i11.SetUserReminders>(
        () => _i11.SetUserReminders(repo: gh<_i7.HomeRepo>()));
    gh.lazySingleton<_i12.AuthRepo>(() => _i13.AuthRepoImpl(
          dataSource: gh<_i5.AuthDataSource>(),
          localDatabase: gh<_i6.LocalDatabase>(),
        ));
    gh.factory<_i14.UserInfoBloc>(
        () => _i14.UserInfoBloc(gh<_i10.GetUserInfo>()));
    gh.factory<_i15.ReminderBloc>(
        () => _i15.ReminderBloc(gh<_i11.SetUserReminders>()));
    gh.factory<_i16.ContributionsBloc>(
        () => _i16.ContributionsBloc(gh<_i9.GetContributionsData>()));
    gh.lazySingleton<_i17.LoadSession>(
        () => _i17.LoadSession(repo: gh<_i12.AuthRepo>()));
    gh.lazySingleton<_i18.LoginWithGitHub>(
        () => _i18.LoginWithGitHub(repo: gh<_i12.AuthRepo>()));
    gh.factory<_i19.AuthBloc>(() => _i19.AuthBloc(
          gh<_i18.LoginWithGitHub>(),
          gh<_i17.LoadSession>(),
        ));
    return this;
  }
}
