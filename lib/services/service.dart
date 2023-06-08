import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:teknoek/models/category_model.dart';
import 'package:teknoek/models/login_model.dart';
import 'package:teknoek/models/news_model.dart';
import 'package:teknoek/models/user_model.dart';

class Service {
  final String baseUrl = "https://news-api-yek.onrender.com/api/";

  final dio = Dio();

  // Parse JWT token
  Future<UserModel?> parseJwt(String token) async {
    final token = await getToken();
    if (token == null) return null;

    dio.options.headers['authorization'] = 'Bearer $token';
    final response = await dio.get("${baseUrl}auth/check-token");
    if (response.data['status'] == 200) {
      print("service.checkToken.message: ${response.data['message']}");
      return UserModel.fromJson(response.data['user']);
    } else {
      print("service.checkToken.message: ${response.data['message']}");
      return null;
    }
  }

  // Register user
  Future<Map<String, dynamic>> register({
    required String fullName,
    required String email,
    required String password,
  }) async {
    final payload = {
      "fullName": fullName,
      "email": email,
      "password": password
    };
    final response = await dio.post("${baseUrl}auth/register", data: payload);

    if (response.statusCode == 200) {
      Map<String, dynamic> res = {
        "status": response.data['status'],
        "message": response.data['message'],
      };

      return res;
    } else {
      // if status code is not 200, return null
      throw ("Register failed with status code: ${response.statusCode}");
    }
  }

  // Login user
  Future<LoginModel?> login({
    required String email,
    required String password,
  }) async {
    final payload = {"email": email, "password": password};
    final response = await dio.post("${baseUrl}auth/login", data: payload);

    if (response.statusCode == 200) {
      // if status code is 200, return LoginModel
      final token = response.data['token'] ?? '';
      await saveToken(token);
      return LoginModel.fromJson(response.data);
    } else {
      // if status code is not 200, return null
      throw ("Login failed with status code: ${response.statusCode}");
    }
  }

  // Get categories
  Future<List<CategoryModel>> getAllCategories() async {
    final token = await getToken();
    if (token == null) return [];

    dio.options.headers['authorization'] = 'Bearer $token';

    final response = await dio.get("${baseUrl}categories");
    if (response.statusCode != 200) {
      throw ("Get categories failed with status code: ${response.statusCode}");
    }
    // if status is not 200, return empty list
    if (response.data['status'] != 200) return [];

    // if status is 200, return categories list
    List jsonNewsList = response.data['categories'];
    return jsonNewsList
        .map((categories) => CategoryModel.fromJson(categories))
        .toList();
  }

  // Get news list
  Future<List<NewsModel>> getAllNews() async {
    final token = await getToken();
    if (token == null) return [];

    dio.options.headers['authorization'] = 'Bearer $token';

    final response = await dio.get("${baseUrl}news");
    if (response.statusCode != 200) {
      throw ("Get news failed with status code: ${response.statusCode}");
    }
    // if status is not 200, return empty list
    if (response.data['status'] != 200) return [];

    // if status is 200, return news list
    List jsonNewsList = response.data['news'];
    var list = jsonNewsList.map((news) => NewsModel.fromJson(news)).toList();

    return list;
  }

  // Get breaking news list
  Future<List<NewsModel>> getBreakingNews() async {
    final token = await getToken();
    if (token == null) return [];

    dio.options.headers['authorization'] = 'Bearer $token';

    final response = await dio.get("${baseUrl}breaking-news");
    if (response.statusCode != 200) {
      throw ("Get news failed with status code: ${response.statusCode}");
    }
    // if status is not 200, return empty list
    if (response.data['status'] != 200) return [];

    // if status is 200, return news list
    List jsonNewsList = response.data['news'];
    return jsonNewsList.map((news) => NewsModel.fromJson(news)).toList();
  }

  // Get Hot news list
  Future<List<NewsModel>> getHotNews() async {
    final token = await getToken();
    if (token == null) return [];

    dio.options.headers['authorization'] = 'Bearer $token';

    final response = await dio.get("${baseUrl}hot-news");
    if (response.statusCode != 200) {
      throw ("Get news failed with status code: ${response.statusCode}");
    }
    // if status is not 200, return empty list
    if (response.data['status'] != 200) return [];

    // if status is 200, return news list
    List jsonNewsList = response.data['news'];
    return jsonNewsList.map((news) => NewsModel.fromJson(news)).toList();
  }

  // Get news by category
  Future<List<NewsModel>> getNewsByCategory(String categoryId) async {
    final token = await getToken();
    if (token == null) return [];

    dio.options.headers['authorization'] = 'Bearer $token';

    final response = await dio.get("${baseUrl}news/category/$categoryId");
    if (response.statusCode != 200) {
      throw ("Get news failed with status code: ${response.statusCode}");
    }
    // if status is not 200, return empty list
    if (response.data['status'] != 200) return [];

    // if status is 200, return news list
    List jsonNewsList = response.data['news'];
    var list = jsonNewsList.map((news) => NewsModel.fromJson(news)).toList();

    return list;
  }

  // Get single news
  Future<NewsModel?> getSingleNews(String id) async {
    final token = await getToken();
    if (token == null) return null;

    dio.options.headers['authorization'] = 'Bearer $token';

    final response = await dio.get("${baseUrl}news/$id");
    if (response.statusCode == 200) {
      if (response.data['status'] == 200) {
        return NewsModel.fromJson(response.data['news']);
      } else {
        return null;
      }
    } else {
      throw ("Get news failed with status code: ${response.statusCode}");
    }
  }

  // Save token to shared preferences
  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('userToken', token);
  }

  // Get token from shared preferences
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('userToken');
  }

  // Delete token from shared preferences
  Future<void> deleteToken() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('userToken');
  }

  // Check if token is valid and then user is exists
  Future<bool> checkToken() async {
    final token = await getToken();
    if (token == null) return false;

    dio.options.headers['authorization'] = 'Bearer $token';
    final response = await dio.get("${baseUrl}auth/check-token");
    if (response.data['status'] == 200) {
      print("service.checkToken.message: ${response.data['message']}");
      return true;
    } else {
      print("service.checkToken.message: ${response.data['message']}");
      return false;
    }
  }

  //   Popup message
  void popupBox(BuildContext context, title, message, Function isClickOk,
      [btnText = 'OK']) {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            onPressed: () => isClickOk(),
            child: Text(btnText),
          ),
        ],
      ),
    );
  }

  // TR
  timeTr(String dateTime, {bool numberDate = true}) {
    DateTime date = DateTime.parse(dateTime);
    final dateNow =
        DateTime.now().add(Duration(hours: 3)); // Conver to Istanbul Time
    final difference = dateNow.difference(date);
    if ((difference.inDays / 365).floor() >= 2) {
      return '${(difference.inDays / 365).floor()} Yıl Önce';
    } else if ((difference.inDays / 365).floor() >= 1) {
      return (numberDate) ? '1 Yıl Önce' : 'Yıl Önce';
    } else if ((difference.inDays / 30).floor() >= 2) {
      return '${(difference.inDays / 30).floor()} Ay Önce';
    } else if ((difference.inDays / 30).floor() >= 1) {
      return (numberDate) ? '1 Ay Önce' : 'Ay Önce';
    } else if ((difference.inDays / 7).floor() >= 2) {
      return '${(difference.inDays / 7).floor()} Hafta Önce';
    } else if ((difference.inDays / 7).floor() >= 1) {
      return (numberDate) ? '1 Hafta Önce' : 'Hafta Önce';
    } else if (difference.inDays >= 2) {
      return '${difference.inDays} Gün Önce';
    } else if (difference.inDays >= 1) {
      return (numberDate) ? '1 Gün Önce' : 'Dün';
    } else if (difference.inHours >= 2) {
      return '${difference.inHours} Saat Önce';
    } else if (difference.inHours >= 1) {
      return (numberDate) ? '1 Saat Önce' : 'Saat Önce';
    } else if (difference.inMinutes >= 2) {
      return '${difference.inMinutes} Dakika Önce';
    } else if (difference.inMinutes >= 1) {
      return (numberDate) ? '1 Dakika Önce' : 'Dakika Önce';
    } else if (difference.inSeconds >= 3) {
      return '${difference.inSeconds} Saniye Önce';
    } else {
      return 'Şimdi';
    }
  }
}
