abstract class BookmarkRepository {
  Future getBannerListAPI();

  Future getAllBookmarkListAPI(
      {required int pageNo, required String search, required String limit});
}
