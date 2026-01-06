import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:injectable/injectable.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';
import 'package:vista_flicks/ui/screens/main/bookmark/bookmark_screen.dart';
import 'package:vista_flicks/ui/utils/widgets/common_dialogs.dart';

import '../../../gen/assets.gen.dart';
import '../../../ui/routing/navigation_stack_item.dart';
import '../../../ui/routing/stack.dart';
import '../../../ui/screens/main/account_and_pref/account_and_pref_screen.dart';
import '../../../ui/screens/main/chatbot/chat_bot_screen.dart';
import '../../../ui/screens/main/explore/explore_screen.dart';
import '../../../ui/screens/main/inbox/inbox_home/inbox_home_screen.dart';
import '../../../ui/screens/main/reel/reel_screen.dart';
import '../../../ui/utils/theme/theme.dart';
import '../../dependency_injection/inject.dart';
import '../../utils/local_storage/session.dart';

final blankController =
    ChangeNotifierProvider((ref) => getIt<BlankController>());

@injectable
class BlankController extends ChangeNotifier {
  int _currentIndex = 0;
  final PersistentTabController _tabController = PersistentTabController();
  bool isLoading = false;

  final List<Widget> pages = [
    ReelScreen(reelId: "", contentId: ""),
    const ExploreScreen(),
    InboxHomeScreen(),
    const BookmarkScreen(),
    const AccountAndPrefScreen(),
    ChatBotScreen(),
  ];

  final List<String> _iconAssets = [
    Assets.icons.tablerIconHome,
    Assets.icons.tablerIconSearch,
    Assets.icons.tablerIconMessage2,
    Assets.icons.tablerIconBookmark,
    Assets.icons.tablerIconUserCircle,
    Assets.lottie.animation1737368859751,
  ];

  int get currentIndex => _currentIndex;

  PersistentTabController get tabController => _tabController;

  List<String> get iconAssets => _iconAssets;

  void setIndex(int index, {BuildContext? context, WidgetRef? ref}) {
    if (Session.userType.toLowerCase() != "guest") {
      _currentIndex = index;
      notifyListeners(); // Notify Riverpod listeners
    } else {
      if (index != 0) {
        showLoginDialog(context!, "For more excusive content, Please Sign in",
            () {
          ref
              ?.read(navigationStackController)
              .pushAndRemoveAll(NavigationStackItem.splashHome());
        });
      }
    }
  }

  void disposeController({bool isNotify = false}) {
    isLoading = false;

    if (isNotify) {
      notifyListeners();
    }
  }
}
