import 'package:dio/dio.dart';
import 'package:either_dart/either.dart';
import 'package:wasel_driver/apps/core/enums/app_enums.dart';
import 'package:wasel_driver/apps/core/network/api/api_endpoints.dart';
import 'package:wasel_driver/apps/driver_app/features/inbox/data/model/chat_messages_model.dart';
import 'package:wasel_driver/apps/driver_app/features/inbox/data/model/inbox_model.dart';
import 'package:wasel_driver/apps/driver_app/features/inbox/data/model/ticket_model.dart';
import 'package:wasel_driver/apps/driver_app/features/inbox/data/services/inbox_api_service.dart';
import 'package:wasel_driver/apps/core/network/api/api_client.dart';

class InboxApiServiceImp implements InboxApiService {
  final ApiClient _apiClient;

  InboxApiServiceImp(this._apiClient);

  @override
  Future<Either<String, List<OfferModel>>> getOffersInbox(
    InboxStatus status,
  ) async {
    try {
      final result = await _apiClient.get(
        ApiEndpoints.getInboxPath,
        queryParameters: {'type': status.name},
      );
      if (result.isLeft) {
        return Left(result.left);
      } else {
        final response = result.right as Response;
        if (response.statusCode == 200) {
          return Right(
            (response.data['data'] as List)
                .map((e) => OfferModel.fromJson(e))
                .toList(),
          );
        } else {
          return Left(response.data['message']);
        }
      }
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, List<UpdateModel>>> getUpdatesInbox(
    InboxStatus status,
  ) async {
    try {
      final result = await _apiClient.get(
        ApiEndpoints.getInboxPath,
        queryParameters: {'type': status.name},
      );
      if (result.isLeft) {
        return Left(result.left);
      } else {
        final response = result.right as Response;
        if (response.statusCode == 200) {
          return Right(
            (response.data['data'] as List)
                .map((e) => UpdateModel.fromJson(e))
                .toList(),
          );
        } else {
          return Left(response.data['message']);
        }
      }
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, List<SupportModel>>> getSupportInbox(
    InboxStatus status,
  ) async {
    try {
      final result = await _apiClient.get(
        ApiEndpoints.getInboxPath,
        queryParameters: {'type': status.name},
      );
      if (result.isLeft) {
        return Left(result.left);
      } else {
        final response = result.right as Response;
        if (response.statusCode == 200) {
          return Right(
            (response.data['data'] as List)
                .map((e) => SupportModel.fromJson(e))
                .toList(),
          );
        } else {
          return Left(response.data['message']);
        }
      }
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, TicketStatusModel>> initiateChat(
    int ticketId,
    int userId,
  ) async {
    try {
      final result = await _apiClient.post(
        ApiEndpoints.chatInitiatPath,
        body: {'ticketId': ticketId, 'userId': userId},
      );
      if (result.isLeft) {
        return Left(result.left);
      } else {
        final response = result.right as Response;
        if (response.statusCode == 201) {
          return Right(TicketStatusModel.fromJson(response.data['data']));
        } else {
          return Left(response.data['message']);
        }
      }
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, List<ChatMessagesModel>>> getChatMessages(
    int conversationId,
  ) async {
    try {
      final result = await _apiClient.get(
        '${ApiEndpoints.conversationPath}/$conversationId/messages',
      );
      if (result.isLeft) {
        return Left(result.left);
      } else {
        final response = result.right as Response;
        if (response.statusCode == 200) {
          return Right(
            (response.data['data']['messages'] as List)
                .map((e) => ChatMessagesModel.fromJson(e))
                .toList(),
          );
        } else {
          return Left(response.data['message']);
        }
      }
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, bool>> sendMessage(
    int conversationId,
    int senderId,
    String message,
    String senderType,
  ) async {
    try {
      final result = await _apiClient.post(
        '${ApiEndpoints.conversationPath}/$conversationId/message',
        body: {
          'senderId': senderId,
          'content': message,
          'senderType': senderType,
        },
      );
      if (result.isLeft) {
        return Left(result.left);
      } else {
        final response = result.right as Response;
        if (response.statusCode == 201) {
          return Right(true);
        } else {
          return Left(response.data['message']);
        }
      }
    } catch (e) {
      return Left(e.toString());
    }
  }
}
