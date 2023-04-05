import 'package:flutter/material.dart';

class ArticlePage extends StatelessWidget {
  static const String routeName = '/article';

  const ArticlePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(children: [
        Text('Title here'), //image here, content next
      ]),
    );
  }
}
