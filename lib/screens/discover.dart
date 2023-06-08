import 'package:flutter/material.dart';
import 'package:teknoek/models/category_model.dart';
import 'package:teknoek/models/news_model.dart';
import 'package:teknoek/screens/news_detail.dart';
import 'package:teknoek/services/service.dart';
import 'package:teknoek/widgets/bottom_navbar.dart';
import 'package:teknoek/widgets/image_container.dart';

class Discover extends StatefulWidget {
  const Discover({Key? key}) : super(key: key);

  @override
  State<Discover> createState() => _DiscoverState();
}

class _DiscoverState extends State<Discover> {
  bool isCategoriesLoading = true;
  List<CategoryModel> categories = [];

  @override
  void initState() {
    // Get all categories then set the categories state
    Service().getAllCategories().then((categoryList) {
      if (categoryList != []) {
        setState(() {
          categories = categoryList;
        });
      } else {
        print('No categories found');
      }
      setState(() {
        isCategoriesLoading = false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return isCategoriesLoading
        ? Scaffold(
            body: const Center(child: CircularProgressIndicator()),
            bottomNavigationBar: const BottomNavBar(index: 1),
          )
        : DefaultTabController(
            initialIndex: 0,
            length: categories.length,
            child: Scaffold(
              bottomNavigationBar: const BottomNavBar(index: 1),
              body: ListView(
                padding: const EdgeInsets.all(20.0),
                children: [
                  const _DiscoverNews(),
                  _CategoryNews(tabs: categories)
                ],
              ),
            ),
          );
  }
}

class _CategoryNews extends StatefulWidget {
  const _CategoryNews({
    Key? key,
    required this.tabs,
  }) : super(key: key);

  final List<CategoryModel> tabs;

  @override
  State<_CategoryNews> createState() => _CategoryNewsState();
}

class _CategoryNewsState extends State<_CategoryNews> {
  bool isNewsBycategoryLoading = true;

  Map<String, List<NewsModel>> newsListByCategory = {};

  @override
  void initState() {
    for (var category in widget.tabs) {
      Service().getNewsByCategory(category.id.toString()).then((newsList) {
        if (newsList != []) {
          setState(() {
            newsListByCategory[category.id.toString()] = newsList;
          });

          // Check if all categories are loaded
          if (newsListByCategory.length == widget.tabs.length) {
            setState(() {
              isNewsBycategoryLoading = false;
            });
          }
        } else {
          print('No news found');
        }
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    setState(() {});
    return Column(
      children: [
        TabBar(
            isScrollable: true,
            indicatorColor: Colors.black,
            tabs: widget.tabs
                .map((tab) => Tab(
                      icon: Text(
                        tab.title.toString(),
                        style: Theme.of(context)
                            .textTheme
                            .headlineSmall!
                            .copyWith(fontWeight: FontWeight.bold),
                      ),
                    ))
                .toList()),
        SizedBox(
          height: MediaQuery.of(context).size.height * .6,
          child: isNewsBycategoryLoading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : TabBarView(
                  children: widget.tabs
                      .map((tab) => ListView.builder(
                            shrinkWrap: true,
                            itemCount:
                                newsListByCategory[tab.id.toString()]!.length,
                            itemBuilder: ((context, index) {
                              return InkWell(
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => SingleNewsDetail(
                                            newsId: newsListByCategory[
                                                    tab.id.toString()]![index]
                                                .id
                                                .toString(),
                                          )));
                                },
                                child: Row(
                                  children: [
                                    SizedBox(
                                      height: 100,
                                    ),
                                    ImageContainer(
                                        width: 120,
                                        height: 80,
                                        margin: const EdgeInsets.all(10.0),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10.0)),
                                        imageUrl: newsListByCategory[
                                                tab.id.toString()]![index]
                                            .img
                                            .toString()),
                                    Expanded(
                                      child: Container(
                                        margin:
                                            const EdgeInsets.only(left: 10.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              newsListByCategory[
                                                      tab.id.toString()]![index]
                                                  .title
                                                  .toString(),
                                              maxLines: 2,
                                              overflow: TextOverflow.clip,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyLarge!
                                                  .copyWith(
                                                      fontWeight:
                                                          FontWeight.bold),
                                            ),
                                            const SizedBox(height: 10),
                                            Row(
                                              children: [
                                                const Icon(
                                                  Icons.schedule,
                                                  size: 18,
                                                ),
                                                const SizedBox(width: 5),
                                                Text(
                                                  Service().timeTr(
                                                      newsListByCategory[tab.id
                                                                  .toString()]![
                                                              index]
                                                          .date
                                                          .toString()),
                                                  style: const TextStyle(
                                                      fontSize: 12),
                                                ),
                                                const SizedBox(width: 20),
                                                const Icon(
                                                  Icons.visibility,
                                                  size: 18,
                                                ),
                                                const SizedBox(width: 5),
                                                Text(
                                                  newsListByCategory[tab.id
                                                          .toString()]![index]
                                                      .hits
                                                      .toString(),
                                                  style: const TextStyle(
                                                      fontSize: 12),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }),
                          ))
                      .toList(),
                ),
        )
      ],
    );
  }
}

class _DiscoverNews extends StatelessWidget {
  const _DiscoverNews({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Keşfet',
              style: Theme.of(context)
                  .textTheme
                  .headlineMedium!
                  .copyWith(color: Colors.black, fontWeight: FontWeight.bold)),
          const SizedBox(height: 5),
          Text('Dünyanın her yerinden teknoloji haberleri',
              style: Theme.of(context).textTheme.bodySmall),
        ],
      ),
    );
  }
}
