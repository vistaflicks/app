import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:injectable/injectable.dart';
import 'package:vista_flicks/framework/dependency_injection/inject.dart';
import 'package:vista_flicks/framework/repository/chat/model/group_details_response_model.dart';
import 'package:vista_flicks/framework/utils/local_storage/session.dart';
import 'package:vista_flicks/ui/utils/helper/group_chat_manager/group_chat_manager.dart';

final searchController =
    ChangeNotifierProvider((ref) => getIt<SearchController>());

@injectable
class SearchController extends ChangeNotifier {
  List<GroupDetailsResponseModel> groupList = [];

  /// Dispose Controller
  void disposeController({bool isNotify = false}) {
    groupList.clear();
    if (isNotify) {
      notifyListeners();
    }
  }

  Future<void> getSearchGroupsList({required String search}) async {
    groupList.clear();
    groupList = await GroupChatManager.instance
        .searchGroups(Session.userId, search)
        .first;
    notifyListeners();
  }
}
