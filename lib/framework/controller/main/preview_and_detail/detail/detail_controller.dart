import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:injectable/injectable.dart';
import 'package:vista_flicks/framework/controller/main/preview_and_detail/detail/detail_repository.dart';
import 'package:vista_flicks/framework/controller/main/preview_and_detail/model/get_about_content_model.dart';
import 'package:vista_flicks/framework/controller/main/preview_and_detail/model/get_review_model.dart';
import 'package:vista_flicks/framework/controller/main/preview_and_detail/model/get_similar_model.dart';
import 'package:vista_flicks/framework/provider/network/network.dart';
import 'package:vista_flicks/framework/utils/ui_state.dart';
import 'package:vista_flicks/ui/utils/widgets/common_dialogs.dart';

import '../../../../../gen/assets.gen.dart';
import '../../../../dependency_injection/inject.dart';
import '../../../../repository/chat/model/group_details_response_model.dart';

final detailController =
    ChangeNotifierProvider((ref) => getIt<DetailController>());

@injectable
class DetailController extends ChangeNotifier {
  DetailRepository detailRepository;

  DetailController(this.detailRepository);

  bool isLoading = false;

  // Set<int> selectedGroups = {};
  //
  // void toggleSelection(int index) {
  //   if (selectedGroups.contains(index)) {
  //     selectedGroups.remove(index);
  //   } else {
  //     selectedGroups.add(index);
  //   }
  //   notifyListeners();
  // }
  void updateWidget() {
    notifyListeners();
  }

  List<GroupDetailsResponseModel> groupList = [];

  List<GroupDetailsResponseModel> filteredGroupList = [];

  void onSearch(String value) {
    // if (value.isEmpty) {
    //   filteredGroupList = groupList;
    // } else {
    filteredGroupList = groupList
        .where((element) =>
            element.groupName?.toLowerCase().contains(value.toLowerCase()) ==
            true)
        .toList();
    // }
    notifyListeners();
  }

  final Set<int> _selectedGroups = {};

  Set<int> get selectedGroups => _selectedGroups;

  void toggleSelection(int index) {
    if (_selectedGroups.contains(index)) {
      _selectedGroups.remove(index);
    } else {
      _selectedGroups.add(index);
    }
    notifyListeners();
  }

  void clearSelection() {
    selectedGroups.clear();
    notifyListeners();
  }

  var castImg = [
    Assets.images.cast1,
    Assets.images.cast2,
    Assets.images.cast3,
    Assets.images.cast4,
    Assets.images.cast5,
  ];
  var teamImg = [
    Assets.images.team1,
    Assets.images.team2,
    Assets.images.team3,
    Assets.images.team4,
  ];
  var reviewImg = [
    Assets.images.review1,
    Assets.images.review2,
    Assets.images.review3,
    Assets.images.review4,
    Assets.images.review5,
    Assets.images.review6,
  ];
  var similarImg = [
    Assets.images.m01,
    Assets.images.m02,
    Assets.images.m03,
    Assets.images.m04,
    Assets.images.m05,
    Assets.images.m06,
    Assets.images.m07,
    Assets.images.m08,
    Assets.images.m09,
    Assets.images.m10,
  ];

  void disposeController({bool isNotify = false}) {
    isLoading = false;
    similarListState.isLoading = false;
    similarListState.success = null;
    getAboutContentModelState.isLoading = false;
    getAboutContentModelState.success = null;
    if (isNotify) {
      notifyListeners();
    }
  }

  ///----------------------------------- API Integration -----------------------------------///

  UIState<GetSimilarModel> similarListState = UIState<GetSimilarModel>();

  Future getSimilarAPI(BuildContext context,
      {required String contentId}) async {
    similarListState.isLoading = true;
    similarListState.success = null;
    notifyListeners();
    ApiResult apiResult = await detailRepository.getSimilarAPI(contentId);

    apiResult.when(success: (data) async {
      similarListState.isLoading = false;
      similarListState.success = data;
    }, failure: (NetworkExceptions error) {
      similarListState.isLoading = false;
      String errorMsg = NetworkExceptions.getErrorMessage(error);
      showMessageDialog(context, errorMsg, null);
    });
    similarListState.isLoading = false;
    notifyListeners();
  }

  UIState<GetAboutContentModel> getAboutContentModelState =
      UIState<GetAboutContentModel>();

  Future getAboutContectAPI(BuildContext context,
      {required String contentId}) async {
    notifyListeners();
    getAboutContentModelState.isLoading = true;
    getAboutContentModelState.success = null;
    notifyListeners();
    ApiResult apiResult = await detailRepository.getAboutContentAPI(contentId);

    apiResult.when(success: (data) async {
      getAboutContentModelState.isLoading = false;
      getAboutContentModelState.success = data;
    }, failure: (NetworkExceptions error) {
      getAboutContentModelState.isLoading = false;
      String errorMsg = NetworkExceptions.getErrorMessage(error);
      showMessageDialog(context, errorMsg, null);
    });
    getAboutContentModelState.isLoading = false;
    notifyListeners();
  }

  UIState<GetReviewModel> getReviewModelState = UIState<GetReviewModel>();

  Future getReviewAPI(BuildContext context, {required String contentId}) async {
    getReviewModelState.isLoading = true;
    getReviewModelState.success = null;
    notifyListeners();
    ApiResult apiResult = await detailRepository.getReviewAPI(contentId);

    apiResult.when(success: (data) async {
      getReviewModelState.isLoading = false;
      getReviewModelState.success = data;
    }, failure: (NetworkExceptions error) {
      getReviewModelState.isLoading = false;
      String errorMsg = NetworkExceptions.getErrorMessage(error);
      showMessageDialog(context, errorMsg, null);
    });
    getReviewModelState.isLoading = false;
    notifyListeners();
  }

// Future getSimilarAPI(contentId) async {
//   try {
//     // String jsonString = json.encode(map);
//     Response? response =
//         await apiClient.getRequest(ApiEndPoints.getSimilar(contentId));
//     GetSimilarModel responseModel =
//         getSimilarModelFromJson(response.toString());
//     if (response?.statusCode == ApiEndPoints.apiStatus_200) {
//       return ApiResult.success(data: responseModel);
//     } else {
//       return ApiResult.failure(
//           error:
//               NetworkExceptions.defaultError(response?.statusMessage ?? ''));
//     }
//   } catch (err) {
//     return ApiResult.failure(error: NetworkExceptions.getDioException(err));
//   }
// }
}
