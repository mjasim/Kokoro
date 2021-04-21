// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// StackedLocatorGenerator
// **************************************************************************

// ignore_for_file: public_member_api_docs

import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../core/services/firebase_auth_service.dart';
import '../core/services/firebase_database_service.dart';
import '../core/services/firebase_storage_service.dart';
import '../core/services/global_map_service.dart';
import '../core/services/mock_auth_service.dart';
import '../core/services/navigation_bar_service.dart';
import '../core/services/user_information_service.dart';

final locator = StackedLocator.instance;

void setupLocator() {
  locator.registerLazySingleton(() => NavigationService());
  locator.registerLazySingleton(() => MockAuthService());
  locator.registerLazySingleton(() => NavigationBarService());
  locator.registerLazySingleton(() => FirebaseAuthService());
  locator.registerLazySingleton(() => GlobalMapService());
  locator.registerLazySingleton(() => FirebaseDatabaseService());
  locator.registerLazySingleton(() => FirebaseStorageService());
  locator.registerLazySingleton(() => UserInformationService());
}
