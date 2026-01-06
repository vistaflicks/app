// To parse this JSON data, do
//
//     final generateOtpResponseModel = generateOtpResponseModelFromJson(jsonString);

import 'dart:convert';

GenerateOtpResponseModel generateOtpResponseModelFromJson(String str) =>
    GenerateOtpResponseModel.fromJson(json.decode(str));

String generateOtpResponseModelToJson(GenerateOtpResponseModel data) =>
    json.encode(data.toJson());

class GenerateOtpResponseModel {
  Error? error;
  Data? data;
  int? code;
  String? message;
  bool? success;

  GenerateOtpResponseModel({
    this.error,
    this.data,
    this.code,
    this.message,
    this.success,
  });

  factory GenerateOtpResponseModel.fromJson(Map<String, dynamic> json) =>
      GenerateOtpResponseModel(
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
  GenerateOtpUser? user;
  String? orderId;

  Data({
    this.user,
    this.orderId,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        user: json["user"] == null
            ? null
            : GenerateOtpUser.fromJson(json["user"]),
        orderId: json["orderId"],
      );

  Map<String, dynamic> toJson() => {
        "user": user?.toJson(),
        "orderId": orderId,
      };
}

class GenerateOtpUser {
  PrimaryContact? primaryContact;
  Rejected? rejected;
  Loc? loc;
  String? email;
  String? status;
  bool? isDeleted;
  bool? isEmailVerified;
  bool? isPhoneVerified;
  String? userType;
  String? approvalStatus;
  String? authSource;
  List<dynamic>? company;
  int? age;
  String? firstName;
  String? gender;
  String? lastName;
  String? id;

  GenerateOtpUser({
    this.primaryContact,
    this.rejected,
    this.loc,
    this.email,
    this.status,
    this.isDeleted,
    this.isEmailVerified,
    this.isPhoneVerified,
    this.userType,
    this.approvalStatus,
    this.authSource,
    this.company,
    this.age,
    this.firstName,
    this.gender,
    this.lastName,
    this.id,
  });

  factory GenerateOtpUser.fromJson(Map<String, dynamic> json) =>
      GenerateOtpUser(
        primaryContact: json["primaryContact"] == null
            ? null
            : PrimaryContact.fromJson(json["primaryContact"]),
        rejected: json["rejected"] == null
            ? null
            : Rejected.fromJson(json["rejected"]),
        loc: json["loc"] == null ? null : Loc.fromJson(json["loc"]),
        email: json["email"],
        status: json["status"],
        isDeleted: json["isDeleted"],
        isEmailVerified: json["isEmailVerified"],
        isPhoneVerified: json["isPhoneVerified"],
        userType: json["userType"],
        approvalStatus: json["approvalStatus"],
        authSource: json["authSource"],
        company: json["company"] == null
            ? []
            : List<dynamic>.from(json["company"]!.map((x) => x)),
        age: json["age"],
        firstName: json["firstName"],
        gender: json["gender"],
        lastName: json["lastName"],
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "primaryContact": primaryContact?.toJson(),
        "rejected": rejected?.toJson(),
        "loc": loc?.toJson(),
        "email": email,
        "status": status,
        "isDeleted": isDeleted,
        "isEmailVerified": isEmailVerified,
        "isPhoneVerified": isPhoneVerified,
        "userType": userType,
        "approvalStatus": approvalStatus,
        "authSource": authSource,
        "company":
            company == null ? [] : List<dynamic>.from(company!.map((x) => x)),
        "age": age,
        "firstName": firstName,
        "gender": gender,
        "lastName": lastName,
        "id": id,
      };
}

class Loc {
  List<dynamic>? coordinates;

  Loc({
    this.coordinates,
  });

  factory Loc.fromJson(Map<String, dynamic> json) => Loc(
        coordinates: json["coordinates"] == null
            ? []
            : List<dynamic>.from(json["coordinates"]!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "coordinates": coordinates == null
            ? []
            : List<dynamic>.from(coordinates!.map((x) => x)),
      };
}

class PrimaryContact {
  int? dialCode;
  int? number;

  PrimaryContact({
    this.dialCode,
    this.number,
  });

  factory PrimaryContact.fromJson(Map<String, dynamic> json) => PrimaryContact(
        dialCode: json["dialCode"],
        number: json["number"],
      );

  Map<String, dynamic> toJson() => {
        "dialCode": dialCode,
        "number": number,
      };
}

class Rejected {
  String? reason;
  String? remark;

  Rejected({
    this.reason,
    this.remark,
  });

  factory Rejected.fromJson(Map<String, dynamic> json) => Rejected(
        reason: json["reason"],
        remark: json["remark"],
      );

  Map<String, dynamic> toJson() => {
        "reason": reason,
        "remark": remark,
      };
}

class Error {
  Error();

  factory Error.fromJson(Map<String, dynamic> json) => Error();

  Map<String, dynamic> toJson() => {};
}
