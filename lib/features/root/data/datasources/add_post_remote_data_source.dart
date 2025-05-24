import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:offgrid_nation_app/core/session/auth_session.dart';
import 'package:offgrid_nation_app/core/constants/api_constants.dart';

class AddPostRemoteDataSource {
  final AuthSession authSession;

  AddPostRemoteDataSource({required this.authSession});

  Future<Map<String, dynamic>> createPost({
    required String content,
    String? location,
    List<File>? mediaFiles,
  }) async {
    final token = await authSession.getSessionToken();
    if (token == null) throw Exception("Unauthorized");

    final uri = Uri.parse('${ApiConstants.baseUrl}/post');
    print("------------uri-------------- $uri");
    final request =
        http.MultipartRequest('POST', uri)
          ..headers['Authorization'] = 'Bearer $token'
          ..fields['content'] = content;

    print("-------------request------------ $request");

    if (location != null) {
      request.fields['location'] = location;
    }

    if (mediaFiles != null && mediaFiles.isNotEmpty) {
      for (var file in mediaFiles) {
        final fileStream = http.ByteStream(file.openRead());
        final length = await file.length();
        final multipartFile = http.MultipartFile(
          'media',
          fileStream,
          length,
          filename: file.path.split('/').last,
        );
        request.files.add(multipartFile);
      }
    }

    final response = await request.send();
    print("------------response-------------- $response");
    final responseBody = await http.Response.fromStream(response);
    print(
      '---------jsonDecode(responseBody.body)-------- ${jsonDecode(responseBody.body)}',
    );
    if (response.statusCode == 201) {
      return jsonDecode(responseBody.body);
    } else {
      throw Exception('Failed to create post: ${responseBody.body}');
    }
  }
}
