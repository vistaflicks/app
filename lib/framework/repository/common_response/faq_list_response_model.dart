// To parse this JSON data, do
//
//     final faqListResponseModel = faqListResponseModelFromJson(jsonString);

import 'dart:convert';

FaqListResponseModel faqListResponseModelFromJson(String str) => FaqListResponseModel.fromJson(json.decode(str));

String faqListResponseModelToJson(FaqListResponseModel data) => json.encode(data.toJson());

class FaqListResponseModel {
  bool? success;
  int? status;
  String? message;
  List<FaqData>? data;

  FaqListResponseModel({
    this.success,
    this.status,
    this.message,
    this.data,
  });

  factory FaqListResponseModel.fromJson(Map<String, dynamic> json) => FaqListResponseModel(
        success: json['success'],
        status: json['status'],
        message: json['message'],
        data: json['data'] == null ? [] : List<FaqData>.from(json['data']!.map((x) => FaqData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        'success': success,
        'status': status,
        'message': message,
        'data': data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class FaqData {
  int? id;
  String? title;
  String? description;

  FaqData({
    this.id,
    this.title,
    this.description,
  });

  factory FaqData.fromJson(Map<String, dynamic> json) => FaqData(
        id: json['id'],
        title: json['title'],
        description: json['description'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
      };
}
