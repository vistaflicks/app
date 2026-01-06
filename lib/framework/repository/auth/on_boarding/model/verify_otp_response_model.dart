// To parse this JSON data, do
//
//     final verifyOtpResponseModel = verifyOtpResponseModelFromJson(jsonString);

import 'dart:convert';

VerifyOtpResponseModel verifyOtpResponseModelFromJson(String str) =>
    VerifyOtpResponseModel.fromJson(json.decode(str));

String verifyOtpResponseModelToJson(VerifyOtpResponseModel data) =>
    json.encode(data.toJson());

class VerifyOtpResponseModel {
  Error? error;
  VerifyOtpData? data;
  int? code;
  String? message;
  bool? success;

  VerifyOtpResponseModel({
    this.error,
    this.data,
    this.code,
    this.message,
    this.success,
  });

  factory VerifyOtpResponseModel.fromJson(Map<String, dynamic> json) =>
      VerifyOtpResponseModel(
        error: json["error"] == null ? null : Error.fromJson(json["error"]),
        data:
            json["data"] == null ? null : VerifyOtpData.fromJson(json["data"]),
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

class VerifyOtpData {
  VerifyOTPUser? user;
  Tokens? tokens;
  bool? isNewUser;

  VerifyOtpData({
    this.user,
    this.tokens,
    this.isNewUser,
  });

  factory VerifyOtpData.fromJson(Map<String, dynamic> json) => VerifyOtpData(
        user:
            json["user"] == null ? null : VerifyOTPUser.fromJson(json["user"]),
        tokens: json["tokens"] == null ? null : Tokens.fromJson(json["tokens"]),
        isNewUser: json["isNewUser"],
      );

  Map<String, dynamic> toJson() => {
        "user": user?.toJson(),
        "tokens": tokens?.toJson(),
        "isNewUser": isNewUser,
      };
}

class Tokens {
  Access? access;
  Access? refresh;

  Tokens({
    this.access,
    this.refresh,
  });

  factory Tokens.fromJson(Map<String, dynamic> json) => Tokens(
        access: json["access"] == null ? null : Access.fromJson(json["access"]),
        refresh:
            json["refresh"] == null ? null : Access.fromJson(json["refresh"]),
      );

  Map<String, dynamic> toJson() => {
        "access": access?.toJson(),
        "refresh": refresh?.toJson(),
      };
}

class Access {
  String? token;
  String? expires;

  Access({
    this.token,
    this.expires,
  });

  factory Access.fromJson(Map<String, dynamic> json) => Access(
        token: json["token"],
        expires: json["expires"],
      );

  Map<String, dynamic> toJson() => {
        "token": token,
        "expires": expires,
      };
}

class VerifyOTPUser {
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
  List<String>? genre;
  List<String>? language;
  List<String>? subTitleLanguage;
  List<String>? imdbRating;
  List<String>? region;
  List<String>? ageRating;
  List<String>? ottPlatforms;
  List<String>? contentType;
  bool? isAppUser;
  List<String>? viewedReels;
  List<dynamic>? company;
  List<dynamic>? content;
  int? age;
  String? firstName;
  String? gender;
  String? lastName;
  String? userName;
  String? id;

  VerifyOTPUser({
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
    this.genre,
    this.language,
    this.subTitleLanguage,
    this.imdbRating,
    this.region,
    this.ageRating,
    this.ottPlatforms,
    this.contentType,
    this.isAppUser,
    this.viewedReels,
    this.company,
    this.content,
    this.age,
    this.firstName,
    this.gender,
    this.lastName,
    this.userName,
    this.id,
  });

  factory VerifyOTPUser.fromJson(Map<String, dynamic> json) => VerifyOTPUser(
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
        genre: json["genre"] == null
            ? []
            : List<String>.from(json["genre"]!.map((x) => x)),
        language: json["language"] == null
            ? []
            : List<String>.from(json["language"]!.map((x) => x)),
        subTitleLanguage: json["subTitleLanguage"] == null
            ? []
            : List<String>.from(json["subTitleLanguage"]!.map((x) => x)),
        imdbRating: json["imdbRating"] == null
            ? []
            : List<String>.from(json["imdbRating"]!.map((x) => x)),
        region: json["region"] == null
            ? []
            : List<String>.from(json["region"]!.map((x) => x)),
        ageRating: json["ageRating"] == null
            ? []
            : List<String>.from(json["ageRating"]!.map((x) => x)),
        ottPlatforms: json["ottPlatforms"] == null
            ? []
            : List<String>.from(json["ottPlatforms"]!.map((x) => x)),
        contentType: json["contentType"] == null
            ? []
            : List<String>.from(json["contentType"]!.map((x) => x)),
        isAppUser: json["isAppUser"],
        viewedReels: json["viewedReels"] == null
            ? []
            : List<String>.from(json["viewedReels"]!.map((x) => x)),
        company: json["company"] == null
            ? []
            : List<dynamic>.from(json["company"]!.map((x) => x)),
        content: json["content"] == null
            ? []
            : List<dynamic>.from(json["content"]!.map((x) => x)),
        age: json["age"],
        firstName: json["firstName"],
        gender: json["gender"],
        lastName: json["lastName"],
        userName: json["userName"],
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
        "genre": genre == null ? [] : List<dynamic>.from(genre!.map((x) => x)),
        "language":
            language == null ? [] : List<dynamic>.from(language!.map((x) => x)),
        "subTitleLanguage": subTitleLanguage == null
            ? []
            : List<dynamic>.from(subTitleLanguage!.map((x) => x)),
        "imdbRating": imdbRating == null
            ? []
            : List<dynamic>.from(imdbRating!.map((x) => x)),
        "region":
            region == null ? [] : List<dynamic>.from(region!.map((x) => x)),
        "ageRating": ageRating == null
            ? []
            : List<dynamic>.from(ageRating!.map((x) => x)),
        "ottPlatforms": ottPlatforms == null
            ? []
            : List<dynamic>.from(ottPlatforms!.map((x) => x)),
        "contentType": contentType == null
            ? []
            : List<dynamic>.from(contentType!.map((x) => x)),
        "isAppUser": isAppUser,
        "viewedReels": viewedReels == null
            ? []
            : List<dynamic>.from(viewedReels!.map((x) => x)),
        "company":
            company == null ? [] : List<dynamic>.from(company!.map((x) => x)),
        "content":
            content == null ? [] : List<dynamic>.from(content!.map((x) => x)),
        "age": age,
        "firstName": firstName,
        "gender": gender,
        "lastName": lastName,
        "userName": userName,
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

// // To parse this JSON data, do
// //
// //     final verifyOtpResponseModel = verifyOtpResponseModelFromJson(jsonString);
//
// import 'dart:convert';
//
// VerifyOtpResponseModel verifyOtpResponseModelFromJson(String str) =>
//     VerifyOtpResponseModel.fromJson(json.decode(str));
//
// String verifyOtpResponseModelToJson(VerifyOtpResponseModel data) =>
//     json.encode(data.toJson());
//
// class VerifyOtpResponseModel {
//   Error? error;
//   VerifyOtpData? data;
//   int? code;
//   String? message;
//   bool? success;
//
//   VerifyOtpResponseModel({
//     this.error,
//     this.data,
//     this.code,
//     this.message,
//     this.success,
//   });
//
//   factory VerifyOtpResponseModel.fromJson(Map<String, dynamic> json) =>
//       VerifyOtpResponseModel(
//         error: json["error"] == null ? null : Error.fromJson(json["error"]),
//         data:
//             json["data"] == null ? null : VerifyOtpData.fromJson(json["data"]),
//         code: json["code"],
//         message: json["message"],
//         success: json["success"],
//       );
//
//   Map<String, dynamic> toJson() => {
//         "error": error?.toJson(),
//         "data": data?.toJson(),
//         "code": code,
//         "message": message,
//         "success": success,
//       };
// }
//
// class VerifyOtpData {
//   User? user;
//   Tokens? tokens;
//
//   VerifyOtpData({
//     this.user,
//     this.tokens,
//   });
//
//   factory VerifyOtpData.fromJson(Map<String, dynamic> json) => VerifyOtpData(
//         user: json["user"] == null ? null : User.fromJson(json["user"]),
//         tokens: json["tokens"] == null ? null : Tokens.fromJson(json["tokens"]),
//       );
//
//   Map<String, dynamic> toJson() => {
//         "user": user?.toJson(),
//         "tokens": tokens?.toJson(),
//       };
// }
//
// class Tokens {
//   Access? access;
//   Access? refresh;
//
//   Tokens({
//     this.access,
//     this.refresh,
//   });
//
//   factory Tokens.fromJson(Map<String, dynamic> json) => Tokens(
//         access: json["access"] == null ? null : Access.fromJson(json["access"]),
//         refresh:
//             json["refresh"] == null ? null : Access.fromJson(json["refresh"]),
//       );
//
//   Map<String, dynamic> toJson() => {
//         "access": access?.toJson(),
//         "refresh": refresh?.toJson(),
//       };
// }
//
// class Access {
//   String? token;
//   String? expires;
//
//   Access({
//     this.token,
//     this.expires,
//   });
//
//   factory Access.fromJson(Map<String, dynamic> json) => Access(
//         token: json["token"],
//         expires: json["expires"],
//       );
//
//   Map<String, dynamic> toJson() => {
//         "token": token,
//         "expires": expires,
//       };
// }
//
// class User {
//   PrimaryContact? primaryContact;
//   Rejected? rejected;
//   Loc? loc;
//   String? email;
//   String? status;
//   bool? isDeleted;
//   bool? isEmailVerified;
//   bool? isPhoneVerified;
//   String? userType;
//   String? approvalStatus;
//   String? authSource;
//   List<dynamic>? company;
//   int? age;
//   String? firstName;
//   String? gender;
//   String? lastName;
//   String? id;
//
//   User({
//     this.primaryContact,
//     this.rejected,
//     this.loc,
//     this.email,
//     this.status,
//     this.isDeleted,
//     this.isEmailVerified,
//     this.isPhoneVerified,
//     this.userType,
//     this.approvalStatus,
//     this.authSource,
//     this.company,
//     this.age,
//     this.firstName,
//     this.gender,
//     this.lastName,
//     this.id,
//   });
//
//   factory User.fromJson(Map<String, dynamic> json) => User(
//         primaryContact: json["primaryContact"] == null
//             ? null
//             : PrimaryContact.fromJson(json["primaryContact"]),
//         rejected: json["rejected"] == null
//             ? null
//             : Rejected.fromJson(json["rejected"]),
//         loc: json["loc"] == null ? null : Loc.fromJson(json["loc"]),
//         email: json["email"],
//         status: json["status"],
//         isDeleted: json["isDeleted"],
//         isEmailVerified: json["isEmailVerified"],
//         isPhoneVerified: json["isPhoneVerified"],
//         userType: json["userType"],
//         approvalStatus: json["approvalStatus"],
//         authSource: json["authSource"],
//         company: json["company"] == null
//             ? []
//             : List<dynamic>.from(json["company"]!.map((x) => x)),
//         age: json["age"],
//         firstName: json["firstName"],
//         gender: json["gender"],
//         lastName: json["lastName"],
//         id: json["id"],
//       );
//
//   Map<String, dynamic> toJson() => {
//         "primaryContact": primaryContact?.toJson(),
//         "rejected": rejected?.toJson(),
//         "loc": loc?.toJson(),
//         "email": email,
//         "status": status,
//         "isDeleted": isDeleted,
//         "isEmailVerified": isEmailVerified,
//         "isPhoneVerified": isPhoneVerified,
//         "userType": userType,
//         "approvalStatus": approvalStatus,
//         "authSource": authSource,
//         "company":
//             company == null ? [] : List<dynamic>.from(company!.map((x) => x)),
//         "age": age,
//         "firstName": firstName,
//         "gender": gender,
//         "lastName": lastName,
//         "id": id,
//       };
// }
//
// class Loc {
//   List<dynamic>? coordinates;
//
//   Loc({
//     this.coordinates,
//   });
//
//   factory Loc.fromJson(Map<String, dynamic> json) => Loc(
//         coordinates: json["coordinates"] == null
//             ? []
//             : List<dynamic>.from(json["coordinates"]!.map((x) => x)),
//       );
//
//   Map<String, dynamic> toJson() => {
//         "coordinates": coordinates == null
//             ? []
//             : List<dynamic>.from(coordinates!.map((x) => x)),
//       };
// }
//
// class PrimaryContact {
//   int? dialCode;
//   int? number;
//
//   PrimaryContact({
//     this.dialCode,
//     this.number,
//   });
//
//   factory PrimaryContact.fromJson(Map<String, dynamic> json) => PrimaryContact(
//         dialCode: json["dialCode"],
//         number: json["number"],
//       );
//
//   Map<String, dynamic> toJson() => {
//         "dialCode": dialCode,
//         "number": number,
//       };
// }
//
// class Rejected {
//   String? reason;
//   String? remark;
//
//   Rejected({
//     this.reason,
//     this.remark,
//   });
//
//   factory Rejected.fromJson(Map<String, dynamic> json) => Rejected(
//         reason: json["reason"],
//         remark: json["remark"],
//       );
//
//   Map<String, dynamic> toJson() => {
//         "reason": reason,
//         "remark": remark,
//       };
// }
//
// class Error {
//   Error();
//
//   factory Error.fromJson(Map<String, dynamic> json) => Error();
//
//   Map<String, dynamic> toJson() => {};
// }
