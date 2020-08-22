import 'package:flutter/material.dart';
import 'package:flutteragenda/screens/home.dart';

class FormLogin extends StatefulWidget {
  @override
  _FormLoginState createState() => _FormLoginState();
}

class _FormLoginState extends State<FormLogin> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  String _username, _password;
  FocusNode _usernameFocus, _passwordFocus;
  bool _autoValidate = false;

  void initState() {
    super.initState();

    _usernameFocus = FocusNode();
    _passwordFocus = FocusNode();
  }

  @override
  void dispose() {
    // Clean up the focus node when the Form is disposed.
    _usernameFocus.dispose();
    _passwordFocus.dispose();
    _formKey.currentState?.dispose();

    super.dispose();
  }

  _onSave(BuildContext context) {
    final form = _formKey.currentState;
    final adm = 'admin';
    if (form.validate()) {
      form.save();
      if (_username.toLowerCase() == adm && _password.toLowerCase() == adm) {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (BuildContext context) => Home()));
      } else {
        _showSnackBar("username dan password-nya 'admin'");
      }
    } else {
      setState(() {
        _autoValidate = true;
      });
    }
  }

  void _showSnackBar(message) {
    final snackBar = SnackBar(
      content: Text(message),
    );

    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
//      appBar: AppBar(
//        backgroundColor: Colors.white,
//        elevation: 0.0,
//      ),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.only(left: 5.0, right: 5.0),
          child: Form(
            key: _formKey,
            autovalidate: _autoValidate,
            child: ListView(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 100.0, bottom: 20.0),
                  child: Image.asset(
                    'assets/images/sekolah.png',
                    width: 150.0,
                    height: 150.0,
                  ),
                ),
                TextFormField(
                  focusNode: _usernameFocus,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Username',
                  ),
                  onSaved: (String value) {
                    // will trigger when saved
                    _username = value;
                  },
                  onFieldSubmitted: (term) {
                    // process
                    _usernameFocus.unfocus();
                    FocusScope.of(context).requestFocus(_passwordFocus);
                  },
                  validator: (value) {
                    final isValidUsername = RegExp(r'^[a-zA-Z]*$');
                    if (value.isEmpty) {
                      return 'Username wajib diisi!';
                    } else if (!isValidUsername.hasMatch(value)) {
                      return 'Only letters are allowed';
                    }

                    return null;
                  },
                ),
                SizedBox(
                  height: 16.0,
                ),
                TextFormField(
                  obscureText: true,
                  focusNode: _passwordFocus,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Password',
                  ),
                  onSaved: (String value) {
                    // will trigger when saved
                    print('onsaved $value');
                    _password = value;
                  },
                  onFieldSubmitted: (term) {
                    // process
                    _onSave(context);
                  },
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Password wajib diisi!';
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: 16.0,
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: RaisedButton(
                          textColor: Colors.white,
                          color: Theme.of(context).colorScheme.primary,
                          onPressed: () {
                            _onSave(context);
                          },
                          child: const Text('LOGIN')),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}