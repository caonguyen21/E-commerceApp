import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_shopping_app/models/auth/signup_model.dart';
import 'package:flutter_shopping_app/views/ui/auth/login.dart';
import 'package:provider/provider.dart';

import '../../../controllers/login_provider.dart';
import '../../shared/appstyle.dart';
import '../../shared/custom/custom_textfield.dart';
import '../../shared/reusableText.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  TextEditingController username = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  bool validation = false;

  void formValidation() {
    if (email.text.isNotEmpty && password.text.isNotEmpty && username.text.isNotEmpty) {
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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            ReusableText(
              text: "Hello!",
              style: appstyle(30, Colors.white, FontWeight.w600),
            ),
            ReusableText(
              text: "Fill in your details to sign up for an account!",
              style: appstyle(14, Colors.white, FontWeight.normal),
            ),
            SizedBox(
              height: 50.h,
            ),
            CustomTextField(
                keyboard: TextInputType.emailAddress,
                validator: (username) {
                  if (username!.isEmpty) {
                    return "Please provide username";
                  } else {
                    return null;
                  }
                },
                hintText: "Username",
                controller: username),
            SizedBox(
              height: 15.h,
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
                  Navigator.pop(context);
                },
                child: ReusableText(
                  text: 'Login',
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
                  SignupModel model = SignupModel(username: username.text, email: email.text, password: password.text);
                  authNotifier.registerUser(model).then((response) {
                    if (response == true) {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginPage()));
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Account already exists!'),
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
                    text: "S I G N U P",
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
