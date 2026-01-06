import 'dart:convert';
import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:injectable/injectable.dart';
import 'package:vista_flicks/framework/provider/network/network.dart';
import 'package:vista_flicks/framework/repository/common_response/common_response_model.dart';
import 'package:vista_flicks/framework/repository/preferences/contract/preference_repository.dart';
import 'package:vista_flicks/framework/repository/preferences/model/get_preferences_response_model.dart';
import 'package:vista_flicks/framework/repository/preferences/model/update_preference_request_model.dart';
import 'package:vista_flicks/framework/utils/ui_state.dart';
import 'package:vista_flicks/ui/utils/const/app_constants.dart';
import 'package:vista_flicks/ui/utils/const/app_enums.dart';
import 'package:vista_flicks/ui/utils/widgets/common_dialogs.dart';

import '../../../../../gen/assets.gen.dart';
import '../../../../dependency_injection/inject.dart';
import '../../../../repository/auth/on_boarding/model/verify_otp_response_model.dart';
import '../../../../utils/local_storage/session.dart';
import '../../reel/reels_controller.dart';

final filterController =
    ChangeNotifierProvider((ref) => getIt<FilterController>());

@injectable
class FilterController extends ChangeNotifier {
  PreferenceRepository preferenceRepository;

  FilterController(this.preferenceRepository);

  List<FilterType> filterCategories = [
    FilterType.genre,
    FilterType.language,
    FilterType.subTitleLanguage,
    FilterType.contentType,
    FilterType.ottPlatforms,
    FilterType.region,
    FilterType.imdbRating,
    FilterType.ageRating,
  ];

  // List<String> ratingOptions = [];
  // List<String> ageRatingOptions = [];
  FilterType selectedCategory = FilterType.genre;
  Set<String> selectedChips = {};
  bool isLoading = false;

  void updateSelectedCategory(
      String category, BuildContext context, WidgetRef ref) {
    // selectedCategory = category;
    preferencesList = [];

    FilterType type = FilterType.genre;

    switch (category) {
      case 'Genre':
        preferencesList = genreList;
        type = FilterType.genre;
        break;
      case 'Language':
        preferencesList = languageList;
        type = FilterType.language;
        break;
      case 'Subtitles':
        preferencesList = subTitleLanguageList;
        type = FilterType.subTitleLanguage;
        break;
      case 'Content Type':
        preferencesList = contentTypeList;
        type = FilterType.contentType;
        break;
      case 'OTT Platforms':
        preferencesList = ottPlatformsList;
        type = FilterType.ottPlatforms;
        break;
      case 'Region':
        preferencesList = regionList;
        type = FilterType.region;
        break;
      case 'Ratings':
        preferencesList = imdbRatingList;
        type = FilterType.imdbRating;
        break;
      case 'Age Rating':
        preferencesList = ageRatingList;
        type = FilterType.ageRating;
        break;
    }
    selectedCategory = type;

    notifyListeners();

    // Only call API if the list is empty (first-time load)
    if (preferencesList.isEmpty) {
      getPreferencesAPI(context, ref: ref, type: type.name);
    }
  }

  // void updateSelectedCategory(String category) {
  //   showLog(
  //       'categorycategorycategorycategorycategory $category  ${genreList.length}');
  //
  //   switch (category) {
  //     case 'Genre':
  //       preferencesList = genreList;
  //       showLog(
  //           'updateSelectedCategory preferencesList preferencesList ${preferencesList.length}');
  //       break;
  //     case 'Language':
  //       preferencesList = languageList;
  //       break;
  //     case 'Subtitles':
  //       preferencesList = subTitleLanguageList;
  //       break;
  //     case 'Content Type':
  //       preferencesList = contentTypeList;
  //       break;
  //     case 'OTT Platforms':
  //       preferencesList = ottPlatformsList;
  //       break;
  //     case 'Region':
  //       preferencesList = regionList;
  //       break;
  //     case 'Ratings':
  //       preferencesList = imdbRatingList;
  //       break;
  //     case 'Age Rating':
  //       preferencesList = ageRatingList;
  //       break;
  //   }
  //
  //   selectedCategory = category;
  //   notifyListeners();
  // }

  updateIsPreferredInMainListWidget(int index) {
    switch (selectedCategory) {
      case FilterType.genre:
        genreList = preferencesList;
        notifyListeners();
        break;
      case FilterType.language:
        languageList = preferencesList;
        break;
      case FilterType.subTitleLanguage:
        subTitleLanguageList = preferencesList;
        break;
      case FilterType.contentType:
        contentTypeList = preferencesList;
        break;
      case FilterType.ottPlatforms:
        ottPlatformsList = preferencesList;
        break;
      case FilterType.region:
        regionList = preferencesList;
        break;
      case FilterType.imdbRating:
        imdbRatingList = preferencesList;
        break;
      case FilterType.ageRating:
        ageRatingList = preferencesList;
        break;
    }
    notifyListeners();
  }

  // bool isFilterUpdated() {
  //   return genreList.any((e) => (e.isPreferred ?? false)) ||
  //       languageList.any((e) => (e.isPreferred ?? false)) ||
  //       subTitleLanguageList.any((e) => (e.isPreferred ?? false)) ||
  //       contentTypeList.any((e) => (e.isPreferred ?? false)) ||
  //       ottPlatformsList.any((e) => (e.isPreferred ?? false)) ||
  //       regionList.any((e) => (e.isPreferred ?? false)) ||
  //       imdbRatingList.any((e) => (e.isPreferred ?? false)) ||
  //       ageRatingList.any((e) => (e.isPreferred ?? false));
  // }

  bool isFilterUpdated() {
    return genreList.any((e) => (e.isPreferred ?? false)) ||
        languageList.any((e) => (e.isPreferred ?? false)) ||
        subTitleLanguageList.any((e) => (e.isPreferred ?? false)) ||
        contentTypeList.any((e) => (e.isPreferred ?? false)) ||
        ottPlatformsList.any((e) => (e.isPreferred ?? false)) ||
        regionList.any((e) => (e.isPreferred ?? false)) ||
        imdbRatingList.any((e) => (e.isPreferred ?? false)) ||
        ageRatingList.any((e) => (e.isPreferred ?? false));
  }

  void updateWidget() {
    notifyListeners();
  }

  // void toggleChipSelection(int index) {
  //   preferencesList[index].isPreferred =
  //       !(preferencesList[index].isPreferred ?? false);
  //   updateIsPreferredInMainListWidget(index);
  //   notifyListeners();
  // }

  //
  void toggleChipSelection(String option) {
    if (selectedChips.contains(option)) {
      selectedChips.remove(option);
    } else {
      selectedChips.add(option);
    }
    notifyListeners();
  }

  void clearAllFilters() {
    switch (selectedCategory) {
      case FilterType.genre:
        genreList = genreList.map((e) => e..isPreferred = false).toList();
        break;
      case FilterType.language:
        languageList = languageList.map((e) => e..isPreferred = false).toList();
        break;
      case FilterType.subTitleLanguage:
        subTitleLanguageList =
            subTitleLanguageList.map((e) => e..isPreferred = false).toList();
        break;
      case FilterType.contentType:
        contentTypeList =
            contentTypeList.map((e) => e..isPreferred = false).toList();
        break;
      case FilterType.ottPlatforms:
        ottPlatformsList =
            ottPlatformsList.map((e) => e..isPreferred = false).toList();
        break;
      case FilterType.region:
        regionList = regionList.map((e) => e..isPreferred = false).toList();
        break;
      case FilterType.imdbRating:
        imdbRatingList =
            imdbRatingList.map((e) => e..isPreferred = false).toList();
        break;
      case FilterType.ageRating:
        ageRatingList =
            ageRatingList.map((e) => e..isPreferred = false).toList();
        break;
    }

    notifyListeners();
  }

  // void clearAllFilters() {
  //   genreList.where((element) => element.isPreferred = false).toList();
  //   languageList.where((element) => element.isPreferred = false).toList();
  //   subTitleLanguageList
  //       .where((element) => element.isPreferred = false)
  //       .toList();
  //   contentTypeList.where((element) => element.isPreferred = false).toList();
  //   ottPlatformsList.where((element) => element.isPreferred = false).toList();
  //   regionList.where((element) => element.isPreferred = false).toList();
  //   imdbRatingList.where((element) => element.isPreferred = false).toList();
  //   ageRatingList.where((element) => element.isPreferred = false).toList();
  //   notifyListeners();
  // }

  void disposeController({bool isNotify = false}) {
    isLoading = false;
    getPreferenceState.isLoading = false;
    getPreferenceState.success = null;

    if (isNotify) {
      notifyListeners();
    }
  }

  void clearAllList() {
    genreList.clear();
    languageList.clear();
    subTitleLanguageList.clear();
    contentTypeList.clear();
    ottPlatformsList.clear();
    regionList.clear();
    imdbRatingList.clear();
    ageRatingList.clear();
    notifyListeners();
  }

  ///----------------------------------- API Integration -----------------------------------///

  UIState<GetPreferencesResponseModel> getPreferenceState =
      UIState<GetPreferencesResponseModel>();

  List<PreferenceResult> genreList = [];
  List<PreferenceResult> languageList = [];
  List<PreferenceResult> subTitleLanguageList = [];
  List<PreferenceResult> contentTypeList = [];
  List<PreferenceResult> ottPlatformsList = [];
  List<PreferenceResult> regionList = [];
  List<PreferenceResult> imdbRatingList = [];
  List<PreferenceResult> ageRatingList = [];
  List<PreferenceResult> preferencesList = [];

  /// For Pagination
  int pageNo = 0;
  bool isHasMorePage = false;

  Future<void> getAllPreferences(BuildContext context,
      {required WidgetRef ref}) async {
    final types = [
      FilterType.genre,
      FilterType.language,
      FilterType.subTitleLanguage,
      FilterType.contentType,
      FilterType.ottPlatforms,
      FilterType.region,
      FilterType.imdbRating,
      FilterType.ageRating,
    ];

    isLoading = true;
    notifyListeners();

    for (final type in types) {
      await getPreferencesAPI(context, ref: ref, type: type.name);
    }

    isLoading = false;
    notifyListeners();
  }

  List<String> imageList = [
    Assets.images.action.path,
    Assets.images.adventure.path,
    Assets.images.animation.path,
    Assets.images.biography.path,
    Assets.images.comedy.path,
    Assets.images.crime.path,
    Assets.images.drama.path,
    Assets.images.family.path,
    Assets.images.history.path,
    Assets.images.horror.path,
    Assets.images.music.path,
    Assets.images.mystery.path,
    Assets.images.reality.path,
    Assets.images.warPolitics.path,
    Assets.images.actionAdventure.path,
    Assets.images.scienceFiction.path,
    Assets.images.sciFiFantasy.path,
    Assets.images.romance.path,
    Assets.images.musical.path,
    Assets.images.fantasy.path,
    Assets.images.documentary.path,
    Assets.images.sciFi.path,
    // Assets.images.sciFi2.path,
    Assets.images.sport.path,
    Assets.images.thriller.path,
    Assets.images.war.path,
  ];
  Map<String, String> genreImageMap = {};
  final Map<String, String> languageAbMap = {
    "hebrew": "אב",
    "indonesian": "AB",
    "filipino": "AB",
    "polish": "AB",
    "swedish": "AB",
    "dutch": "AB",
    "persian": "اب",
    "turkish": "AB",
    "chinese": "ㄅㄆ",
    "korean": "ㄱㄴ",
    "japanese": "あい",
    "russian": "АБ",
    "portuguese": "AB",
    "italian": "AB",
    "german": "AB",
    "french": "AB",
    "spanish": "AB",
    "arabic": "اب",
    "haryanvi": "अआ",
    "rajasthani": "अआ",
    "odia": "ଅଆ",
    "bhojpuri": "अआ",
    "gujarati": "અઆ",
    "punjabi": "ਅਆ",
    "bengali": "অআ",
    "marathi": "अआ",
    "malayalam": "അആ",
    "kannada": "ಅಆ",
    "telugu": "అఆ",
    "tamil": "அஆ",
    "english": "AB",
    "hindi": "अआ"
  };

  /// Get Preferences API
  Future getPreferencesAPI(BuildContext context,
      {required WidgetRef ref, required String type}) async {
    getPreferenceState.isLoading = true;
    getPreferenceState.success = null;

    notifyListeners();

    ApiResult apiResult =
        await preferenceRepository.getPreferencesAPI(type: type);

    apiResult.when(success: (data) async {
      getPreferenceState.success = data;
      getPreferenceState.isLoading = false;

      if (getPreferenceState.success?.success ?? false) {
        if (type == FilterType.genre.name) {
          genreList.clear();
          genreList.addAll(getPreferenceState.success?.data ?? []);

          final genreNames = genreList
              .map((genre) => genre.name?.toLowerCase() ?? "")
              .toSet(); // for faster lookup

          for (final path in imageList) {
            final fileName = path.split('/').last; // e.g. "action.png"
            final genreNameFromFile =
                fileName.split('.').first.toLowerCase(); // "action"

            if (genreNames.contains(genreNameFromFile)) {
              genreImageMap[genreNameFromFile] = path;
            }
          }

          // genreImageMap = {
          //   for (var genre in genreImageList)
          //     genre.genreName.toLowerCase(): genre.imagePath
          // };
          print("genreImageMap======>${genreImageMap.toString()}");
          // genreList.where((pref) {
          //   final name = pref.name?.toLowerCase() ?? '';
          //   print(
          //       "validPreferences======>${genreImageMap.containsValue(name)}");
          //   return genreImageMap.containsValue(name);
          // }).toList();

          showLog(
              'genreList length preferences ${genreList.length} ${getPreferenceState.success?.data?.length}');
        } else if (type == FilterType.language.name) {
          languageList.clear();
          languageList.addAll(getPreferenceState.success?.data ?? []);
        } else if (type == FilterType.subTitleLanguage.name) {
          subTitleLanguageList.clear();
          subTitleLanguageList.addAll(getPreferenceState.success?.data ?? []);
        } else if (type == FilterType.contentType.name) {
          contentTypeList.clear();
          contentTypeList.addAll(getPreferenceState.success?.data ?? []);
        } else if (type == FilterType.ottPlatforms.name) {
          ottPlatformsList.clear();
          getPreferenceState.success?.data
              ?.removeWhere((element) => element.icon == null);
          ottPlatformsList.addAll(getPreferenceState.success?.data ?? []);
        } else if (type == FilterType.region.name) {
          regionList.clear();
          regionList.addAll(getPreferenceState.success?.data ?? []);
        } else if (type == FilterType.imdbRating.name) {
          imdbRatingList.clear();
          imdbRatingList.addAll(getPreferenceState.success?.data ?? []);
        } else if (type == FilterType.ageRating.name) {
          ageRatingList.clear();
          ageRatingList.addAll(getPreferenceState.success?.data ?? []);
        }
      }
    }, failure: (NetworkExceptions error) {
      getPreferenceState.isLoading = false;
      notifyListeners();
      String errorMsg = NetworkExceptions.getErrorMessage(error);

      showMessageDialog(context, errorMsg, null);
    });
    getPreferenceState.isLoading = false;

    notifyListeners();
  }

  UIState<CommonResponseModel> updatePreferenceState =
      UIState<CommonResponseModel>();

  /// Update Preferences API
  Future updatePreferencesAPI(
    BuildContext context, {
    required WidgetRef ref,
    bool isFromFilter = true,
    List<PreferenceResult>? contentType,
    List<PreferenceResult>? genre,
    List<PreferenceResult>? subtitleLanguage,
    List<PreferenceResult>? language,
    List<PreferenceResult>? ott,
  }) async {
    updatePreferenceState.isLoading = true;
    updatePreferenceState.success = null;
    notifyListeners();

    UpdatePreferencesRequestModel updatePreferencesRequestModel =
        UpdatePreferencesRequestModel(
      genre: (genre ?? genreList)
          .where((e) => e.isPreferred ?? false)
          .map((e) => e.id!)
          .toList(),
      language: (language ?? languageList)
          .where((e) => e.isPreferred ?? false)
          .map((e) => e.id!)
          .toList(),
      subTitleLanguage: (subtitleLanguage ?? subTitleLanguageList)
          .where((e) => e.isPreferred ?? false)
          .map((e) => e.id!)
          .toList(),
      imdbRating: imdbRatingList
          .where((e) => e.isPreferred ?? false)
          .map((e) => e.id!)
          .toList(),
      region: regionList
          .where((e) => e.isPreferred ?? false)
          .map((e) => e.id!)
          .toList(),
      ageRating: ageRatingList
          .where((e) => e.isPreferred ?? false)
          .map((e) => e.id!)
          .toList(),
      ottPlatforms: (ott ?? ottPlatformsList)
          .where((e) => e.isPreferred ?? false)
          .map((e) => e.id!)
          .toList(),
      contentType: (contentType ?? contentTypeList)
          .where((e) => e.isPreferred ?? false)
          .map((e) => e.id!)
          .toList(),
    );

    // print(
    //     'updatePreferencesRequestModel.ottPlatforms?.isEmpty ${updatePreferencesRequestModel.ottPlatforms?.isEmpty}');

    if (updatePreferencesRequestModel.genre?.isEmpty == true ||
        updatePreferencesRequestModel.contentType?.isEmpty == true ||
        updatePreferencesRequestModel.ottPlatforms?.isEmpty == true) {
      print("object==================>");
      showMessageDialog(
          context, "Please select Genre, OttPlatforms & Content Type ", null);
      updatePreferenceState.isLoading = false;
      return;
    }
    String request =
        updatePreferencesRequestModelToJson(updatePreferencesRequestModel);
    ApiResult apiResult =
        await preferenceRepository.updatePreferencesAPI(request: request);

    apiResult.when(success: (data) async {
      final reelScreenWatch = ref.watch(reelsController);
      updatePreferenceState.success = data;
      log("verifyOtpResponseModel data => ${jsonEncode(data)}");
      updatePreferenceState.isLoading = false;
      if (isFromFilter) {
        if (reelScreenWatch.pageController.hasClients) {
          reelScreenWatch.pageController.jumpTo(0);
        }
      }
      Navigator.pop(context);
      VerifyOtpResponseModel verifyOtpResponseModel = VerifyOtpResponseModel(
          data: VerifyOtpData(
              user: VerifyOTPUser(
        ageRating: updatePreferencesRequestModel.ageRating,
        genre: updatePreferencesRequestModel.genre,
        language: updatePreferencesRequestModel.language,
        ottPlatforms: updatePreferencesRequestModel.ottPlatforms,
        imdbRating: updatePreferencesRequestModel.imdbRating,
        region: updatePreferencesRequestModel.region,
        contentType: updatePreferencesRequestModel.contentType,
        subTitleLanguage: updatePreferencesRequestModel.subTitleLanguage,
      )));
      Session.userData = jsonEncode(verifyOtpResponseModel.data?.user);
      log("verifyOtpResponseModel ${Session.userData}");
    }, failure: (NetworkExceptions error) {
      updatePreferenceState.isLoading = false;
      notifyListeners();
      String errorMsg = NetworkExceptions.getErrorMessage(error);

      showMessageDialog(context, errorMsg, null);
    });
    updatePreferenceState.isLoading = false;

    notifyListeners();
  }
}

class GenreImageModel {
  final String genreName;
  final String imagePath;

  GenreImageModel({required this.genreName, required this.imagePath});
}
