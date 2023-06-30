import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'home.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// login_screen.dart
// const users = const {
//   'dribbble@gmail.com': '12345',
//   'hunter@gmail.com': 'hunter',
//   'deu04189@gmail.com': '12345'
// };

class LoginScreen extends StatelessWidget {
  Duration get loginTime => Duration(milliseconds: 2250);
  const LoginScreen({Key? key}) : super(key: key);

  // Future<String?> _authUser(LoginData data) {
  //   debugPrint('Name: ${data.name}, Password: ${data.password}');
  //   return Future.delayed(loginTime).then((_) {
  //     if (!users.containsKey(data.name)) {
  //       return 'User not exists';
  //     }
  //     if (users[data.name] != data.password) {
  //       return 'Password does not match';
  //     }
  //     return null;
  //   });
  // }

  Future<String?> _authUser(LoginData data) {
    debugPrint('Name: ${data.name}, Password: ${data.password}');
    return FirebaseAuth.instance
        .signInWithEmailAndPassword(
          email: data.name,
          password: data.password,
        )
        .then((_) => null)
        .catchError((error) {
      debugPrint('Error: $error');
      return error.toString();
    });
  }

  // Future<String?> _signupUser(SignupData data) {
  //   debugPrint('Signup Name: ${data.name}, Password: ${data.password}');
  //   return Future.delayed(loginTime).then((_) {
  //     return null;
  //   });
  // }

  Future<String?> _signupUser(SignupData data) {
    debugPrint('Signup Name: ${data.name}, Password: ${data.password}');
    return FirebaseAuth.instance
        .createUserWithEmailAndPassword(
          email: data.name!,
          password: data.password!,
        )
        .then((_) => null)
        .catchError((error) {
      debugPrint('Error: $error');
      return error.toString();
    });
  }

  // Future<String?> _recoverPassword(String name) {
  //   debugPrint('Name: $name');
  //   return Future.delayed(loginTime).then((_) {
  //     if (!users.containsKey(name)) {
  //       return 'User not exists';
  //     }
  //     return null;
  //   });
  // }
  Future<String?> _recoverPassword(String name) {
    debugPrint('Name: $name');
    return FirebaseAuth.instance
        .sendPasswordResetEmail(email: name)
        .then((_) => null)
        .catchError((error) {
      debugPrint('Error: $error');
      return error.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    final inputBorder = BorderRadius.vertical(
      bottom: Radius.circular(10.0),
      top: Radius.circular(20.0),
    );
    return FlutterLogin(
        logo: AssetImage('assets/images/ghost_v4.png'),
        title: 'Ghost\'s Dream',
        // onLogin: (_) => _loginUser(context), // 로그인 콜백 함수를 구현합니다.
        // onSignup: (_) => _signupUser(context), // 회원가입 콜백 함수를 구현합니다.
        onLogin: _authUser,
        onSignup: _signupUser,
        loginProviders: <LoginProvider>[
          LoginProvider(
            icon: FontAwesomeIcons.google,
            label: 'Google',
            // callback: () async {
            //   debugPrint('start google sign in');
            //   await Future.delayed(loginTime);

            //   debugPrint('stop google sign in');
            //   return null;
            // },
            callback: () async {
              debugPrint('start google sign in');
              final GoogleSignInAccount? googleUser =
                  await GoogleSignIn(scopes: <String>["email"]).signIn();
              final GoogleSignInAuthentication? googleAuth =
                  await googleUser?.authentication;
              final credential = GoogleAuthProvider.credential(
                accessToken: googleAuth?.accessToken,
                idToken: googleAuth?.idToken,
              );
              try {
                await FirebaseAuth.instance.signInWithCredential(credential);
              } catch (error) {
                debugPrint('Error: $error');
                return error.toString();
              }
              debugPrint('stop google sign in');
              return null;
            },
          ),
          LoginProvider(
            icon: FontAwesomeIcons.person,
            label: 'Anonymous',
            // callback: () async {
            //   debugPrint('start anonymous sign in');
            //   await Future.delayed(loginTime);
            //   debugPrint('stop anonymous sign in');
            //   return null;
            // },
            callback: () async {
              debugPrint('start anonymous sign in');
              try {
                await FirebaseAuth.instance.signInAnonymously();
              } catch (error) {
                debugPrint('Error: $error');
                return error.toString();
              }
              debugPrint('stop anonymous sign in');
              return null;
            },
          ),
        ],
        onSubmitAnimationCompleted: () {
          Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => HomePage(), // 로그인 성공 후 홈 페이지로 이동합니다.
          ));
        },
        onRecoverPassword: _recoverPassword, // 비밀번호 복구 콜백 함수를 구현합니다.
        theme: LoginTheme(
          primaryColor: Colors.deepPurple,
          accentColor: Color.fromRGBO(186, 85, 211, 100),

          errorColor: Colors.deepOrange,
          titleStyle: TextStyle(
              color: Color.fromRGBO(230, 230, 250, 100),
              fontFamily: 'Quicksand',
              letterSpacing: 4,
              fontWeight: FontWeight.bold),
          // bodyStyle: TextStyle(
          //   fontStyle: FontStyle.italic,
          //   decoration: TextDecoration.underline,
          // ),
          // textFieldStyle: TextStyle(
          //   color: Colors.orange,
          //   shadows: [Shadow(color: Colors.yellow, blurRadius: 2)],
          // ),
          // buttonStyle: TextStyle(
          //   fontWeight: FontWeight.w800,
          //   color: Colors.yellow,
          // ),
          // cardTheme: CardTheme(
          //   color: Colors.yellow.shade100,
          //   elevation: 5,
          //   margin: EdgeInsets.only(top: 15),
          //   shape: ContinuousRectangleBorder(
          //       borderRadius: BorderRadius.circular(100.0)),
          // ),
          inputTheme: InputDecorationTheme(
            filled: true,
            fillColor: Colors.purple.withOpacity(.1),
            contentPadding: EdgeInsets.zero,
            errorStyle: TextStyle(
              // backgroundColor: Colors.orange,
              color: Colors.black,
            ),
            labelStyle: TextStyle(fontSize: 12),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.purple.shade700, width: 4),
              borderRadius: inputBorder,
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.purple.shade400, width: 5),
              borderRadius: inputBorder,
            ),
            errorBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.red.shade700, width: 7),
              borderRadius: inputBorder,
            ),
            focusedErrorBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.red.shade400, width: 8),
              borderRadius: inputBorder,
            ),
            disabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.grey, width: 5),
              borderRadius: inputBorder,
            ),
          ),
        ));
  }

  //signout function
  Future<void> _signOut() async {
    // final GoogleSignIn googleSignIn = new GoogleSignIn();
    await FirebaseAuth.instance.signOut();
    //signout하면 login page로 가기
    // Sign out with google
    // await googleSignIn.signOut();
    Get.to(LoginScreen());
  }
}
