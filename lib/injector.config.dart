// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:code_streak/core/controllers/client_handler.dart' as _i3;
import 'package:code_streak/core/controllers/local_database.dart' as _i7;
import 'package:code_streak/core/controllers/navigation_helper.dart' as _i6;
import 'package:code_streak/features/auth/data/datasources/auth_data_source.dart'
    as _i5;
import 'package:code_streak/features/auth/data/repositories/auth_repo_impl.dart'
    as _i14;
import 'package:code_streak/features/auth/domain/repositories/auth_repo.dart'
    as _i13;
import 'package:code_streak/features/auth/domain/usecases/load_session.dart'
    as _i19;
import 'package:code_streak/features/auth/domain/usecases/login_with_github.dart'
    as _i20;
import 'package:code_streak/features/auth/domain/usecases/sign_out.dart'
    as _i18;
import 'package:code_streak/features/auth/presentation/bloc/auth_bloc.dart'
    as _i22;
import 'package:code_streak/features/auth/presentation/bloc/sign_out_bloc.dart'
    as _i21;
import 'package:code_streak/features/home/data/datasources/home_data_source.dart'
    as _i4;
import 'package:code_streak/features/home/data/repositories/home_repo_impl.dart'
    as _i9;
import 'package:code_streak/features/home/domain/repositories/home_repo.dart'
    as _i8;
import 'package:code_streak/features/home/domain/usecases/get_contributions_data.dart'
    as _i10;
import 'package:code_streak/features/home/domain/usecases/get_user_info.dart'
    as _i12;
import 'package:code_streak/features/home/domain/usecases/set_user_reminders.dart'
    as _i11;
import 'package:code_streak/features/home/presentation/bloc/contributions_bloc.dart'
    as _i17;
import 'package:code_streak/features/home/presentation/bloc/reminder_bloc.dart'
    as _i16;
import 'package:code_streak/features/home/presentation/bloc/user_info_bloc.dart'
    as _i15;
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
    gh.lazySingleton<_i5.AuthDataSource>(() => _i5.AuthDataSourceImpl());
    gh.lazySingleton<_i6.NavigationHelper>(() => _i6.NavigationHelperImpl());
    gh.lazySingleton<_i7.LocalDatabase>(() => const _i7.LocalDatabaseImpl());
    gh.lazySingleton<_i8.HomeRepo>(
        () => _i9.HomeRepoImpl(dataSource: gh<_i4.HomeDataSource>()));
    gh.lazySingleton<_i10.GetContributionsData>(
        () => _i10.GetContributionsData(repo: gh<_i8.HomeRepo>()));
    gh.lazySingleton<_i11.SetUserReminders>(
        () => _i11.SetUserReminders(repo: gh<_i8.HomeRepo>()));
    gh.lazySingleton<_i12.GetUserInfo>(
        () => _i12.GetUserInfo(repo: gh<_i8.HomeRepo>()));
    gh.lazySingleton<_i13.AuthRepo>(() => _i14.AuthRepoImpl(
          dataSource: gh<_i5.AuthDataSource>(),
          localDatabase: gh<_i7.LocalDatabase>(),
        ));
    gh.factory<_i15.UserInfoBloc>(
        () => _i15.UserInfoBloc(gh<_i12.GetUserInfo>()));
    gh.factory<_i16.ReminderBloc>(
        () => _i16.ReminderBloc(gh<_i11.SetUserReminders>()));
    gh.factory<_i17.ContributionsBloc>(
        () => _i17.ContributionsBloc(gh<_i10.GetContributionsData>()));
    gh.lazySingleton<_i18.SignOut>(
        () => _i18.SignOut(repo: gh<_i13.AuthRepo>()));
    gh.lazySingleton<_i19.LoadSession>(
        () => _i19.LoadSession(repo: gh<_i13.AuthRepo>()));
    gh.lazySingleton<_i20.LoginWithGitHub>(
        () => _i20.LoginWithGitHub(repo: gh<_i13.AuthRepo>()));
    gh.factory<_i21.SignOutBloc>(() => _i21.SignOutBloc(gh<_i18.SignOut>()));
    gh.factory<_i22.AuthBloc>(() => _i22.AuthBloc(
          gh<_i20.LoginWithGitHub>(),
          gh<_i19.LoadSession>(),
        ));
    return this;
  }
}
