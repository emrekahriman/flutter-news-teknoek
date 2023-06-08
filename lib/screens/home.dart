import 'package:flutter/material.dart';
import 'package:teknoek/models/news_model.dart';
import 'package:teknoek/screens/news_detail.dart';
import 'package:teknoek/services/service.dart';
import 'package:teknoek/widgets/bottom_navbar.dart';
import 'package:teknoek/widgets/custom_tag.dart';
import 'package:teknoek/widgets/cached_image_container.dart';
import 'package:teknoek/widgets/image_container.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool isLoading = true;
  List<NewsModel> globalNewsList = [];

  @override
  void initState() {
    Service().getHotNews().then((newsList) {
      if (newsList != []) {
        setState(() {
          globalNewsList = newsList;
        });
      } else {
        print('No news found');
      }
      setState(() {
        isLoading = false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                _NewsOfTheDay(singleNews: globalNewsList[0]),
                Container(
                  color: Colors.white,
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 20.0,
                      ),
                      //   newsListBuilder(),
                      _BreakingNews(newsList: globalNewsList)
                    ],
                  ),
                ),
              ],
            ),
      bottomNavigationBar: const BottomNavBar(index: 0),
    );
  }

  Widget newsListBuilder() {
    return ListView.builder(
        shrinkWrap: true,
        itemCount: globalNewsList.length,
        itemBuilder: (context, index) {
          return ListTile(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => SingleNewsDetail(
                      newsId: globalNewsList[index].id.toString()),
                ),
              );
            },
            title: Text(globalNewsList[index].title.toString()),
            subtitle: Text(globalNewsList[index].description.toString()),
          );
        });
  }
}

class _NewsOfTheDay extends StatelessWidget {
  const _NewsOfTheDay({
    Key? key,
    required this.singleNews,
  }) : super(key: key);

  final NewsModel singleNews;

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImageContainer(
      height: MediaQuery.of(context).size.height * 0.45,
      width: double.infinity,
      padding: const EdgeInsets.all(20.0),
      imageUrl: singleNews.img.toString(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomTag(backgroundColor: Colors.white.withAlpha(175), children: [
            Icon(Icons.local_fire_department, color: Colors.red.shade700),
            SizedBox(width: 3),
            Text(
              'En çok okunan haber',
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  color: Colors.red.shade700, fontWeight: FontWeight.bold),
            )
          ]),
          const SizedBox(height: 10),
          Flexible(
            child: Text(singleNews.title.toString(),
                style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                      fontWeight: FontWeight.bold,
                      height: 1.25,
                      color: Colors.white,
                    ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis),
          ),
          TextButton(
              onPressed: () {},
              style: TextButton.styleFrom(padding: EdgeInsets.zero),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => SingleNewsDetail(
                              newsId: singleNews.id.toString()),
                        ),
                      );
                    },
                    child: Row(
                      children: [
                        Text(
                          'Haberi Görüntüle',
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge!
                              .copyWith(color: Colors.white),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        const Icon(
                          Icons.arrow_right_alt,
                          color: Colors.white,
                        )
                      ],
                    ),
                  ),
                ],
              ))
        ],
      ),
    );
  }
}

class _BreakingNews extends StatelessWidget {
  const _BreakingNews({
    Key? key,
    required this.newsList,
  }) : super(key: key);

  final List<NewsModel> newsList;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Popüler Haberler',
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall!
                    .copyWith(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 220,
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: newsList.length,
                itemBuilder: (context, index) {
                  return Container(
                    width: MediaQuery.of(context).size.width * 0.55,
                    margin: const EdgeInsets.only(right: 10),
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => SingleNewsDetail(
                                newsId: newsList[index].id.toString()),
                          ),
                        );
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ImageContainer(
                              width: MediaQuery.of(context).size.width * 0.55,
                              imageUrl: newsList[index].img.toString()),
                          const SizedBox(height: 10),
                          Text(
                            newsList[index].title.toString(),
                            maxLines: 2,
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge!
                                .copyWith(
                                    fontWeight: FontWeight.bold, height: 1.5),
                          ),
                          const SizedBox(height: 5),
                          Text(
                              Service().timeTr(newsList[index].date.toString()),
                              style: Theme.of(context).textTheme.bodySmall),
                          const SizedBox(height: 5),
                          Text('By Emrekhrmn',
                              style: Theme.of(context).textTheme.bodySmall),
                        ],
                      ),
                    ),
                  );
                }),
          )
        ],
      ),
    );
  }
}
