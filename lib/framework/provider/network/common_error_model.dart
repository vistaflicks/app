import 'dart:convert';

CommonErrorModel commonErrorModelFromJson(String str) {
  try {
    final data = json.decode(str.isEmpty ? '' : str);
    return CommonErrorModel.fromJson(data);
  } catch (e) {
    return CommonErrorModel();
  }
}

class CommonErrorModel<T> {
  CommonErrorModel({
    this.message,
    this.data,
    this.status,
  });

  String? message;
  dynamic data;
  int? status;

  factory CommonErrorModel.fromJson(Map<String, dynamic> json) => CommonErrorModel(
        message: json['message'] ?? '',
        data: json['data'],
        status: json['status'] ?? 0,
      );
}
