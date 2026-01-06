// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:flutter/material.dart' as _i409;
import 'package:flutter_riverpod/flutter_riverpod.dart' as _i729;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:vista_flicks/framework/controller/auth/initial_watch_preferences/initial_watch_preferences_controller.dart'
    as _i630;
import 'package:vista_flicks/framework/controller/auth/on_boarding/on_boarding_controller.dart'
    as _i896;
import 'package:vista_flicks/framework/controller/blank/blank_controller.dart'
    as _i692;
import 'package:vista_flicks/framework/controller/invite_friend/invite_friend_controller.dart'
    as _i899;
import 'package:vista_flicks/framework/controller/invite_friend/search_controller.dart'
    as _i745;
import 'package:vista_flicks/framework/controller/main/account_and_pref/account_and_pref_controller.dart'
    as _i186;
import 'package:vista_flicks/framework/controller/main/account_and_pref/filter/filter_controller.dart'
    as _i402;
import 'package:vista_flicks/framework/controller/main/account_and_pref/privacy_policy/privacy_policy_controller.dart'
    as _i585;
import 'package:vista_flicks/framework/controller/main/account_and_pref/terms_of_use/terms_of_use_controller.dart'
    as _i1069;
import 'package:vista_flicks/framework/controller/main/account_and_pref/update_profile/update_profile_controller.dart'
    as _i709;
import 'package:vista_flicks/framework/controller/main/bookmark/bookmark_controller.dart'
    as _i438;
import 'package:vista_flicks/framework/controller/main/chatbot/chatbot_controller.dart'
    as _i617;
import 'package:vista_flicks/framework/controller/main/explore/explore_controller.dart'
    as _i1028;
import 'package:vista_flicks/framework/controller/main/inbox/inbox_home/inbox_home_controller.dart'
    as _i396;
import 'package:vista_flicks/framework/controller/main/inbox/single_group/single_group_controller.dart'
    as _i208;
import 'package:vista_flicks/framework/controller/main/preview_and_detail/detail/detail_api_repository.dart'
    as _i47;
import 'package:vista_flicks/framework/controller/main/preview_and_detail/detail/detail_controller.dart'
    as _i43;
import 'package:vista_flicks/framework/controller/main/preview_and_detail/detail/detail_repository.dart'
    as _i458;
import 'package:vista_flicks/framework/controller/main/reel/reels_controller.dart'
    as _i310;
import 'package:vista_flicks/framework/controller/splash/splash_home/splash_home_view_controller.dart'
    as _i876;
import 'package:vista_flicks/framework/controller/splash/splash_view/splash_view_controller.dart'
    as _i405;
import 'package:vista_flicks/framework/dependency_injection/modules/dio_api_client.dart'
    as _i601;
import 'package:vista_flicks/framework/dependency_injection/modules/dio_looger_module.dart'
    as _i897;
import 'package:vista_flicks/framework/provider/network/dio/dio_client.dart'
    as _i53;
import 'package:vista_flicks/framework/provider/network/dio/dio_logger.dart'
    as _i470;
import 'package:vista_flicks/framework/provider/network/network.dart' as _i72;
import 'package:vista_flicks/framework/repository/auth/on_boarding/contract/on_boarding_repository.dart'
    as _i650;
import 'package:vista_flicks/framework/repository/auth/on_boarding/repository/on_boarding_api_repository.dart'
    as _i286;
import 'package:vista_flicks/framework/repository/bookmark/contract/bookmark_repository.dart'
    as _i923;
import 'package:vista_flicks/framework/repository/bookmark/repository/bookmark_api_repository.dart'
    as _i243;
import 'package:vista_flicks/framework/repository/chatbot/contract/chatbot_repository.dart'
    as _i518;
import 'package:vista_flicks/framework/repository/chatbot/repository/chatbot_api_repository.dart'
    as _i42;
import 'package:vista_flicks/framework/repository/main/account_and_pref/privacy_policy/contract/privacy_policy_repository.dart'
    as _i250;
import 'package:vista_flicks/framework/repository/main/account_and_pref/privacy_policy/repository/privacy_policy_api_repository.dart'
    as _i327;
import 'package:vista_flicks/framework/repository/main/account_and_pref/terms_of_use/contract/terms_of_use_repository.dart'
    as _i752;
import 'package:vista_flicks/framework/repository/main/account_and_pref/terms_of_use/repository/terms_of_use_api_repository.dart'
    as _i429;
import 'package:vista_flicks/framework/repository/preferences/contract/preference_repository.dart'
    as _i917;
import 'package:vista_flicks/framework/repository/preferences/repository/preference_api_repository.dart'
    as _i506;
import 'package:vista_flicks/framework/repository/reels/contract/reels_repository.dart'
    as _i214;
import 'package:vista_flicks/framework/repository/reels/repository/reels_api_repository.dart'
    as _i245;
import 'package:vista_flicks/framework/repository/search/contract/search_repository.dart'
    as _i796;
import 'package:vista_flicks/framework/repository/search/repository/search_api_repository.dart'
    as _i11;
import 'package:vista_flicks/ui/routing/delegate.dart' as _i32;
import 'package:vista_flicks/ui/routing/navigation_stack_item.dart' as _i556;
import 'package:vista_flicks/ui/routing/parser.dart' as _i25;
import 'package:vista_flicks/ui/routing/stack.dart' as _i1016;
import 'package:vista_flicks/ui/utils/anim/custom_animation_controller.dart'
    as _i301;

const String _development = 'development';
const String _production = 'production';
const String _reel = 'reel';

extension GetItInjectableX on _i174.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final dioLoggerModule = _$DioLoggerModule();
    final networkModule = _$NetworkModule();
    gh.factory<_i301.CustomAnimationController>(
        () => _i301.CustomAnimationController());
    gh.factory<_i899.InviteFriendController>(
        () => _i899.InviteFriendController());
    gh.factory<_i745.SearchController>(() => _i745.SearchController());
    gh.factory<_i876.SplashHomeController>(() => _i876.SplashHomeController());
    gh.factory<_i405.SplashViewController>(() => _i405.SplashViewController());
    gh.factory<_i692.BlankController>(() => _i692.BlankController());
    gh.factory<_i208.SingleGroupController>(
        () => _i208.SingleGroupController());
    gh.factory<_i396.InboxHomeController>(() => _i396.InboxHomeController());
    gh.factory<_i709.UpdateProfileController>(
        () => _i709.UpdateProfileController());
    gh.factory<_i186.AccountAndPrefController>(
        () => _i186.AccountAndPrefController());
    gh.factoryParam<_i32.MainRouterDelegate, _i1016.NavigationStack, dynamic>((
      stack,
      _,
    ) =>
        _i32.MainRouterDelegate(stack));
    gh.lazySingleton<_i470.DioLogger>(
      () => dioLoggerModule.getDioLogger(),
      registerFor: {
        _development,
        _production,
        _reel,
      },
    );
    gh.factoryParam<_i1016.NavigationStack, List<_i556.NavigationStackItem>,
        dynamic>((
      items,
      _,
    ) =>
        _i1016.NavigationStack(items));
    gh.factoryParam<_i25.MainRouterInformationParser, _i729.WidgetRef,
        _i409.BuildContext>((
      ref,
      context,
    ) =>
        _i25.MainRouterInformationParser(
          ref,
          context,
        ));
    gh.lazySingleton<_i53.DioClient>(
      () => networkModule.getDebugDioClient(gh<_i470.DioLogger>()),
      registerFor: {_development},
    );
    gh.lazySingleton<_i53.DioClient>(
      () => networkModule.getProductionDioClient(gh<_i470.DioLogger>()),
      registerFor: {_production},
    );
    gh.lazySingleton<_i53.DioClient>(
      () => networkModule.getReelDioClient(gh<_i470.DioLogger>()),
      registerFor: {_reel},
    );
    gh.lazySingleton<_i752.TermsOfUseRepository>(
      () => _i429.TermsOfUseApiRepository(gh<_i72.DioClient>()),
      registerFor: {
        _development,
        _production,
      },
    );
    gh.lazySingleton<_i458.DetailRepository>(
      () => _i47.DetailApiRepository(gh<_i72.DioClient>()),
      registerFor: {
        _development,
        _production,
      },
    );
    gh.lazySingleton<_i250.PrivacyPolicyRepository>(
      () => _i327.PrivacyPolicyApiRepository(gh<_i72.DioClient>()),
      registerFor: {
        _development,
        _production,
      },
    );
    gh.lazySingleton<_i214.ReelsRepository>(
      () => _i245.ReelsApiRepository(gh<_i72.DioClient>()),
      registerFor: {
        _development,
        _production,
      },
    );
    gh.factory<_i43.DetailController>(
        () => _i43.DetailController(gh<_i458.DetailRepository>()));
    gh.lazySingleton<_i923.BookmarkRepository>(
      () => _i243.BookmarkApiRepository(gh<_i72.DioClient>()),
      registerFor: {
        _development,
        _production,
      },
    );
    gh.factory<_i585.PrivacyPolicyController>(() =>
        _i585.PrivacyPolicyController(gh<_i250.PrivacyPolicyRepository>()));
    gh.lazySingleton<_i796.SearchRepository>(
      () => _i11.SearchApiRepository(gh<_i72.DioClient>()),
      registerFor: {
        _development,
        _production,
      },
    );
    gh.lazySingleton<_i917.PreferenceRepository>(
      () => _i506.PreferenceApiRepository(gh<_i72.DioClient>()),
      registerFor: {
        _development,
        _production,
      },
    );
    gh.lazySingleton<_i518.ChatbotRepository>(
      () => _i42.ChatbotApiRepository(gh<_i72.DioClient>()),
      registerFor: {
        _development,
        _production,
      },
    );
    gh.lazySingleton<_i650.OnBoardingRepository>(
      () => _i286.OnBoardingApiRepository(gh<_i72.DioClient>()),
      registerFor: {
        _development,
        _production,
      },
    );
    gh.factory<_i1069.TermsOfUseController>(
        () => _i1069.TermsOfUseController(gh<_i752.TermsOfUseRepository>()));
    gh.factory<_i1028.ExploreController>(
        () => _i1028.ExploreController(gh<_i796.SearchRepository>()));
    gh.factory<_i630.InitialWatchPreferencesController>(() =>
        _i630.InitialWatchPreferencesController(
            gh<_i917.PreferenceRepository>()));
    gh.factory<_i402.FilterController>(
        () => _i402.FilterController(gh<_i917.PreferenceRepository>()));
    gh.factory<_i438.BookmarkController>(
        () => _i438.BookmarkController(gh<_i923.BookmarkRepository>()));
    gh.factory<_i310.ReelsController>(
        () => _i310.ReelsController(gh<_i214.ReelsRepository>()));
    gh.factory<_i896.OnBoardingController>(
        () => _i896.OnBoardingController(gh<_i650.OnBoardingRepository>()));
    gh.factory<_i617.ChatbotController>(
        () => _i617.ChatbotController(gh<_i518.ChatbotRepository>()));
    return this;
  }
}

class _$DioLoggerModule extends _i897.DioLoggerModule {}

class _$NetworkModule extends _i601.NetworkModule {}
