import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

class SamplePostRepository {
  /// Loads sample post data from a JSON file in the assets folder.
  Future<List<Map<String, String>>> loadSamplePosts() async {
    final data = await rootBundle.loadString(
      'lib/assets/data/sample_post_data.json',
    );
    final List<dynamic> jsonResult = json.decode(data);
    return jsonResult.map((e) => Map<String, String>.from(e)).toList();
  }
}
