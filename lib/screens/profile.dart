import 'package:flutter/material.dart';
import 'package:teknoek/models/user_model.dart';
import 'package:teknoek/screens/login.dart';
import 'package:teknoek/services/service.dart';
import 'package:teknoek/widgets/bottom_navbar.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<StatefulWidget> createState() => InitState();
}

class InitState extends State<Profile> {
  bool isProfileLoading = true;
  UserModel user = UserModel();

  @override
  void initState() {
    Service().getToken().then((token) {
      Service().parseJwt(token.toString()).then((res) {
        if (res == null) {
          return Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => LoginScreen()),
              (Route<dynamic> route) => false);
        } else {
          // Set state if response is not empty
          setState(() {
            user = res;
          });
        }
        setState(() {
          isProfileLoading = false;
        });
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return isProfileLoading
        ? Scaffold(
            body: const Center(
              child: CircularProgressIndicator(),
            ),
          )
        : Scaffold(
            bottomNavigationBar: BottomNavBar(index: 2),
            body: SingleChildScrollView(
                child: Column(
              children: [
                Container(
                  height: 300,
                  decoration: const BoxDecoration(
                    borderRadius:
                        BorderRadius.only(bottomLeft: Radius.circular(90)),
                    color: Color(0xff222324),
                    gradient: LinearGradient(
                      colors: [(Color(0xff222324)), Color(0xff47494a)],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                  child: Center(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 75),
                        child: Image.asset(
                          "assets/images/logo.png",
                          height: 100,
                          width: 100,
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(right: 20, top: 20),
                        alignment: Alignment.bottomRight,
                        child: const Text(
                          "Kullanıcı Bilgileri",
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        ),
                      )
                    ],
                  )),
                ),
                Container(
                  alignment: Alignment.center,
                  margin: const EdgeInsets.only(left: 20, right: 20, top: 110),
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  height: 54,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: Colors.grey[200],
                    boxShadow: const [
                      BoxShadow(
                          offset: Offset(0, 10),
                          blurRadius: 50,
                          color: Color(0xffEEEEEE)),
                    ],
                  ),
                  child: TextFormField(
                    initialValue: user.fullName,
                    enabled: false,
                    cursorColor: const Color(0xff222324),
                    decoration: const InputDecoration(
                      icon: Icon(
                        Icons.person,
                        color: Color(0xff222324),
                      ),
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  margin: const EdgeInsets.only(left: 20, right: 20, top: 20),
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  height: 54,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: Colors.grey[200],
                    boxShadow: const [
                      BoxShadow(
                          offset: Offset(0, 10),
                          blurRadius: 50,
                          color: Color(0xffEEEEEE)),
                    ],
                  ),
                  child: TextFormField(
                    initialValue: user.email,
                    enabled: false,
                    cursorColor: const Color(0xff222324),
                    decoration: const InputDecoration(
                      icon: Icon(
                        Icons.email,
                        color: Color(0xff222324),
                      ),
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    // remove user token from storage
                    Service().deleteToken();
                    // navigate to login screen
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (context) => LoginScreen()),
                        (Route<dynamic> route) => false);
                  },
                  child: Container(
                    alignment: Alignment.center,
                    margin: const EdgeInsets.only(left: 20, right: 20, top: 90),
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    height: 54,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                          colors: [(Color(0xff222324)), Color(0xff47494a)],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight),
                      borderRadius: BorderRadius.circular(50),
                      color: Colors.grey[200],
                      boxShadow: const [
                        BoxShadow(
                            offset: Offset(0, 10),
                            blurRadius: 50,
                            color: Color(0xffEEEEEE)),
                      ],
                    ),
                    child: Text(
                      "ÇIKIŞ YAP",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            )));
  }
}
