import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_shopping_app/controllers/login_provider.dart';
import 'package:flutter_shopping_app/models/auth/login_model.dart';
import 'package:flutter_shopping_app/views/shared/appstyle.dart';
import 'package:flutter_shopping_app/views/shared/custom_textfield.dart';
import 'package:flutter_shopping_app/views/shared/reusableText.dart';
import 'package:flutter_shopping_app/views/ui/auth/register.dart';
import 'package:flutter_shopping_app/views/ui/mainscreen.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  bool validation = false;

  void formValidation() {
    if (email.text.isNotEmpty && password.text.isNotEmpty) {
      validation = true;
    } else {
      validation = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    var authNotifier = Provider.of<LoginNotifier>(context);
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        elevation: 0,
        toolbarHeight: 50.h,
        backgroundColor: Colors.black,
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            ReusableText(
              text: "Welcome!",
              style: appstyle(30, Colors.white, FontWeight.w600),
            ),
            ReusableText(
              text: "Fill in your details to login into your account!",
              style: appstyle(14, Colors.white, FontWeight.normal),
            ),
            SizedBox(
              height: 50.h,
            ),
            CustomTextField(
                keyboard: TextInputType.emailAddress,
                validator: (email) {
                  if (email!.isEmpty || !email.contains("@")) {
                    return "Please provide valid email";
                  } else {
                    return null;
                  }
                },
                hintText: "Email",
                controller: email),
            SizedBox(
              height: 15.h,
            ),
            CustomTextField(
              validator: (password) {
                if (password!.isEmpty || password.length < 6) {
                  return "Password too weak";
                } else {
                  return null;
                }
              },
              suffixIcon: GestureDetector(
                onTap: () {
                  authNotifier.isObsecure = !authNotifier.isObsecure;
                },
                child: authNotifier.isObsecure ? const Icon(Icons.visibility) : const Icon(Icons.visibility_off),
              ),
              obscureText: !authNotifier.isObsecure,
              // Reverse the logic for initial obscurity
              hintText: "Password",
              controller: password,
            ),
            SizedBox(
              height: 10.h,
            ),
            Align(
              alignment: Alignment.centerRight,
              child: GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const Register()));
                },
                child: ReusableText(
                  text: 'Register',
                  style: appstyle(14, Colors.white, FontWeight.normal),
                ),
              ),
            ),
            SizedBox(
              height: 40.h,
            ),
            GestureDetector(
              onTap: () {
                formValidation();
                if (validation) {
                  // print('Login button tapped with email: ${email.text} and password: ${password.text}');
                  LoginModel model = LoginModel(email: email.text, password: password.text);
                  authNotifier.userLogin(model).then((response) {
                    if (response == true) {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => MainScreen()));
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Failed to login!, Please check the information again.'),
                        ),
                      );
                    }
                  });
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please enter complete information!'),
                    ),
                  );
                }
              },
              child: Container(
                height: 55.h,
                width: 300.w,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
                child: Center(
                  child: ReusableText(
                    text: "L O G I N",
                    style: appstyle(18, Colors.black, FontWeight.bold),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
