class CategoryModel {
/*
{
  "_id": "6391303d2dcfcbf180039798",
  "title": "Apple News",
  "description": "Apple News Category."
} 
*/

  String? id;
  String? title;
  String? description;

  CategoryModel({
    this.id,
    this.title,
    this.description,
  });
  CategoryModel.fromJson(Map<String, dynamic> json) {
    id = json['_id']?.toString();
    title = json['title']?.toString();
    description = json['description']?.toString();
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['_id'] = id;
    data['title'] = title;
    data['description'] = description;
    return data;
  }
}
