// lib/data/services/api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // REMOVE THE TRAILING SPACE ↓↓↓↓↓↓↓↓↓
  static const String baseUrl = 'https://jsonplaceholder.typicode.com';

  Future<List<dynamic>> fetchPosts() async {
    print("🟡 [ApiService] call fetchPosts");
    print("🟡 [ApiService] Sending HTTP GET to $baseUrl/posts");

    try {
      final response = await http
          .get(Uri.parse('$baseUrl/posts'))
          .timeout(const Duration(seconds: 10));

      print("🟢 [ApiService] Response received: ${response.statusCode}");
      print("🟢 [ApiService] Body length: ${response.body.length}");

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        print("🟢 [ApiService] Decoded ${decoded.length} items");
        return decoded;
      } else {
        print("🔴 [ApiService] HTTP Error: ${response.statusCode}");
        throw Exception('HTTP ${response.statusCode}');
      }
    } catch (e) {
      print("🔴 [ApiService] Request failed: $e");
      rethrow;
    }
  }
}
