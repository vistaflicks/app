import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:geocoding/geocoding.dart';
import 'package:get_ip_address/get_ip_address.dart';
import 'package:vista_flicks/framework/dependency_injection/inject.dart';
import 'package:vista_flicks/framework/provider/network/network.dart';
import 'package:vista_flicks/framework/repository/auth/on_boarding/model/verify_otp_response_model.dart';
import 'package:vista_flicks/framework/utils/local_storage/session.dart';
import 'package:vista_flicks/ui/utils/helper/location_helper/location_helper.dart';
import 'package:vista_flicks/ui/utils/helper/user_interaction/user_interaction_response.dart';

class InteractionService {
  // Singleton instance
  static final InteractionService _instance =
      InteractionService._internal(getIt<DioClient>());

  factory InteractionService() => _instance;

  InteractionService._internal(this.apiClient);

  final DioClient apiClient;

  /// API method to handle interactions
  Future<ApiResult<GetUserInteractionResponse>?> postInteraction({
    required List<InteractionActionType> actionType,
    String? contentId,
    String? reelId,
    String? comment,
    String? searchTerm,
    int? watchCount,
    int? duration, // In seconds
    String? recipient, // For share action
    bool? isPromoted,
    String? adCampaignId, // For promoted actions
  }) async {
    try {
      // Get IP Address
      var ipAddress = IpAddress(type: RequestType.json);
      var ip = await ipAddress.getIpAddress();

      // Get address details from coordinates
      String? city = '';
      String? state = '';
      String? country = '';

      if (LocationHandler.currentPosition != null) {
        try {
          List<Placemark> placemarks = await placemarkFromCoordinates(
            LocationHandler.currentPosition!.latitude,
            LocationHandler.currentPosition!.longitude,
          );

          if (placemarks.isNotEmpty) {
            Placemark place = placemarks[0];
            city = place.locality;
            state = place.administrativeArea;
            country = place.country;
          }
        } catch (e) {
          log('Error getting address details: $e');
        }
      }

      // Create the interaction map
      var map = {
        // "userId": Session.userId,
        if (contentId != null) "contentId": contentId,
        if (reelId != null) "reelId": reelId,
        "ipAddress": ip["ip"] ?? "",
        "deviceType": Platform.isAndroid ? "Android" : "iOS",
        "longitude": LocationHandler.currentPosition?.longitude ?? 0.0,
        "latitude": LocationHandler.currentPosition?.latitude ?? 0.0,
        "city": city,
        "state": state,
        "country": country,
        "actionType":
            List.generate(actionType.length, (i) => actionType[i].value),

        if (watchCount != null) "watchCount": watchCount,

        /// For 'comment' action
        if (comment != null) "comment": comment,

        /// For 'search' action
        if (searchTerm != null) "searchTerm": searchTerm,

        /// For 'watch' action
        if (duration != null) "duration": duration,
        if (recipient != null)
          "shareInfo": {
            "platform":
                Platform.isAndroid ? "Android" : "iOS", // For 'share' action
            "recipient": recipient,
          },
        if (isPromoted != null) "isPromoted": isPromoted,

        /// For promoted actions
        if (adCampaignId != null) "adCampaignId": adCampaignId,
      };

      log("Interaction Map: $map");

      // Perform the POST request
      String jsonString = json.encode(map);
      Response result =
          await apiClient.postRequest(ApiEndPoints.interaction, jsonString);
      var user = VerifyOTPUser.fromJson(jsonDecode(Session.userData));
      if (user.userType?.toLowerCase() != "cd-user") {
        return null;
      }

      if (result.statusCode == ApiEndPoints.apiStatus_200) {
        var response = result.data;

        if (result.data["success"] == true) {
          // Parse the response into the model
          GetUserInteractionResponse interactionResponse =
              GetUserInteractionResponse.fromJson(result.data);

          return ApiResult.success(data: interactionResponse);
        } else {
          return ApiResult.failure(
              error:
                  NetworkExceptions.defaultError(result.statusMessage ?? ''));
        }
      } else {
        return ApiResult.failure(
            error: NetworkExceptions.defaultError('Unexpected error'));
      }
    } catch (error) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(error));
    }
  }
}

enum InteractionActionType {
  like,
  views,
  watch,
  comment,
  share,
  save,
  search,
  dislike,
}

extension InteractionActionTypeExtension on InteractionActionType {
  String get value {
    switch (this) {
      case InteractionActionType.like:
        return 'like';
      case InteractionActionType.views:
        return 'views';
      case InteractionActionType.watch:
        return 'watch';
      case InteractionActionType.comment:
        return 'comment';
      case InteractionActionType.share:
        return 'share';
      case InteractionActionType.save:
        return 'save';
      case InteractionActionType.search:
        return 'search';
      case InteractionActionType.dislike:
        return 'dislike';
    }
  }
}
