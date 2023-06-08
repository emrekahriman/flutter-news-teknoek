import 'package:flutter/material.dart';
import 'package:teknoek/screens/home.dart';
import 'package:teknoek/screens/register.dart';
import 'package:teknoek/services/service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<StatefulWidget> createState() => StartState();
}

class StartState extends State<LoginScreen> {
  bool isFormSubmitting = false;

  final formKey = GlobalKey<FormState>(); //key for form

  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return initWidget();
  }

  initWidget() {
    return Scaffold(
        body: SingleChildScrollView(
            child: Column(
      children: [
        Container(
          height: 250,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(bottomLeft: Radius.circular(90)),
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
                margin: const EdgeInsets.only(top: 50),
                child: Image.asset(
                  "assets/images/logo.png",
                  height: 100,
                  width: 100,
                ),
              ),
              Container(
                margin: const EdgeInsets.only(right: 20, top: 10),
                alignment: Alignment.bottomRight,
                child: const Text(
                  "Giriş Yap",
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.w400),
                ),
              )
            ],
          )),
        ),
        Form(
          key: formKey,
          child: Column(
            children: [
              Container(
                alignment: Alignment.center,
                margin: const EdgeInsets.only(left: 20, right: 20, top: 70),
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
                  controller: emailController,
                  validator: (value) {
                    if (value!.isEmpty ||
                        !RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                            .hasMatch(value)) {
                      return "Lütfen geçerli bir emal adresi girin!";
                    } else {
                      return null;
                    }
                  },
                  cursorColor: const Color(0xff222324),
                  decoration: const InputDecoration(
                    icon: Icon(
                      Icons.email,
                      color: Color(0xff222324),
                    ),
                    hintText: "Email adresinizi girin",
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                  ),
                ),
              ),
              Container(
                alignment: Alignment.center,
                margin: EdgeInsets.only(left: 20, right: 20, top: 20),
                padding: EdgeInsets.only(left: 20, right: 20),
                height: 54,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: const Color(0xffEEEEEE),
                  boxShadow: const [
                    BoxShadow(
                        offset: Offset(0, 20),
                        blurRadius: 100,
                        color: Color(0xffEEEEEE)),
                  ],
                ),
                child: TextFormField(
                  controller: passwordController,
                  obscureText: true,
                  enableSuggestions: false,
                  autocorrect: false,
                  validator: (value) {
                    if (value!.length < 5) {
                      return "Parola en az 5 karakter uzunluğunda olmalı!";
                    } else {
                      return null;
                    }
                  },
                  cursorColor: const Color(0xff222324),
                  decoration: const InputDecoration(
                    focusColor: Color(0xff222324),
                    icon: Icon(
                      Icons.vpn_key,
                      color: Color(0xff222324),
                    ),
                    hintText: "Şifrenizi girin",
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  // Write Click Listener Code Here.
                  if (formKey.currentState!.validate()) {
                    // is form validate
                    setState(() {
                      isFormSubmitting = true;
                    });
                    final service = Service();
                    service
                        .login(
                            email: emailController.text,
                            password: passwordController.text)
                        .then((res) async {
                      final status = res!.status;
                      final message = res.message;
                      if (status == 200) {
                        // navigate to home screen
                        Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(builder: (context) => Home()),
                            (Route<dynamic> route) => false);
                      } else {
                        Service().popupBox(
                            context, 'Login Failed', message.toString(), () {
                          Navigator.of(context).pop();
                        });
                      }
                      setState(() {
                        isFormSubmitting = false;
                      });
                    });
                  }
                },
                child: Container(
                  alignment: Alignment.center,
                  margin: const EdgeInsets.only(left: 20, right: 20, top: 40),
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
                  child: isFormSubmitting
                      ? const CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        )
                      : const Text(
                          "GİRİŞ YAP",
                          style: TextStyle(color: Colors.white),
                        ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Hesabın yok mu?  "),
                    GestureDetector(
                      child: const Text(
                        "Şimdi Oluştur",
                        style: TextStyle(
                            color: Color(0xff222324),
                            fontWeight: FontWeight.bold),
                      ),
                      onTap: () {
                        // Write Tap Code Here.
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RegisterScreen(),
                            ));
                      },
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ],
    )));
  }
}
