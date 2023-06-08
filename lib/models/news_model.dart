class NewsModel {
/*
{
  "_id": "638e59d01266bc8558d2ea1f",
  "categoryId": null,
  "title": "Test News",
  "description": "Lorem ipsum dolor sit amet.",
  "img": "https://assets.justinmind.com/wp-content/uploads/2019/10/best-20-web-development-blogs.png",
  "date": "2022-12-05T20:51:28.804Z",
  "__v": 0
} 
*/

  String? id;
  String? categoryId;
  String? title;
  String? description;
  String? img;
  String? date;
  int? hits;
  String? v;

  NewsModel({
    this.id,
    this.categoryId,
    this.title,
    this.description,
    this.img,
    this.date,
    this.hits,
    this.v,
  });
  NewsModel.fromJson(Map<String, dynamic> json) {
    id = json['_id']?.toString();
    categoryId = json['categoryId']?.toString();
    title = json['title']?.toString();
    description = json['description']?.toString();
    img = json['img']?.toString();
    date = json['date']?.toString();
    hits = json['hits']?.toInt();
    v = json['__v']?.toString();
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['_id'] = id;
    data['categoryId'] = categoryId;
    data['title'] = title;
    data['description'] = description;
    data['img'] = img;
    data['date'] = date;
    data['hits'] = hits;
    data['__v'] = v;
    return data;
  }
}
