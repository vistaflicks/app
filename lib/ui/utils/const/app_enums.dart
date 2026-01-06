enum ScreenName {
  login,
  dashboard,
  master,
  meetingCategories,
  country,
  city,
  state,
  salesUser,
  clients,
  meeting,
  attendance,
  cms
}

enum CMSType { termsCondition, privacyPolicy, about, faq, none }

enum ErrorType { error403, error404, noInternet }

enum AdsCategory {
  MobileAppSecondaryLeft,
  MobileAppPrimary,
  MobileAppSecondaryRight,
}

enum weatherType { Weather, Road }

final pointEnumValuesString = ReverseEnumValues<AdsCategory>({
  AdsCategory.MobileAppPrimary: 'Mobile App Primary',
  AdsCategory.MobileAppSecondaryLeft: 'Mobile App Secondary Left',
  AdsCategory.MobileAppSecondaryRight: 'Mobile App Secondary Right',
});

class ReverseEnumValues<T> {
  Map<T, String> map;

  ReverseEnumValues(this.map);
}

enum FilterType {
  genre,
  language,
  subTitleLanguage,
  contentType,
  ottPlatforms,
  region,
  imdbRating,
  ageRating,
}

getFilterType(FilterType filterType) {
  switch (filterType) {
    case FilterType.genre:
      return 'Genre';
    case FilterType.language:
      return 'Language';
    case FilterType.subTitleLanguage:
      return 'Subtitles';
    case FilterType.contentType:
      return 'Content Type';
    case FilterType.ottPlatforms:
      return 'OTT Platforms';
    case FilterType.region:
      return 'Region';
    case FilterType.imdbRating:
      return 'Ratings';
    case FilterType.ageRating:
      return 'Age Rating';
  }
}

enum MessageType { text, image, video, document }
