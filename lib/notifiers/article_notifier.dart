import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:http/http.dart' as http;

import '../models/article.dart';
import '../models/api_response.dart';

class ArticleNotifier extends StateNotifier<List<ArticleModel>> {
  ArticleNotifier() : super([]);

  Future<void> fetchArticles() async {
    final Uri url = Uri.https('newsdata.io', '/api/1/news', {
      'apiKey': 'pub_200613bc00f4a121993df42f34ba9a057e156',
      'country': 'us,ng'
    });

    try {
      final response = await http.get(url);
      final decodedResponse = jsonDecode(response.body);
      final responseInstance = APIResponse.fromJson(decodedResponse);

      state = responseInstance.results;
      debugPrint(responseInstance.status);
    } on Exception catch (e) {
      rethrow;
    }
  }
}
