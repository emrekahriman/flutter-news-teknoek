import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:teknoek/models/news_model.dart';
import 'package:teknoek/services/service.dart';
import 'package:teknoek/widgets/custom_tag.dart';
import 'package:teknoek/widgets/cached_image_container.dart';
import 'dart:ui';

class SingleNewsDetail extends StatefulWidget {
  const SingleNewsDetail({super.key, required this.newsId});

  final String newsId;

  @override
  State<SingleNewsDetail> createState() => _SingleNewsDetailState();
}

class _SingleNewsDetailState extends State<SingleNewsDetail> {
  bool isSingleNewsLoading = true;
  NewsModel singleNews = NewsModel();

  @override
  void initState() {
    Service().getSingleNews(widget.newsId).then((res) {
      if (res != null) {
        setState(() {
          singleNews = res;
        });
      }
      setState(() {
        isSingleNewsLoading = false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return isSingleNewsLoading
        ? Scaffold(
            body: const Center(child: CircularProgressIndicator()),
          )
        : Scaffold(
            body: Scaffold(
              backgroundColor: Colors.black.withAlpha(100),
              appBar: AppBar(
                iconTheme: const IconThemeData(color: Colors.white),
                backgroundColor: Colors.transparent,
                elevation: 0,
              ),
              extendBodyBehindAppBar: true,
              body: Stack(
                children: [
                  CachedNetworkImageContainer(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      imageUrl: singleNews.img.toString(),
                      child: Container(
                        color: Colors.black.withAlpha(75),
                      )),
                  ClipRect(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                      child: ListView(
                        children: [
                          NewsHeadLine(
                            singleNews: singleNews,
                          ),
                          NewsDetailBody(
                            singleNews: singleNews,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}

class NewsHeadLine extends StatelessWidget {
  const NewsHeadLine({
    Key? key,
    required this.singleNews,
  }) : super(key: key);

  final NewsModel singleNews;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * .15,
            ),
            Text(
              singleNews.title.toString(),
              style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    height: 1.25,
                  ),
            ),
            SizedBox(
              height: 20.0,
            ),
          ]),
    );
  }
}

class NewsDetailBody extends StatelessWidget {
  const NewsDetailBody({
    Key? key,
    required this.singleNews,
  }) : super(key: key);

  final NewsModel singleNews;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(35.0),
            topRight: Radius.circular(35.0),
          ),
          color: Colors.white.withAlpha(200)),
      child: Column(children: [
        Row(
          children: [
            CustomTag(
                backgroundColor: Colors.black54.withAlpha(200),
                children: [
                  CircleAvatar(
                    radius: 12,
                    backgroundImage: NetworkImage(
                        'https://avatars.githubusercontent.com/u/59236526?s=120&v=4'),
                  ),
                  SizedBox(
                    width: 3,
                  ),
                  Text(
                    "EmreKhrmn",
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                  )
                ]),
            SizedBox(
              width: 5,
            ),
            CustomTag(backgroundColor: Colors.black.withAlpha(100), children: [
              Icon(
                Icons.timer,
                color: Colors.white.withAlpha(200),
              ),
              SizedBox(
                width: 3,
              ),
              Text(
                Service().timeTr(singleNews.date.toString()),
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      color: Colors.white.withAlpha(200),
                      fontWeight: FontWeight.normal,
                    ),
              )
            ]),
            SizedBox(
              width: 5,
            ),
            CustomTag(backgroundColor: Colors.black.withAlpha(100), children: [
              Icon(
                Icons.remove_red_eye,
                color: Colors.white.withAlpha(200),
              ),
              SizedBox(
                width: 3,
              ),
              Text(
                singleNews.hits.toString(),
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      color: Colors.white.withAlpha(200),
                      fontWeight: FontWeight.normal,
                    ),
              )
            ]),
          ],
        ),
        SizedBox(
          height: 20,
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            singleNews.title.toString(),
            style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
          ),
        ),
        SizedBox(
          height: 30,
        ),
        Text(
          singleNews.description.toString(),
          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                fontSize: 16,
                height: 1.5,
              ),
        ),
        SizedBox(
          height: 30,
        ),
        ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(15)),
          child: CachedNetworkImage(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * .3,
            fit: BoxFit.cover,
            imageUrl: singleNews.img.toString(),
            placeholder: (context, url) => const Center(
                child: CircularProgressIndicator(
              color: Colors.black,
            )),
            errorWidget: (context, url, error) =>
                const Center(child: Icon(Icons.error)),
          ),
        ),
      ]),
    );
  }
}
