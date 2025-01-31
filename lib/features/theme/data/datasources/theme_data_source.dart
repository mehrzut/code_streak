
import 'package:injectable/injectable.dart';

abstract class ThemeDataSource {}

@LazySingleton(as: ThemeDataSource)
class ThemeDataSourceImpl implements ThemeDataSource{}