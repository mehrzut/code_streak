import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import 'injector.config.dart';

final sl = GetIt.instance;

@InjectableInit()
Future configureDependencies() async => sl.init();
