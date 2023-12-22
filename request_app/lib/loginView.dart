import 'package:flutter/material.dart';
import 'package:PAM/Baak.views/BaakScreen.dart';
import 'package:PAM/Mahasiswa.views/MahasiswaScreen.dart';
import 'package:PAM/Models/api_response.dart';
import 'package:PAM/Models/user.dart';
import 'package:PAM/Services/User_service.dart';
import 'package:PAM/Auth/register_screen.dart';
import 'package:PAM/rounded_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> formkey = GlobalKey<FormState>();
  TextEditingController txtemail = TextEditingController();
  TextEditingController txtpassword = TextEditingController();
  bool loading = false;

  void _loginUser() async {
    ApiResponse response = await login(txtemail.text, txtpassword.text);
    if (response.error == null) {
      _saveAndRedirectHome(response.data as User);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('${response.error}'),
      ));
    }
  }

  void _saveAndRedirectHome(User user) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setString('token', user.token ?? '');
    await pref.setInt('userId', user.id ?? 0);

    if (user.role == 'mahasiswa') {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => MahasiswaScreen()),
        (route) => false,
      );
    } else if (user.role == 'baak') {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => BaakScreen()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Login',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            TextFormField(
              keyboardType: TextInputType.emailAddress,
              controller: txtemail,
              validator: (val) => val!.isEmpty ? 'Invalid email address' : null,
              decoration: InputDecoration(
                labelText: 'Email',
                hintText: 'Enter your email',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: txtpassword,
              obscureText: true,
              validator: (val) =>
                  val!.length < 6 ? 'Minimum 6 characters required' : null,
              decoration: InputDecoration(
                labelText: 'Password',
                hintText: 'Enter your password',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 30),
            RoundedButton(
              btnText: 'LOG IN',
              onBtnPressed: () => _loginUser(),
            ),
            SizedBox(height: 20),
            TextButton(
              onPressed: () => Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => RegisterScreen()),
                (route) => false,
              ),
              child: Text(
                'Silahkan Register Jika Belum Punya Akun',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
