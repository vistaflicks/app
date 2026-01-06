import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:injectable/injectable.dart';
import 'package:vista_flicks/core/widgets/Common_see_all.dart';
import 'package:vista_flicks/ui/routing/stack.dart';
import 'package:vista_flicks/ui/screens/auth/initial_watch_preferences/initial_watch_preferences_screen.dart';
import 'package:vista_flicks/ui/screens/auth/otp_verify/otp_verify_screen.dart';
import 'package:vista_flicks/ui/screens/blank/blank_screen.dart';
import 'package:vista_flicks/ui/screens/main/account_and_pref/about/about_vista_flicks_screen.dart';
import 'package:vista_flicks/ui/screens/main/account_and_pref/account_and_pref_screen.dart';
import 'package:vista_flicks/ui/screens/main/account_and_pref/contact/contact_vista_flicks_screen.dart';
import 'package:vista_flicks/ui/screens/main/account_and_pref/filter/filter_screen.dart';
import 'package:vista_flicks/ui/screens/main/account_and_pref/terms_of_use/terms_of_use_screen.dart';
import 'package:vista_flicks/ui/screens/main/account_and_pref/update_profile/update_profile_screen.dart';
import 'package:vista_flicks/ui/screens/main/bookmark/bookmark_screen.dart';
import 'package:vista_flicks/ui/screens/main/bookmark/see_all_bookmarks.dart';
import 'package:vista_flicks/ui/screens/main/chatbot/chat_bot_screen.dart';
import 'package:vista_flicks/ui/screens/main/explore/explore_screen.dart';
import 'package:vista_flicks/ui/screens/main/explore/search_in_explore/search_in_explore_screen.dart';
import 'package:vista_flicks/ui/screens/main/inbox/create_group/create_group_screen.dart';
import 'package:vista_flicks/ui/screens/main/inbox/create_group/invite_friends_screen.dart';
import 'package:vista_flicks/ui/screens/main/inbox/search_group/search_group_screen.dart';
import 'package:vista_flicks/ui/screens/main/inbox/single_group/group_info/group_info_page.dart';
import 'package:vista_flicks/ui/screens/main/inbox/single_group/group_info/invite_friends_screen.dart';
import 'package:vista_flicks/ui/screens/main/inbox/single_group/single_group_screen.dart';
import 'package:vista_flicks/ui/screens/main/preview_and_detail/detail/detail_page.dart';

import '../error/web/error_404_web.dart';
import '../screens/auth/on_boarding/on_boarding_screen.dart';
import '../screens/auth/register_form/register_form_screen.dart';
import '../screens/main/account_and_pref/privacy_policy/privacy_policy_screen.dart';
import '../screens/main/inbox/helper/qr_scanner_screen.dart';
import '../screens/main/inbox/inbox_home/inbox_home_screen.dart';
import '../screens/main/reel/reel_screen.dart';
import '../screens/splash/splash_home/splash_home_screen.dart';
import '../screens/splash/splash_view/splash_view_screen.dart';
import 'navigation_stack_keys.dart';
import 'no_animation_route.dart';

final globalNavigatorKey = GlobalKey<NavigatorState>();

@injectable
class MainRouterDelegate extends RouterDelegate<NavigationStack>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin {
  final NavigationStack stack;

  @override
  void dispose() {
    stack.removeListener(notifyListeners);
    super.dispose();
  }

  MainRouterDelegate(@factoryParam this.stack) : super() {
    stack.addListener(notifyListeners);
  }

  @override
  final navigatorKey = globalNavigatorKey;

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, child) {
      return Navigator(
        key: navigatorKey,
        pages: _pages(ref),

        /// callback when a page is popped.
        onPopPage: (route, result) {
          /// let the OS handle the back press if there was nothing to pop
          if (!route.didPop(result)) {
            return false;
          }

          /// if we are on root, let OS close app
          if (stack.items.length == 1) return false;

          /// if we are on root, let OS close app
          if (stack.items.isEmpty) return false;

          /// otherwise, pop the stack and consume the event
          stack.pop();
          return true;
        },
      );
    });
  }

  List<Page> _pages(WidgetRef ref) => stack.items
      .mapIndexed(
        (e, i) => e.when(
          splash: () => const MaterialPage(
              child: SplashViewScreen(), key: ValueKey(Keys.splash)),
          splashHome: () => const MaterialPage(
              child: SplashHomeScreen(), key: ValueKey(Keys.splashHome)),
          onboarding: (isEmail) => MaterialPage(
              child: OnBoardingScreen(isEmail: isEmail!),
              key: const ValueKey(Keys.onboarding)),
          verifyOtp: (isEmail, inputController) => MaterialPage(
              child: OtpVerifyScreen(
                isEmail: isEmail!,
                inputController: inputController ?? "",
              ),
              key: const ValueKey(Keys.verifyOtp)),
          registerForm: (inputTxt) => MaterialPage(
              child: RegisterFormScreen(
                inputController: inputTxt ?? "",
              ),
              key: ValueKey(Keys.registerForm)),
          initWatchPref: () => const MaterialPage(
              child: InitialWatchPreferencesScreen(),
              key: ValueKey(Keys.initWatchPref)),
          reel: (reelId, contentId) => MaterialPage(
              child:
                  ReelScreen(reelId: reelId ?? "", contentId: contentId ?? ""),
              key: const ValueKey(Keys.reel)),
          explore: () => const MaterialPage(
              child: ExploreScreen(), key: ValueKey(Keys.explore)),
          searchInExplore: () => MaterialPage(
              child: SearchInExploreScreen(),
              key: ValueKey(Keys.searchInExplore)),
          blank: () =>
              MaterialPage(child: BlankScreen(), key: ValueKey(Keys.blank)),
          bookmark: () => MaterialPage(
              child: BookmarkScreen(), key: ValueKey(Keys.bookmark)),
          seeAllBookmark: () => MaterialPage(
              child: SeeAllBookmarkScreen(),
              key: ValueKey(Keys.seeAllBookmark)),
          inboxHome: () => MaterialPage(
              child: InboxHomeScreen(), key: ValueKey(Keys.inboxHome)),
          singleGroup: (groupDetailsModel) => MaterialPage(
              child: SingleGroupScreen(
                  groupDetailsResponseModel: groupDetailsModel),
              key: ValueKey(Keys.singleGroup)),
          groupInfo: (groupDetailsModel) => MaterialPage(
              child:
                  GroupInfoScreen(groupDetailsResponseModel: groupDetailsModel),
              key: ValueKey(Keys.groupInfo)),
          inviteFrd: (groupId, groupDetailsModel) => MaterialPage(
              child: InviteFriendsScreen(
                  groupId: groupId,
                  groupDetailsResponseModel: groupDetailsModel),
              key: ValueKey(Keys.inviteFrd)),
          createGroup: () => MaterialPage(
              child: CreateGroupScreen(), key: ValueKey(Keys.createGroup)),
          initInviteFrd: (groupUrl) => MaterialPage(
              child: InitInviteFriendsScreen(groupUrl: groupUrl),
              key: ValueKey(Keys.initInviteFrd)),
          searchGroup: () => MaterialPage(
              child: SearchGroupScreen(), key: ValueKey(Keys.searchGroup)),
          qrScanner: () => MaterialPage(
              child: QRCodeScannerScreen(), key: ValueKey(Keys.qrScanner)),
          accountAndPref: () => MaterialPage(
              child: AccountAndPrefScreen(),
              key: ValueKey(Keys.accountAndPref)),
          updateProfile: () => MaterialPage(
              child: UpdateProfileScreen(), key: ValueKey(Keys.updateProfile)),
          chatbot: () =>
              MaterialPage(child: ChatBotScreen(), key: ValueKey(Keys.chatbot)),
          detail: (contentId) => MaterialPage(
              child: DetailScreen(
                contentId: contentId,
              ),
              key: ValueKey("${Keys.detail}/${contentId}")),
          about: () => MaterialPage(
              child: AboutVistaFlicksScreen(), key: ValueKey(Keys.about)),
          contact: () => MaterialPage(
              child: ContactVistaFlicksScreen(), key: ValueKey(Keys.contact)),
          privacyPolicy: () => MaterialPage(
              child: PrivacyPolicyScreen(), key: ValueKey(Keys.privacyPolicy)),
          termsOfUse: () => MaterialPage(
              child: TermsOfUseScreen(), key: ValueKey(Keys.termsOfUse)),
          filter: (type) => MaterialPage(
              child: FilterScreen(type: type), key: ValueKey(Keys.filter)),
          commonSeeAll: (title) => MaterialPage(
              child: CommonSeeAllScreen(title: title!),
              key: ValueKey(Keys.commonSeeAll)),
          error: (key, errorType) =>
              NoAnimationPage(child: ErrorWeb(errorType: errorType)),
        ),
      )
      .toList();

  @override
  NavigationStack get currentConfiguration => stack;

  @override
  Future<void> setNewRoutePath(NavigationStack configuration) async {
    stack.items = configuration.items;
  }
}

extension _IndexedIterable<E> on Iterable<E> {
  Iterable<T> mapIndexed<T>(T Function(E e, int i) f) {
    var i = 0;
    return map((e) => f(e, i++));
  }
}
