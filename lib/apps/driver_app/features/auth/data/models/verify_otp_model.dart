import 'package:wasel_driver/apps/core/enums/app_enums.dart';

class UserVerificationTypeModel {
  final String? value;
  final VerifyOtpType? type;
  final String? token, refreshToken, status, referenceId, rejectionReason;
  final bool? canOperate;

  UserVerificationTypeModel({
    this.value,
    this.type,
    this.token,
    this.refreshToken,
    this.status,
    this.referenceId,
    this.rejectionReason,
    this.canOperate,
  });

  factory UserVerificationTypeModel.fromJson(Map<String, dynamic> json) {
    return UserVerificationTypeModel(
      value: json['temp_token'],
      type: json['type'],
      token: json['access_token'],
      refreshToken: json['refresh_token'],
      status: json['status'],
      referenceId: json['reference_id'],
      rejectionReason: json['rejection_reason'],
      canOperate: json['can_operate'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'value': value, 'type': type};
  }
}
