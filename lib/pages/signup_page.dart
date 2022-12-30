import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:pendaftaran_siswa_smktag/pages/login_page.dart';
import 'package:pendaftaran_siswa_smktag/services/auth_service.dart';
import 'package:pendaftaran_siswa_smktag/main.dart';
import 'package:pendaftaran_siswa_smktag/utils/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SignUpPage extends StatefulWidget {
  final Function() onClickedSignIn;

  const SignUpPage({super.key, required this.onClickedSignIn});
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _usernameController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _usernameController.dispose();

    super.dispose();
  }

  Future signUp() async {
    final isValid = formKey.currentState!.validate();
    if (!isValid) return;

    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Center(child: CircularProgressIndicator()));

    try {
      await FirebaseAuth.instance.currentUser
          ?.updateDisplayName(_usernameController.text);
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim());
    } on FirebaseAuthException catch (e) {
      print(e);

      Utils.showActionSnackBar(context, e.message);
    }

    navigatorKey.currentState!.popUntil((route) => route.isFirst);
  }

  OutlineInputBorder myinputborder() {
    //return type is OutlineInputBorder
    return OutlineInputBorder(
        //Outline border type for TextFeild
        borderRadius: BorderRadius.all(Radius.circular(8)),
        borderSide: BorderSide(
          color: Colors.grey,
          width: 1,
        ));
  }

  OutlineInputBorder myfocusborder() {
    return OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
        borderSide: BorderSide(
          color: Colors.black,
          width: 2,
        ));
  }

  Widget _inputField() {
    return Container(
      padding: EdgeInsets.all(20),
      child: Column(
        children: [
          TextFormField(
              controller: _usernameController,
              decoration: InputDecoration(
                labelText: "Username",
                prefixIcon: Icon(Icons.person_outline),
                border: myinputborder(),
                enabledBorder: myinputborder(),
                focusedBorder: myfocusborder(),
              ),
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) => value != null && value.length < 5
                  ? "Masukkan minimal 5 karakter"
                  : null),
          Container(height: 20),
          TextFormField(
            controller: _emailController,
            decoration: InputDecoration(
              labelText: "Email",
              prefixIcon: Icon(Icons.email_outlined),
              border: myinputborder(),
              enabledBorder: myinputborder(),
              focusedBorder: myfocusborder(),
            ),
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (email) =>
                email != null && !EmailValidator.validate(email)
                    ? 'Email tidak valid'
                    : null,
          ),
          Container(height: 20),
          TextFormField(
              controller: _passwordController,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.lock_outline),
                labelText: "Password",
                border: myinputborder(),
                enabledBorder: myinputborder(),
                focusedBorder: myfocusborder(),
              ),
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) => value != null && value.length < 6
                  ? "Masukkan minimal 6 karakter"
                  : null),
          Container(height: 20),
          TextFormField(
            controller: _confirmPasswordController,
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.lock_outline),
              labelText: "Konfirmasi Password",
              border: myinputborder(),
              enabledBorder: myinputborder(),
              focusedBorder: myfocusborder(),
            ),
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (value) {
              if (value!.isEmpty) {
                return 'Konfirmasi password anda!';
              } else if (value != _passwordController.text) {
                return 'Password tidak sesuai!';
              }
            },
          )
        ],
      ),
    );
  }

  Widget _logo() {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
          text: "PPDB",
          style: TextStyle(
              fontFamily: "Inknut Antiqua",
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: Colors.black),
          children: [
            TextSpan(
              text: 'SMKTAG',
              style: TextStyle(color: Colors.amber, fontSize: 15),
            ),
          ]),
    );
  }

  Widget _submitButton() {
    return SizedBox(
        width: double.infinity,
        child: Container(
          padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
          child: ElevatedButton(
            onPressed: signUp,
            child: Text('Sign Up'),
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black87,
                shadowColor: Colors.grey,
                padding: EdgeInsets.symmetric(horizontal: 35, vertical: 20)),
          ),
        ));
  }

  Widget _loginAccountLabel() {
    return InkWell(
      onTap: widget.onClickedSignIn,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 20),
        alignment: Alignment.bottomCenter,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RichText(
                text: TextSpan(
                    text: "Already have an Account?",
                    style: TextStyle(color: Colors.black),
                    children: [
                  TextSpan(
                    recognizer: TapGestureRecognizer()
                      ..onTap = widget.onClickedSignIn,
                    text: ' Login',
                    style: TextStyle(
                        color: Colors.amber,
                        fontSize: 13,
                        fontWeight: FontWeight.w600),
                  ),
                ]))
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
        body: Container(
      height: height,
      child: Form(
        key: formKey,
        child: Stack(
          children: <Widget>[
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(height: height * .10),
                    _logo(),
                    Text(
                      "Sign Up",
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.w500,
                        fontFamily: "Fenix",
                      ),
                    ),
                    SizedBox(height: 10),
                    _inputField(),
                    SizedBox(
                      height: 10,
                    ),
                    _submitButton(),
                    _loginAccountLabel(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
