// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// StackedRouterGenerator
// **************************************************************************

// ignore_for_file: public_member_api_docs

import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import '../ui/auth/sign_in/signin_view.dart';
import '../ui/auth/sign_up/signup_view.dart';
import '../ui/views/global_view/global_view.dart';
import '../ui/views/history_view/history_view.dart';
import '../ui/views/home_view/home_view.dart';
import '../ui/views/make_post_view/make_post_view.dart';
import '../ui/views/personal_home_view/personal_home_view.dart';
import '../ui/views/personal_view/personal_view.dart';
import '../ui/views/planet_drilldown_view/planet_drilldown_view.dart';
import '../ui/views/planet_home_view/planet_home_view.dart';
import '../ui/views/planet_view/planet_view.dart';

class Routes {
  static const String planetView = '/planet-view';
  static const String globalView = '/global-view';
  static const String makePostView = '/make-post-view';
  static const String homeView = '/home-view';
  static const String historyView = '/history-view';
  static const String personalView = '/personal-view';
  static const String planetDrillDownView = '/planet-drill-down-view';
  static const String personalHomeView = '/personal-home-view';
  static const String planetHomeView = '/planet-home-view';
  static const String signInView = '/';
  static const String signUpView = '/sign-up-view';
  static const all = <String>{
    planetView,
    globalView,
    makePostView,
    homeView,
    historyView,
    personalView,
    planetDrillDownView,
    personalHomeView,
    planetHomeView,
    signInView,
    signUpView,
  };
}

class StackedRouter extends RouterBase {
  @override
  List<RouteDef> get routes => _routes;
  final _routes = <RouteDef>[
    RouteDef(Routes.planetView, page: PlanetView),
    RouteDef(Routes.globalView, page: GlobalView),
    RouteDef(Routes.makePostView, page: MakePostView),
    RouteDef(Routes.homeView, page: HomeView),
    RouteDef(Routes.historyView, page: HistoryView),
    RouteDef(Routes.personalView, page: PersonalView),
    RouteDef(Routes.planetDrillDownView, page: PlanetDrillDownView),
    RouteDef(Routes.personalHomeView, page: PersonalHomeView),
    RouteDef(Routes.planetHomeView, page: PlanetHomeView),
    RouteDef(Routes.signInView, page: SignInView),
    RouteDef(Routes.signUpView, page: SignUpView),
  ];
  @override
  Map<Type, StackedRouteFactory> get pagesMap => _pagesMap;
  final _pagesMap = <Type, StackedRouteFactory>{
    PlanetView: (data) {
      return PageRouteBuilder<dynamic>(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const PlanetView(),
        settings: data,
        transitionDuration: const Duration(milliseconds: 0),
      );
    },
    GlobalView: (data) {
      return PageRouteBuilder<dynamic>(
        pageBuilder: (context, animation, secondaryAnimation) => GlobalView(),
        settings: data,
        transitionDuration: const Duration(milliseconds: 0),
      );
    },
    MakePostView: (data) {
      return PageRouteBuilder<dynamic>(
        pageBuilder: (context, animation, secondaryAnimation) => MakePostView(),
        settings: data,
        transitionDuration: const Duration(milliseconds: 0),
      );
    },
    HomeView: (data) {
      return PageRouteBuilder<dynamic>(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const HomeView(),
        settings: data,
        transitionDuration: const Duration(milliseconds: 0),
      );
    },
    HistoryView: (data) {
      return PageRouteBuilder<dynamic>(
        pageBuilder: (context, animation, secondaryAnimation) => HistoryView(),
        settings: data,
        transitionDuration: const Duration(milliseconds: 0),
      );
    },
    PersonalView: (data) {
      return PageRouteBuilder<dynamic>(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const PersonalView(),
        settings: data,
        transitionDuration: const Duration(milliseconds: 0),
      );
    },
    PlanetDrillDownView: (data) {
      return PageRouteBuilder<dynamic>(
        pageBuilder: (context, animation, secondaryAnimation) =>
            PlanetDrillDownView(),
        settings: data,
        transitionDuration: const Duration(milliseconds: 0),
      );
    },
    PersonalHomeView: (data) {
      var args = data.getArgs<PersonalHomeViewArguments>(
        orElse: () => PersonalHomeViewArguments(),
      );
      return PageRouteBuilder<dynamic>(
        pageBuilder: (context, animation, secondaryAnimation) =>
            PersonalHomeView(
          key: args.key,
          uid: args.uid,
        ),
        settings: data,
        transitionDuration: const Duration(milliseconds: 0),
      );
    },
    PlanetHomeView: (data) {
      var args = data.getArgs<PlanetHomeViewArguments>(
        orElse: () => PlanetHomeViewArguments(),
      );
      return PageRouteBuilder<dynamic>(
        pageBuilder: (context, animation, secondaryAnimation) => PlanetHomeView(
          key: args.key,
          uid: args.uid,
        ),
        settings: data,
        transitionDuration: const Duration(milliseconds: 0),
      );
    },
    SignInView: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => SignInView(),
        settings: data,
      );
    },
    SignUpView: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => SignUpView(),
        settings: data,
      );
    },
  };
}

/// ************************************************************************
/// Arguments holder classes
/// *************************************************************************

/// PersonalHomeView arguments holder class
class PersonalHomeViewArguments {
  final Key key;
  final String uid;
  PersonalHomeViewArguments({this.key, this.uid});
}

/// PlanetHomeView arguments holder class
class PlanetHomeViewArguments {
  final Key key;
  final String uid;
  PlanetHomeViewArguments({this.key, this.uid});
}
