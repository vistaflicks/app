class CommonMoviePosterListModel {
  final String title;
  final List<String> posterImg;

  CommonMoviePosterListModel({
    required this.title,
    required this.posterImg,
  });

  factory CommonMoviePosterListModel.fromJson(Map<String, dynamic> json) {
    return CommonMoviePosterListModel(
      title: json['title'] as String,
      posterImg: List<String>.from(json['posterImg']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'posterImg': posterImg,
    };
  }
}
