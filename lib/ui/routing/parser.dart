import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:injectable/injectable.dart';
import 'package:vista_flicks/ui/routing/route_manager.dart';
import 'package:vista_flicks/ui/routing/stack.dart';
import 'package:vista_flicks/ui/utils/const/app_constants.dart';

import '../../framework/utils/local_storage/session.dart';
import '../utils/const/app_enums.dart';
import 'navigation_stack_item.dart';
import 'navigation_stack_keys.dart';

@injectable
class MainRouterInformationParser
    extends RouteInformationParser<NavigationStack> {
  WidgetRef ref;
  BuildContext context;

  MainRouterInformationParser(
      @factoryParam this.ref, @factoryParam this.context);

  ///Parse Screen from URL
  @override
  Future<NavigationStack> parseRouteInformation(
      RouteInformation routeInformation) async {
    List<String> queryParam = [];
    List<String> tempUrlList = routeInformation.uri.toString().split('/');
    tempUrlList.removeAt(0);
    List<String> tempPathList = [];
    for (var element in tempUrlList) {
      tempPathList.add(element.split('?').first);
      if (element.split('?').length > 1) {
        queryParam.add(element.split('?').last);
      }
    }
    String mainUrl =
        '/${tempPathList.join('/')}${queryParam.isNotEmpty ? '?${queryParam.join('&')}' : ''}';
    showLog('........URL......$mainUrl');
    final Uri uri = Uri.parse(mainUrl);
    final queryParams = uri.queryParameters;
    showLog('........queryParams....$queryParams');

    final items = <NavigationStackItem>[];
    showLog('Path Segments-> ${uri.pathSegments}');

    ///Will remove all the empty path from segments
    RouteManager.route.removeEmptyPath(uri.pathSegments);

    ///To add error page at the end and return no widget if error is found
    bool hasError = false;

    ///To add error page at the end and return no widget if error is found
    bool isAuthenticated = true;

    ///Will check validation for routes
    await RouteManager.route.checkPathValidation().then(
      (value) async {
        if (Session.userAccessToken != '') {}
        showLog('${uri.pathSegments}');
        for (var i = 0; i < uri.pathSegments.length; i = i + 1) {
          ///To add error page at the end and return no widget if error is found

          hasError = !value.isRouteValid;
          isAuthenticated = value.isAuthenticated;
          if (kDebugMode) {
            showLog('$hasError');
          }
          if (kDebugMode) {
            showLog('$isAuthenticated');
          }
          final key = uri.pathSegments[i];
          switch (key) {
            case Keys.splash:
              items.add(const NavigationStackItem.splash());
              break;
            case Keys.splashHome:
              items.add(const NavigationStackItem.splash());
              break;

            case Keys.onboarding:
              items.add(const NavigationStackItem.onboarding(isEmail: false));
              break;

            case Keys.verifyOtp:
              items.add(const NavigationStackItem.verifyOtp(
                  isEmail: false, inputController: ""));
              break;
            case Keys.registerForm:
              items.add(const NavigationStackItem.registerForm(inputTxt: ""));
              break;
            case Keys.initWatchPref:
              items.add(const NavigationStackItem.initWatchPref());
              break;
            case Keys.reel:
              items.add(
                  const NavigationStackItem.reel(reelId: '', contentId: ''));
              break;
            case Keys.explore:
              items.add(const NavigationStackItem.explore());
              break;
            case Keys.searchInExplore:
              items.add(const NavigationStackItem.searchInExplore());
              break;

            case Keys.blank:
              items.add(NavigationStackItem.blank());
              break;
            case Keys.bookmark:
              items.add(NavigationStackItem.bookmark());
              break;
            case Keys.seeAllBookmark:
              items.add(NavigationStackItem.seeAllBookmark());
              break;
            case Keys.inboxHome:
              items.add(NavigationStackItem.inboxHome());
              break;
            case Keys.singleGroup:
              items.add(NavigationStackItem.singleGroup(
                  groupDetailsResponseModel: null));
              break;
            case Keys.groupInfo:
              items.add(NavigationStackItem.groupInfo(
                  groupDetailsResponseModel: null));
              break;
            case Keys.inviteFrd:
              items.add(NavigationStackItem.inviteFrd(
                  groupId: '', groupDetailsResponseModel: null));
              break;

            case Keys.createGroup:
              items.add(NavigationStackItem.createGroup());
              break;
            case Keys.initInviteFrd:
              items.add(NavigationStackItem.initInviteFrd(groupUrl: ''));
              break;
            case Keys.searchGroup:
              items.add(NavigationStackItem.searchGroup());
              break;
            case Keys.qrScanner:
              items.add(NavigationStackItem.qrScanner());
              break;

            case Keys.accountAndPref:
              items.add(NavigationStackItem.accountAndPref());
              break;
            case Keys.updateProfile:
              items.add(NavigationStackItem.updateProfile());
              break;
            case Keys.chatbot:
              items.add(NavigationStackItem.chatbot());
              break;
            case Keys.detail:
              items.add(NavigationStackItem.detail(contentId: ""));
              break;
            case Keys.about:
              items.add(NavigationStackItem.about());
              break;
            case Keys.contact:
              items.add(NavigationStackItem.contact());
              break;
            case Keys.privacyPolicy:
              items.add(NavigationStackItem.privacyPolicy());
              break;
            case Keys.termsOfUse:
              items.add(NavigationStackItem.termsOfUse());
              break;
            case Keys.filter:
              items.add(NavigationStackItem.filter(type: ''));
              break;
            case Keys.commonSeeAll:
              items.add(NavigationStackItem.commonSeeAll(title: ''));
              break;

            default:
              items.add(
                NavigationStackItem.error(
                  key: key,
                  errorType: hasError
                      ? ErrorType.error404
                      : (!isAuthenticated
                          ? ErrorType.error403
                          : ErrorType.error404),
                ),
              );
          } // for
        }
      },
    );

    ///If have error then add 404 without passing any key so the path will not be shown in url
    if (hasError) {
      items.add(const NavigationStackItem.error(errorType: ErrorType.error404));
    } else if (!(isAuthenticated)) {
      items.add(const NavigationStackItem.error(errorType: ErrorType.error403));
    }

    if (items.isEmpty) {
      const fallback = NavigationStackItem.splash();
      if (items.isNotEmpty && items.first is NavigationStackItemSplashScreen) {
        items[0] = fallback;
      } else {
        items.insert(0, fallback);
      }
    }
    return NavigationStack(items);
  }

  ///THIS IS IMPORTANT: Here we restore the web history
  @override
  RouteInformation? restoreRouteInformation(NavigationStack configuration) {
    final location = configuration.items.fold<String>(
      '',
      (previousValue, element) {
        return previousValue +
            element.when(
              splash: () => '/${Keys.splash}',
              error: (key, errorType) {
                return key == null ? '' : '/$key';
              },
              splashHome: () => '/${Keys.splashHome}',
              onboarding: (isEmail) => '/${Keys.onboarding}',
              verifyOtp: (isEmail, inputController) => '/${Keys.verifyOtp}',
              registerForm: (inputTxt) => '/${Keys.registerForm}',
              initWatchPref: () => '/${Keys.initWatchPref}',
              reel: (reelId, contentId) => '/${Keys.reel}',
              explore: () => '/${Keys.explore}',
              searchInExplore: () => '/${Keys.searchInExplore}',
              blank: () => '/${Keys.blank}',
              bookmark: () => '/${Keys.bookmark}',
              seeAllBookmark: () => '/${Keys.seeAllBookmark}',
              inboxHome: () => '/${Keys.inboxHome}',
              singleGroup: (groupDetailsModel) => '/${Keys.singleGroup}',
              groupInfo: (groupDetailsResponseModel) => '/${Keys.groupInfo}',
              inviteFrd: (groupId, groupDetailsResponseModel) =>
                  '/${Keys.inviteFrd}',
              createGroup: () => '/${Keys.createGroup}',
              initInviteFrd: (groupUrl) => '/${Keys.initInviteFrd}',
              searchGroup: () => '/${Keys.searchGroup}',
              qrScanner: () => '/${Keys.qrScanner}',
              accountAndPref: () => '/${Keys.accountAndPref}',
              updateProfile: () => '/${Keys.updateProfile}',
              chatbot: () => '/${Keys.chatbot}',
              detail: (contentId) => '/${Keys.detail}',
              about: () => '/${Keys.about}',
              contact: () => '/${Keys.contact}',
              privacyPolicy: () => '/${Keys.privacyPolicy}',
              termsOfUse: () => '/${Keys.termsOfUse}',
              filter: (type) => '/${Keys.filter}',
              commonSeeAll: (title) => '/${Keys.commonSeeAll}',
            );
      },
    );
    List<String> queryParam = [];
    List<String> tempUrlList = location.toString().split('/');
    tempUrlList.removeAt(0);
    List<String> tempPathList = [];
    for (var element in tempUrlList) {
      tempPathList.add(element.split('?').first);
      if (element.split('?').length > 1) {
        queryParam.add(element.split('?').last);
      }
    }
    String mainUrl =
        '/${tempPathList.join('/')}${queryParam.isNotEmpty ? '?${queryParam.join('&')}' : ''}';
    Uri routeUrl = Uri.parse(mainUrl);
    return RouteInformation(uri: routeUrl);
  }
}
