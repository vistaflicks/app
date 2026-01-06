abstract class SearchRepository {
  Future getExploreListAPI();
  Future getHomeViewAllAPI(
      {required String type, required String page, String? search});

  Future getSearchAPI({required String search});
}
