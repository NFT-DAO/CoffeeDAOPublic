import 'package:cdao/routes/route_const.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class LogInForm extends StatefulWidget {
  final FirebaseAuth firebaseAuth;
  const LogInForm({required this.firebaseAuth, Key? key}) : super(key: key);

  @override
  LogInFormState createState() => LogInFormState();
}

class LogInFormState extends State<LogInForm> {
  final _formKey = GlobalKey<FormState>();
  late String _email;
  late String _password;
  late bool _isSubmitting;
  String? _signupEmailErr;
  String? _signupPassErr;
  late bool _passwordVisible;
  var logger = Logger();

  Future<String> signIn(
      {required String email, required String password}) async {
    try {
      await widget.firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);
      return 'success';
    } on FirebaseAuthException catch (e) {
      logger.e('FirebaseAuthException: $e.code');
      switch (e.code) {
        case "provider-already-linked":
          return e.code;
        case "invalid-credential":
          return e.code;
        case "credential-already-in-use":
          return e.code;
        default:
          return 'Something Went Wrong Singing In  $e';
      }
    }
  }

  @override
  void initState() {
    _email = '';
    _password = '';
    _isSubmitting = false;
    _passwordVisible = false;
    super.initState();
  }

  void _submitAuthForm(cx) async {
    String logMessage;
    FocusScope.of(context).unfocus();
    _formKey.currentState!.save();
    setState(() {
      _isSubmitting = true;
    });
    logMessage = await signIn(email: _email, password: _password);

    if (logMessage.contains('invalid-email')) {
      _signupEmailErr = 'Email Error: $logMessage';
      _isSubmitting = false;
      setState(() {});
    } else if (logMessage.contains('user-not-found')) {
      _signupEmailErr = "No user exists for that email.";
      _isSubmitting = false;
      setState(() {});
    } else if (logMessage.contains('email-already-in-use')) {
      _signupEmailErr =
          "An account already exists for that user name or email. Please sign in.";
      _isSubmitting = false;
      setState(() {});
    } else if (logMessage.contains('wrong-password')) {
      _signupPassErr = "Wrong password provided.";
      _isSubmitting = false;
      setState(() {});
    } else if (logMessage.contains('provider-already-linked')) {
      _signupPassErr = "Provided Credential Already Linked.";
      _isSubmitting = false;
      setState(() {});
    } else if (logMessage.contains('invalid-credential')) {
      _signupPassErr = "The provided credentials are not valid.";
      _isSubmitting = false;
      setState(() {});
    } else if (logMessage.contains('credential-already-in-use')) {
      _signupPassErr =
          "The account corresponding to the credential already exists, or is already linked to a Firebase User.";
      _isSubmitting = false;
      setState(() {});
    } else if (logMessage.contains('Something Went Wrong')) {
      _signupPassErr = logMessage;
      _signupEmailErr = logMessage;
      _isSubmitting = false;
      setState(() {});
    } else if (logMessage.contains('success')) {
      cx.goNamed(
        CDAOConstants.portal,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    double lgFontSize = 20;
    double smFontSize = 15;

    return Center(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
          SizedBox(
            width: deviceWidth,
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              color: Colors.blueGrey,
              margin: const EdgeInsets.all(20),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        const Text('LOG IN',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.orange,
                                fontSize: 30)),
                        TextFormField(
                          key: const ValueKey('email'),
                          autocorrect: false,
                          textCapitalization: TextCapitalization.none,
                          enableSuggestions: false,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            labelText: 'Email Address',
                            labelStyle: TextStyle(fontSize: lgFontSize),
                            helperStyle: TextStyle(fontSize: smFontSize),
                            hintStyle: TextStyle(fontSize: smFontSize),
                            errorText: _signupEmailErr,
                            errorStyle: TextStyle(fontSize: lgFontSize),
                          ),
                          onChanged: (value) => setState(() {
                            _email = value;
                          }),
                          onSaved: (value) {
                            setState(() {
                              _email = value as String;
                            });
                          },
                        ),
                        TextFormField(
                          key: const ValueKey('password'),
                          decoration: InputDecoration(
                            labelText: 'Password',
                            labelStyle: TextStyle(fontSize: lgFontSize),
                            errorText: _signupPassErr,
                            errorStyle: TextStyle(fontSize: lgFontSize),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _passwordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: Colors.orange,
                              ),
                              onPressed: () {
                                setState(() {
                                  _passwordVisible = !_passwordVisible;
                                });
                              },
                            ),
                          ),
                          obscureText: !_passwordVisible,
                          onChanged: (value) => setState(() {
                            _password = value;
                          }),
                          onSaved: (value) {
                            setState(() {
                              _password = value as String;
                            });
                          },
                        ),
                        const SizedBox(height: 12),
                        if (_isSubmitting) const CircularProgressIndicator(),
                        if (!_isSubmitting)
                          ElevatedButton(
                            style: const ButtonStyle(
                                visualDensity: VisualDensity.compact),
                            onPressed: () {
                              _submitAuthForm(context);
                            },
                            child: Text('LOG IN',
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: lgFontSize)),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ]));
  }
}
