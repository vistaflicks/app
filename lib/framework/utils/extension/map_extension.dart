extension MapExtension<T> on Map {
  Map<T, String> get reverse {
    return map((k, v) => MapEntry(v, k));
  }
}
