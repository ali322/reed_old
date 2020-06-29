import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reed/bloc/bloc.dart';

class LoginScene extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _LoginState();
}

class _LoginState extends State<LoginScene> {
  final _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool _isSubmiting = false;
  TextEditingController _urlController = new TextEditingController();
  TextEditingController _usernameController = new TextEditingController();
  TextEditingController _passwordController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.white,
        resizeToAvoidBottomPadding: false,
        body: SafeArea(
            bottom: true,
            child: Form(
              child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Column(
                    children: <Widget>[
                      Theme(
                          data: Theme.of(context)
                              .copyWith(hintColor: Colors.grey),
                          child: TextField(
                            controller: _urlController,
                            decoration: InputDecoration(
                              hintText: "请输入地址",
                              hintStyle: TextStyle(fontSize: 14.0),
                            ),
                          )),
                      Theme(
                          data: Theme.of(context)
                              .copyWith(hintColor: Colors.grey),
                          child: TextField(
                            controller: _usernameController,
                            decoration: InputDecoration(
                              hintText: "用户名",
                              hintStyle: TextStyle(fontSize: 14.0),
                            ),
                          )),
                      Theme(
                          data: Theme.of(context)
                              .copyWith(hintColor: Colors.grey),
                          child: TextField(
                            controller: _passwordController,
                            obscureText: true,
                            decoration: InputDecoration(
                              hintText: "密码",
                              hintStyle: TextStyle(fontSize: 14.0),
                            ),
                          )),
                      Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                        child: Theme(
                          data: Theme.of(context).copyWith(
                              buttonTheme: Theme.of(context)
                                  .buttonTheme
                                  .copyWith(
                                      minWidth:
                                          MediaQuery.of(context).size.width,
                                      height: 40.0)),
                          child: RaisedButton(
                            child: Text('确定'),
                            onPressed: _isSubmiting ? null : () {
                              FocusScope.of(context)
                                  .requestFocus(new FocusNode());
                              setState(() {
                                _isSubmiting = true;
                              });
                              final _url = _urlController.text;
                              final _username = _usernameController.text;
                              final _password = _passwordController.text;
                              BlocProvider.of<APIBloc>(context).add(VerifyAPI(baseURL: _url, username: _username, password: _password ));
                            },
                          ),
                        ),
                      )
                    ],
                  )),
            )));
  }
}
