import 'package:kokoro/core/services/firebase_auth_service.dart';
import 'package:kokoro/core/services/firebase_database_service.dart';
import 'package:kokoro/core/services/firebase_storage_service.dart';
import 'package:kokoro/core/services/global_map_service.dart';
import 'package:kokoro/core/services/mock_auth_service.dart';
import 'package:kokoro/core/services/navigation_bar_service.dart';
import 'package:kokoro/ui/auth/sign_in/signin_view.dart';
import 'package:kokoro/ui/auth/sign_up/signup_view.dart';
import 'package:kokoro/ui/views/global_view/global_view.dart';
import 'package:kokoro/ui/views/history_view/history_view.dart';
import 'package:kokoro/ui/views/home_view/home_view.dart';
import 'package:kokoro/ui/views/make_post_view/make_post_view.dart';
import 'package:kokoro/ui/views/personal_view/personal_view.dart';
import 'package:kokoro/ui/views/planet_drilldown_view/planet_drilldown_view.dart';
import 'package:kokoro/ui/views/planet_view/planet_view.dart';
import 'package:stacked/stacked_annotations.dart';
import 'package:stacked_services/stacked_services.dart';

@StackedApp(
  routes: [
    CustomRoute(page: PlanetView, durationInMilliseconds: 0),
    CustomRoute(page: GlobalView, durationInMilliseconds: 0),
    CustomRoute(page: MakePostView, durationInMilliseconds: 0),
    CustomRoute(page: HomeView, durationInMilliseconds: 0),
    CustomRoute(page: HistoryView, durationInMilliseconds: 0),
    CustomRoute(page: PersonalView, durationInMilliseconds: 0),
    CustomRoute(page: PlanetDrillDownView, durationInMilliseconds: 0),
    MaterialRoute(page: SignInView, initial: true),
    MaterialRoute(page: SignUpView),
  ],
  dependencies: [
    LazySingleton(classType: NavigationService),
    LazySingleton(classType: MockAuthService),
    LazySingleton(classType: NavigationBarService),
    LazySingleton(classType: FirebaseAuthService),
    LazySingleton(classType: GlobalMapService),
    LazySingleton(classType: FirebaseDatabaseService),
    LazySingleton(classType: FirebaseStorageService)
  ],
)
class AppSetup {
  /** Serves no purpose besides having an annotation attached to it */
}
