import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pendaftaran_siswa_smktag/services/auth_service.dart';
import 'package:pendaftaran_siswa_smktag/main.dart';
import 'package:flutter/gestures.dart';
import 'package:pendaftaran_siswa_smktag/utils/utils.dart';
import 'package:email_validator/email_validator.dart';
import 'package:pendaftaran_siswa_smktag/pages/forgotpass_page.dart';
import 'package:pendaftaran_siswa_smktag/widgets/logo_widget.dart';

class LoginPage extends StatefulWidget {
  final Function() onClickedSignUp;

  const LoginPage({
    Key? key,
    required this.onClickedSignUp,
  }) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future signIn() async {
    final isValid = formKey.currentState!.validate();
    if (!isValid) return;

    showDialog(
        context: context,
        builder: (context) => Center(child: CircularProgressIndicator()));

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
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
                  : null)
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
            onPressed: signIn,
            child: Text('Sign In'),
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black87,
                shadowColor: Colors.grey,
                padding: EdgeInsets.symmetric(horizontal: 35, vertical: 20)),
          ),
        ));
  }

  Widget _createAccountLabel() {
    return InkWell(
      onTap: widget.onClickedSignUp,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 20),
        alignment: Alignment.bottomCenter,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RichText(
                text: TextSpan(
                    text: "Dont have an account?",
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.w400),
                    children: [
                  TextSpan(
                    recognizer: TapGestureRecognizer()
                      ..onTap = widget.onClickedSignUp,
                    text: ' Sign up',
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

  Widget _googleButton() {
    return SizedBox(
        width: double.infinity,
        child: Container(
          padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
          child: ElevatedButton(
            onPressed: () {
              AuthService().signInWithGoogle();
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 20.0,
                  width: 20.0,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('assets/img/google.png'),
                        fit: BoxFit.cover),
                    shape: BoxShape.circle,
                  ),
                ),
                Text('  Sign in with Google')
              ],
            ),
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black87,
                shadowColor: Colors.grey,
                padding: EdgeInsets.symmetric(horizontal: 35, vertical: 20)),
          ),
        ));
  }

  Widget _dividerSign() {
    return Padding(
        padding: EdgeInsets.only(left: 20, right: 20),
        child: Row(children: <Widget>[
          Expanded(
              child: Divider(
            color: Colors.black45,
          )),
          Text("Or Sign In with"),
          Expanded(
              child: Divider(
            color: Colors.black45,
          )),
        ]));
  }

  Widget _forgotPassword() {
    return GestureDetector(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 20, right: 20),
            child: Text(
              "Forgot password?",
              style: TextStyle(color: Colors.blue[300]),
            ),
          )
        ],
      ),
      onTap: () => Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => ForgotPasswordPage())),
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
                          Widgetsw().logo(15, Colors.black, Colors.amber),
                          Text(
                            "Sign In",
                            style: TextStyle(
                              fontSize: 40,
                              fontWeight: FontWeight.w500,
                              fontFamily: "Fenix",
                            ),
                          ),

                          SizedBox(height: 10),
                          _inputField(),
                          SizedBox(height: 10),
                          _submitButton(),
                          SizedBox(height: 10),
                          _forgotPassword(),
                          SizedBox(height: 10),
                          _createAccountLabel(),
                          _dividerSign(),
                          SizedBox(height: 20),
                          _googleButton(),
                          SizedBox(height: 80),
                          // _createAccountLabel(),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )));
  }
}
