import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'notifiers/article_notifier.dart';
import 'models/article.dart';

final articleProvider = StateNotifierProvider<ArticleNotifier, List<ArticleModel>>((ref) => ArticleNotifier());