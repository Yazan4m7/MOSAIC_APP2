import 'package:get_it/get_it.dart';
import 'package:mosaic_doctors/models/sessionData.dart';

final getIt = GetIt.instance;

void setupLocator() {
  getIt.registerSingleton<SessionData>(SessionData());

  getIt.allowReassignment=true;

}