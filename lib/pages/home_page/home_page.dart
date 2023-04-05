import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wiseki/pages/article_page/article_page.dart';

import '../../models/article.dart';
import '../../providers.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  List<ArticleModel> _allArticles = [];
  final List<Map<String, dynamic>> _bottomNavBarItems = [
    {'icon': Icons.home, 'label': 'Home'},
    {'icon': Icons.bookmark, 'label': 'Bookmarks'},
    {'icon': Icons.person, 'label': 'Profile'}
  ];
  final TextEditingController _searchController = TextEditingController();

  bool _isPromptEmpty = true;
  bool _isLoading = true;

  void _searchForArticle() {}

  void _fetchArticles() async {
    await ref.read(articleProvider.notifier).fetchArticles();

    setState(() {
      _allArticles = ref.read(articleProvider);
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchArticles();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);

    return Scaffold(
        body: SafeArea(
          child: Container(
            height: size.height,
            width: size.width,
            padding: EdgeInsets.symmetric(horizontal: size.width * 0.06),
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : Column(children: [
                    Align(
                      alignment: Alignment.topCenter,
                      child: _AppBar(
                          searchFunc: _searchForArticle,
                          controller: _searchController),
                    ),
                    Expanded(child: SizedBox(child: _HomeBody(_allArticles))),
                  ]),
          ),
        ),
        bottomNavigationBar: Container(
          height: size.height * 0.06,
          width: size.width,
          child: Row(
              children: _bottomNavBarItems.map((currentIndex) {
            return Expanded(
              child: SizedBox(
                child: Column(
                  children: [
                    Icon(
                      currentIndex['icon'],
                      color: (currentIndex['label'] == 'Home')
                          ? Colors.green
                          : Colors.black,
                    ),
                    Text(
                      currentIndex['label'],
                      style: TextStyle(
                        color: (currentIndex['label'] == 'Home')
                            ? Colors.green
                            : Colors.black,
                      ),
                    )
                  ],
                ),
              ),
            );
          }).toList()),
        ));
  }
}

class _AppBar extends StatelessWidget {
  final Function searchFunc;
  final TextEditingController controller;

  const _AppBar({Key? key, required this.searchFunc, required this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Hi Victoria,',
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                  Text('Good Morning!',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                ],
              ),
              CircleAvatar(
                backgroundImage: const AssetImage('/assets/user.png'),
                onBackgroundImageError: (exception, stackTrace) =>
                    const Icon(Icons.person),
              )
            ],
          ),
          Row(
            children: [
              Expanded(
                  child: TextFormField(
                controller: controller,
                decoration: InputDecoration(
                    fillColor: Colors.white,
                    focusColor: Colors.white,
                    hintText: 'Search...',
                    border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(8))),
              )),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8))),
                onPressed: () {
                  searchFunc();
                },
                child: const Icon(
                  Icons.search,
                  color: Colors.white,
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}

class _HomeBody extends StatefulWidget {
  final List<ArticleModel> allArticles;

  const _HomeBody(this.allArticles, {Key? key}) : super(key: key);

  @override
  State<_HomeBody> createState() => _HomeBodyState();
}

class _HomeBodyState extends State<_HomeBody> {
  @override
  Widget build(BuildContext context) {
    debugPrint(widget.allArticles.length.toString());
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Daily News',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        SizedBox(
          height: MediaQuery.sizeOf(context).height * 0.05,
          child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 0,
              itemBuilder: (ctx, index) {
                //todo: connect to categories provider
                return null;
              }),
        ),
        Expanded(
          child: SizedBox(
            child: ListView.builder(
                shrinkWrap: true,
                itemCount: widget.allArticles.length,
                itemBuilder: (ctx, index) {
                  final currentIndex = widget.allArticles[index];

                  return _ArticleItem(
                    title: currentIndex.title,
                    authors: currentIndex.creator ?? [],
                    date: currentIndex.pubDate,
                    image: currentIndex.image_url,
                  );
                }),
          ),
        ),
      ],
    );
  }
}

class _ArticleItem extends StatelessWidget {
  final String title;
  final List authors;
  final DateTime date;
  final String image;

  const _ArticleItem(
      {Key? key,
      required this.title,
      required this.authors,
      required this.date,
      required this.image})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed(ArticlePage.routeName);
      },
      child: Container(
        width: MediaQuery.sizeOf(context).width * 0.9,
        margin: const EdgeInsets.only(bottom: 10),
        child: Row(
          children: [
            Container(
              width: MediaQuery.sizeOf(context).width * 0.2,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: NetworkImage(image), fit: BoxFit.cover),
                  borderRadius: const BorderRadius.all(Radius.circular(8))),
            ),
            Expanded(
              child: SizedBox(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(title,
                        style: const TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w500),
                        textAlign: TextAlign.start,
                        softWrap: true),
                    Text( authors.isEmpty ?
                      date.toIso8601String() : '${date.toIso8601String()} - ${authors[0]}',
                      style: const TextStyle(color: Color(0xff8C8C8C)),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
