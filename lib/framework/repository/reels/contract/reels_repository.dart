abstract class ReelsRepository {
  Future getReels({required int pageNo});
  Future getGuestReels();

  Future getReelsById({required String reelId, required String contentId});

  Future postInteraction({required Map<String, dynamic> map});

  Future postReport({required String report});

  Future getComments({required String reelId});

  Future postBookMarkWatchList(
      {bool? isBookmarked,
      bool? isWatched,
      double? rating,
      required String contentId,
      String reelId});
}
