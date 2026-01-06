import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:vista_flicks/framework/repository/chat/model/group_details_response_model.dart';

import '../utils/const/app_enums.dart';

part 'navigation_stack_item.freezed.dart';

@freezed
class NavigationStackItem with _$NavigationStackItem {
  const factory NavigationStackItem.splash() = NavigationStackItemSplashScreen;

  const factory NavigationStackItem.splashHome() =
      NavigationStackItemSplashHomeScreen;

  const factory NavigationStackItem.onboarding({required bool? isEmail}) =
      NavigationStackItemOnBoardingScreen;

  const factory NavigationStackItem.verifyOtp(
      {required bool? isEmail,
      required String? inputController}) = NavigationStackItemVerifyOtpScreen;

  const factory NavigationStackItem.registerForm({required String? inputTxt}) =
      NavigationStackItemRegisterFormScreen;

  const factory NavigationStackItem.initWatchPref() =
      NavigationStackItemInitialWatchPreferencesScreen;

  const factory NavigationStackItem.reel(
      {required String? reelId,
      required String? contentId}) = NavigationStackItemReelScreen;

  const factory NavigationStackItem.explore() =
      NavigationStackItemExploreScreen;

  const factory NavigationStackItem.searchInExplore() =
      NavigationStackItemSearchInExploreScreen;

  const factory NavigationStackItem.blank() = NavigationStackItemBlankScreen;

  const factory NavigationStackItem.bookmark() =
      NavigationStackItembookmarkScreen;

  const factory NavigationStackItem.seeAllBookmark() =
      NavigationStackItemSeeAllBookmarkScreen;

  const factory NavigationStackItem.inboxHome() =
      NavigationStackItemInboxHomeScreen;

  const factory NavigationStackItem.singleGroup(
          {required GroupDetailsResponseModel? groupDetailsResponseModel}) =
      NavigationStackItemSingleGroupScreen;

  const factory NavigationStackItem.groupInfo(
          {required GroupDetailsResponseModel? groupDetailsResponseModel}) =
      NavigationStackItemGroupInfoScreen;

  const factory NavigationStackItem.inviteFrd(
          {required String groupId,
          required GroupDetailsResponseModel? groupDetailsResponseModel}) =
      NavigationStackItemInviteFrdScreen;

  const factory NavigationStackItem.createGroup() =
      NavigationStackItemCreateGroupScreen;

  const factory NavigationStackItem.initInviteFrd({required String groupUrl}) =
      NavigationStackItemInitInviteFrdScreen;

  const factory NavigationStackItem.searchGroup() =
      NavigationStackItemSearchGroupScreen;

  const factory NavigationStackItem.qrScanner() =
      NavigationStackItemQrScannerScreen;

  const factory NavigationStackItem.accountAndPref() =
      NavigationStackItemAccountAndPrefScreen;

  const factory NavigationStackItem.updateProfile() =
      NavigationStackItemUpdateProfilefScreen;

  const factory NavigationStackItem.chatbot() =
      NavigationStackItemChatbotScreen;

  const factory NavigationStackItem.detail({required String contentId}) =
      NavigationStackItemDetailScreen;

  const factory NavigationStackItem.about() = NavigationStackItemAboutScreen;

  const factory NavigationStackItem.contact() =
      NavigationStackItemContactScreen;

  const factory NavigationStackItem.privacyPolicy() =
      NavigationStackItemPrivacyPolicyScreen;

  const factory NavigationStackItem.termsOfUse() =
      NavigationStackItemTermsOfUseScreen;

  const factory NavigationStackItem.filter({required String type}) =
      NavigationStackItemFilterScreen;

  const factory NavigationStackItem.commonSeeAll({
    required String? title,
  }) = NavigationStackItemCommonSeeAllScreen;

  const factory NavigationStackItem.error({String? key, ErrorType? errorType}) =
      NavigationStackItemError;
}
