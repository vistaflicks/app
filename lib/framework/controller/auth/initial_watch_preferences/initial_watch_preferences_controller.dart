import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:injectable/injectable.dart';
import 'package:vista_flicks/framework/provider/network/network.dart';
import 'package:vista_flicks/framework/repository/preferences/contract/preference_repository.dart';
import 'package:vista_flicks/framework/repository/preferences/model/get_preferences_response_model.dart';

import '../../../../ui/utils/theme/theme.dart';
import '../../../dependency_injection/inject.dart';

final initialWatchPreferencesController =
    ChangeNotifierProvider((ref) => getIt<InitialWatchPreferencesController>());

@injectable
class InitialWatchPreferencesController extends ChangeNotifier {
  PreferenceRepository preferenceRepository;

  InitialWatchPreferencesController(this.preferenceRepository);

  bool showPlatforms = false;
  bool showGenresGrid = true;
  bool isLoading = false;
  int currentStep = 0;
  final ScrollController _scrollController = ScrollController();

  bool isStarted = false;
  final List<String> messages = [];
  final selectedGenresProvider = StateProvider<List<String>>((ref) => []);
  final selectedOttsProvider = StateProvider<List<String>>((ref) => []);
  final selectedLanguagesProvider = StateProvider<List<String>>((ref) => []);
  final currentPageProvider = StateProvider<int>((ref) => 0);
  final PageController pageController = PageController();

  // void startChat() {
  //   isStarted = true;
  //   messages.add("OK, Let’s Start");
  //   ChatbotManager.instance.createChatMessage("OK, Let’s Start");
  //   notifyListeners();
  // }

  // void sendMessage(String message) {
  //   messages.add(message);
  //   ChatbotManager.instance.createChatMessage(message);
  //   Future.delayed(Duration(seconds: 2));
  //   ChatbotManager.instance.saveBotResponse(message);
  //   notifyListeners();
  // }

  void nextStep() async {
    isLoading = true; // Show loading
    notifyListeners();
    await Future.delayed(const Duration(seconds: 1)).then(
      (value) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (_scrollController.hasClients) {
            _scrollController
                .jumpTo(_scrollController.position.maxScrollExtent);
          }
        });
      },
    ); // Wait for 1 second
    isLoading = false;
    currentStep++;
    notifyListeners();
  }

  List<PreferenceResult> selectedContentType = [];
  List<PreferenceResult> selectedGenres = [];
  List<PreferenceResult> selectedSubtitleLanguage = [];
  List<PreferenceResult> selectedApps = [];
  List<PreferenceResult> selectedLanguages = [];
  //
  // List<String> genres = [
  //   'Action',
  //   'Adventure',
  //   'Comedy',
  //   'Drama',
  //   'Horror',
  //   'Romance',
  //   'Science Fiction',
  //   'Animation',
  //   'Thriller',
  //   'Documentary'
  // ];
  //
  // List<Map<String, dynamic>> apps = [
  //   {"name": 'Netflix', "asset": Assets.images.netflix.path},
  //   {"name": 'Prime Video', "asset": Assets.images.primeVideo.path},
  //   {"name": 'Disney+ Hotstar', "asset": Assets.images.hotstar.path},
  //   {"name": 'Sony LIV', "asset": Assets.images.sonyLiv.path},
  //   {"name": 'MX Player', "asset": Assets.images.mxPlayer.path},
  //   {"name": 'ALTT', "asset": Assets.images.altBalaji.path},
  //   {"name": 'Hoichoi', "asset": Assets.images.image9.path},
  //   {"name": 'Jio TV', "asset": Assets.images.jioTv.path},
  //   {"name": 'Zee5', "asset": Assets.images.zee5.path},
  //   {"name": 'Ullu', "asset": Assets.images.ullu.path},
  //   {"name": 'Plex', "asset": Assets.images.plex.path},
  //   {"name": 'Tata Bing', "asset": Assets.images.tataBinge.path},
  //   {"name": 'Lionsgate Play', "asset": Assets.images.liongatePlay.path},
  // ];
  //
  // final languages = [
  //   'English',
  //   'Hindi',
  //   'Gujarati',
  //   'Telugu',
  //   'Korean',
  //   'Malayalam',
  //   'Marathi',
  //   'Spanish'
  // ];

  void toggleContentType(PreferenceResult contentType) {
    if (selectedContentType.contains(contentType)) {
      selectedContentType.remove(contentType);
      contentType.isPreferred = false;
    } else {
      selectedContentType.add(contentType);
      contentType.isPreferred = true;
    }
    notifyListeners();
  }

  void toggleGenre(PreferenceResult genre) {
    if (selectedGenres.contains(genre)) {
      selectedGenres.remove(genre);
      genre.isPreferred = false;
    } else {
      selectedGenres.add(genre);
      genre.isPreferred = true;
    }
    notifyListeners();
  }

  void toggleSubtitleLanguage(PreferenceResult subtitleLanguage) {
    if (selectedSubtitleLanguage.contains(subtitleLanguage)) {
      selectedSubtitleLanguage.remove(subtitleLanguage);
      subtitleLanguage.isPreferred = false;
    } else {
      selectedSubtitleLanguage.add(subtitleLanguage);
      subtitleLanguage.isPreferred = true;
    }
    notifyListeners();
  }

  void toggleApp(PreferenceResult app) {
    if (selectedApps.contains(app)) {
      selectedApps.remove(app);
      app.isPreferred = false;
    } else {
      selectedApps.add(app);
      app.isPreferred = true;
    }
    notifyListeners();
  }

  void toggleLanguage(PreferenceResult language) {
    if (selectedLanguages.contains(language)) {
      selectedLanguages.remove(language);
      language.isPreferred = false;
    } else {
      selectedLanguages.add(language);
      language.isPreferred = true;
    }
    notifyListeners();
  }

  void disposeController({bool isNotify = false}) {
    isLoading = false;
    if (isNotify) {
      notifyListeners();
    }
  }

  void updateWidget() {
    notifyListeners();
  }
}
