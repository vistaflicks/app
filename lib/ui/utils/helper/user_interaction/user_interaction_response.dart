// To parse this JSON data, do
//
//     final getUserInteractionResponse = getUserInteractionResponseFromJson(jsonString);

import 'dart:convert';

GetUserInteractionResponse getUserInteractionResponseFromJson(String str) =>
    GetUserInteractionResponse.fromJson(json.decode(str));

String getUserInteractionResponseToJson(GetUserInteractionResponse data) =>
    json.encode(data.toJson());

class GetUserInteractionResponse {
  Error? error;
  Data? data;
  int? code;
  String? message;
  bool? success;

  GetUserInteractionResponse({
    this.error,
    this.data,
    this.code,
    this.message,
    this.success,
  });

  factory GetUserInteractionResponse.fromJson(Map<String, dynamic> json) =>
      GetUserInteractionResponse(
        error: json["error"] == null ? null : Error.fromJson(json["error"]),
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
        code: json["code"],
        message: json["message"],
        success: json["success"],
      );

  Map<String, dynamic> toJson() => {
        "error": error?.toJson(),
        "data": data?.toJson(),
        "code": code,
        "message": message,
        "success": success,
      };
}

class Data {
  String? userId;
  String? reelId;
  List<String>? actionType;
  String? deviceType;
  String? ipAddress;
  int? duration;
  GeoLocation? geoLocation;
  bool? isPromoted;
  String? id;

  Data({
    this.userId,
    this.reelId,
    this.actionType,
    this.deviceType,
    this.ipAddress,
    this.duration,
    this.geoLocation,
    this.isPromoted,
    this.id,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        userId: json["userId"],
        reelId: json["reelId"],
        actionType: json["actionType"] == null
            ? []
            : List<String>.from(json["actionType"]!.map((x) => x)),
        deviceType: json["deviceType"],
        ipAddress: json["ipAddress"],
        duration: json["duration"],
        geoLocation: json["geoLocation"] == null
            ? null
            : GeoLocation.fromJson(json["geoLocation"]),
        isPromoted: json["isPromoted"],
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "userId": userId,
        "reelId": reelId,
        "actionType": actionType,
        "deviceType": deviceType,
        "ipAddress": ipAddress,
        "duration": duration,
        "geoLocation": geoLocation?.toJson(),
        "isPromoted": isPromoted,
        "id": id,
      };
}

class GeoLocation {
  List<double>? coordinates;
  String? type;

  GeoLocation({
    this.coordinates,
    this.type,
  });

  factory GeoLocation.fromJson(Map<String, dynamic> json) => GeoLocation(
        coordinates: json["coordinates"] == null
            ? []
            : List<double>.from(json["coordinates"]!.map((x) => x?.toDouble())),
        type: json["type"],
      );

  Map<String, dynamic> toJson() => {
        "coordinates": coordinates == null
            ? []
            : List<dynamic>.from(coordinates!.map((x) => x)),
        "type": type,
      };
}

class Error {
  Error();

  factory Error.fromJson(Map<String, dynamic> json) => Error();

  Map<String, dynamic> toJson() => {};
}

// import 'dart:convert';
//
// /// Parse JSON data into model
// GetUserInteractionResponse getUserInteractionResponseFromJson(String str) =>
//     GetUserInteractionResponse.fromJson(json.decode(str));
//
// String getUserInteractionResponseToJson(GetUserInteractionResponse data) =>
//     json.encode(data.toJson());
//
// class GetUserInteractionResponse {
//   Error? error;
//   Data? data;
//   int? code;
//   String? message;
//   bool? success;
//
//   GetUserInteractionResponse({
//     this.error,
//     this.data,
//     this.code,
//     this.message,
//     this.success,
//   });
//
//   /// Factory method to create the model from JSON
//   factory GetUserInteractionResponse.fromJson(Map<String, dynamic> json) =>
//       GetUserInteractionResponse(
//         error: json["error"] != null ? Error.fromJson(json["error"]) : null,
//         data: json["data"] != null ? Data.fromJson(json["data"]) : null,
//         code: json["code"],
//         message: json["message"],
//         success: json["success"],
//       );
//
//   /// Convert the model to JSON format
//   Map<String, dynamic> toJson() => {
//         "error": error?.toJson(),
//         "data": data?.toJson(),
//         "code": code,
//         "message": message,
//         "success": success,
//       };
// }
//
// class Data {
//   String? userId;
//   String? contentId;
//   String? reelId;
//   String? actionType;
//   String? deviceType;
//   String? ipAddress;
//   GeoLocation? geoLocation;
//   bool? isPromoted;
//   String? id;
//   String? comment; // For 'comment' action
//   String? searchTerm; // For 'search' action
//   int? duration; // For 'watch' action
//   ShareInfo? shareInfo; // For 'share' action
//   String? adCampaignId; // For promoted actions
//
//   Data({
//     this.userId,
//     this.contentId,
//     this.reelId,
//     this.actionType,
//     this.deviceType,
//     this.ipAddress,
//     this.geoLocation,
//     this.isPromoted,
//     this.id,
//     this.comment,
//     this.searchTerm,
//     this.duration,
//     this.shareInfo,
//     this.adCampaignId,
//   });
//
//   /// Factory method to parse JSON into `Data`
//   factory Data.fromJson(Map<String, dynamic> json) => Data(
//         userId: json["userId"],
//         contentId: json["contentId"],
//         reelId: json["reelId"],
//         actionType: json["actionType"],
//         deviceType: json["deviceType"],
//         ipAddress: json["ipAddress"],
//         geoLocation: json["geoLocation"] != null
//             ? GeoLocation.fromJson(json["geoLocation"])
//             : null,
//         isPromoted: json["isPromoted"],
//         id: json["id"],
//         comment: json["comment"],
//         searchTerm: json["searchTerm"],
//         duration: json["duration"],
//         shareInfo: json["shareInfo"] != null
//             ? ShareInfo.fromJson(json["shareInfo"])
//             : null,
//         adCampaignId: json["adCampaignId"],
//       );
//
//   /// Convert `Data` to JSON format
//   Map<String, dynamic> toJson() => {
//         "userId": userId,
//         "contentId": contentId,
//         "reelId": reelId,
//         "actionType": actionType,
//         "deviceType": deviceType,
//         "ipAddress": ipAddress,
//         "geoLocation": geoLocation?.toJson(),
//         "isPromoted": isPromoted,
//         "id": id,
//         "comment": comment,
//         "searchTerm": searchTerm,
//         "duration": duration,
//         "shareInfo": shareInfo?.toJson(),
//         "adCampaignId": adCampaignId,
//       };
// }
//
// class GeoLocation {
//   List<double>? coordinates;
//   String? type;
//
//   GeoLocation({
//     this.coordinates,
//     this.type,
//   });
//
//   /// Factory method to parse JSON into `GeoLocation`
//   factory GeoLocation.fromJson(Map<String, dynamic> json) => GeoLocation(
//         coordinates: json["coordinates"] != null
//             ? List<double>.from(json["coordinates"].map((x) => x.toDouble()))
//             : [],
//         type: json["type"],
//       );
//
//   /// Convert `GeoLocation` to JSON format
//   Map<String, dynamic> toJson() => {
//         "coordinates": coordinates != null
//             ? List<dynamic>.from(coordinates!.map((x) => x))
//             : [],
//         "type": type,
//       };
// }
//
// class ShareInfo {
//   String? platform;
//   String? recipient;
//
//   ShareInfo({
//     this.platform,
//     this.recipient,
//   });
//
//   /// Factory method to parse JSON into `ShareInfo`
//   factory ShareInfo.fromJson(Map<String, dynamic> json) => ShareInfo(
//         platform: json["platform"],
//         recipient: json["recipient"],
//       );
//
//   /// Convert `ShareInfo` to JSON format
//   Map<String, dynamic> toJson() => {
//         "platform": platform,
//         "recipient": recipient,
//       };
// }
//
// class Error {
//   Error();
//
//   /// Factory method to create `Error` from JSON
//   factory Error.fromJson(Map<String, dynamic> json) => Error();
//
//   /// Convert `Error` to JSON format
//   Map<String, dynamic> toJson() => {};
// }
