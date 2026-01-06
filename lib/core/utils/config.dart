class Config {
  static const bool isProduction = true;
  static const String apiUrl = isProduction
      ? "https://api.ohogar.com/public/api/"
      : "https://ohoger.turtlesoftsolution.com/admin/public/api/";

  static const String kAuth = "kauth";
  static const String kPhone = "kPhone";
  static const String kCountry = "kCountry";

  static const String kLoggedIn = "kLoggedIn";
  static const String kIsBroker = "kIsBroker";
  static const String kIsLogin = "kIsLogin";
  static const String kUserData = "kUserData";

  static const String kNoImage =
      "https://upload.wikimedia.org/wikipedia/commons/1/14/No_Image_Available.jpg";

  static const String kNoUserImage =
      "https://e7.pngegg.com/pngimages/81/570/png-clipart-profile-logo-computer-icons-user-user-blue-heroes-thumbnail.png";
  static const String kNoAvatarImage =
      "https://img.freepik.com/free-vector/user-circles-set_78370-4704.jpg";
}
