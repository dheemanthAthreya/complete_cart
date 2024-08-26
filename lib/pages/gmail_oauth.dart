import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:googleapis/gmail/v1.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:url_launcher/url_launcher.dart';

class GmailOAuth {
  static const _scopes = [GmailApi.gmailSendScope];

  static Future<AuthClient> getAuthenticatedClient() async {
    final clientId = ClientId(
      '21810832402-g93l0h18tquf07o034som6edsdsoenno.apps.googleusercontent.com',
      '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',
    );

    // Open URL for user consent
    Future<void> openUrl(String url) async {
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Could not launch $url';
      }
    }

    // Obtain the authenticated client using user consent
    final client = await clientViaUserConsent(clientId, _scopes, openUrl);
    return client;
  }

  // Send email
  static Future<void> sendEmail({
    required String to,
    required String subject,
    required String body,
  }) async {
    try {
      final client = await getAuthenticatedClient();
      final gmailApi = GmailApi(client);

      final message = '''
From: me
To: $to
Subject: $subject

$body
''';

      final encodedMessage = base64Url.encode(utf8.encode(message));

      await gmailApi.users.messages.send(
        Message(raw: encodedMessage),
        'me',
      );

      client.close();
      print('Email sent successfully');
    } catch (e) {
      print('Error sending email: $e');
    }
  }
}
