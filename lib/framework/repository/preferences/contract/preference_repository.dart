abstract class PreferenceRepository {
  Future getPreferencesAPI({required String type});

  Future updatePreferencesAPI({required String request});
}
