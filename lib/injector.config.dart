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
    as _i8;
import 'package:code_streak/features/auth/domain/repositories/auth_repo.dart'
    as _i7;
import 'package:code_streak/features/auth/domain/usecases/login_with_github.dart'
    as _i9;
import 'package:code_streak/features/auth/presentation/bloc/auth_bloc.dart'
    as _i10;
import 'package:code_streak/features/home/data/datasources/home_data_source.dart'
    as _i4;
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
    gh.lazySingleton<_i7.AuthRepo>(() => _i8.AuthRepoImpl(
          dataSource: gh<_i5.AuthDataSource>(),
          localDatabase: gh<_i6.LocalDatabase>(),
        ));
    gh.lazySingleton<_i9.LoginWithGitHub>(
        () => _i9.LoginWithGitHub(repo: gh<_i7.AuthRepo>()));
    gh.factory<_i10.AuthBloc>(() => _i10.AuthBloc(gh<_i9.LoginWithGitHub>()));
    return this;
  }
}
