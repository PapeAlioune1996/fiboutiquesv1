
import 'dart:convert';
import 'package:flutter_termii/flutter_termii.dart';

import 'network_helper.dart';

class Termii {
 
  final String url;

  final String apiKey;

  final String senderId;

  Termii({
    required this.url,
    required this.apiKey,
    required this.senderId,
  });

  
  Future<dynamic> sendToken({
  required String destination,

   required MessageType messageType,
    String channel = 'generic',
    required int pinAttempts,

    required int pinExpiryTime,

   required int pinLength,

   required String pinPlaceholder,
required String messageText,

   required MessageType pinType,
  }) async {
    final response = await NetworkHelper.postRequest(
      url: "$url/api/sms/otp/send",
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'api_key': apiKey,
        'message_type':
            messageType == MessageType.numeric ? 'NUMERIC' : 'ALPHANUMERIC',
        'to': destination,
        'from': senderId,
        'channel': channel,
        'pin_attempts': pinAttempts,
        'pin_time_to_live': pinExpiryTime,
        'pin_length': pinLength,
        'pin_placeholder': pinPlaceholder,
        'message_text': messageText,
        'pin_type': pinType == MessageType.numeric ? 'NUMERIC' : 'ALPHANUMERIC',
      }),
    );
    return response.body;
  }
 }
