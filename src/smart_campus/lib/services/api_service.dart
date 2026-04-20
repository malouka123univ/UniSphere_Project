import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  //	Utilisation du protocole HTTP/REST
  //Fake Online REST API(fake server)
  static const String baseUrl = 'https://jsonplaceholder.typicode.com';

  Future<List<dynamic>> fetchPosts() async {
    //// Récupère la liste des publications (posts) depuis l'API de manière asynchrone.
    // Envoie la requête et attend la réponse du serveur de manière asynchrone
    final response = await http
        // Effectue un appel GET vers l'URL spécifiée (convertie en objet Uri)
        //La méthode HTTP pour récupérer des données.
        .get(Uri.parse('$baseUrl/posts'))
        //le temps exact pour app attender avant dire que  il ya un probleme de connex
        .timeout(const Duration(seconds: 10));

    if (response.statusCode == 200) {
      //TRANSFRE LES DONNER VER LIST OU MAPPING PIR TRITER
      return jsonDecode(response.body);
    } else {
      throw Exception('HTTP ${response.statusCode}');
    }
  }
}
