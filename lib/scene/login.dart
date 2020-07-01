import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reed/bloc/bloc.dart';

class LoginScene extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _LoginState();
}

class _LoginState extends State<LoginScene> {
  final _scaffoldKey = new GlobalKey<ScaffoldState>();
  final _formKey = new GlobalKey<FormState>();
  bool _isSubmiting = false;
  TextEditingController _urlController = new TextEditingController();
  TextEditingController _keyController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.white,
        resizeToAvoidBottomPadding: false,
        body: SafeArea(
            bottom: true,
            child: BlocListener<APIBloc, APIState>(
                listener: (BuildContext context, APIState state) {
                  if (state is APICredentialSaveFailure) {
                    Scaffold.of(context)
                        .showSnackBar(SnackBar(content: Text('提交失败')));
                    setState(() {
                      _isSubmiting = false;
                    });
                  }
                },
                child: Form(
                  key: _formKey,
                  child: Container(
                      padding: const EdgeInsets.only(
                          left: 50.0, right: 50.0, top: 20.0),
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding:
                                const EdgeInsets.only(bottom: 20.0, top: 20.0),
                            child: Column(
                              children: <Widget>[
                                Icon(Icons.cloud, size: 60.0),
                                SizedBox(height: 8.0),
                                Text('Fever', style: TextStyle(fontSize: 18.0)),
                              ],
                            ),
                          ),
                          TextFormField(
                            controller: _urlController,
                            validator: (value) {
                              if (value.isEmpty) {
                                return '地址不能为空';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              hintText: "请输入API地址",
                              hintStyle: TextStyle(fontSize: 14.0),
                            ),
                          ),
                          TextFormField(
                            controller: _keyController,
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'API密钥不能为空';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              hintText: "请输入API密钥",
                              hintStyle: TextStyle(fontSize: 14.0),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 20.0),
                            child: RaisedButton(
                              child:
                                  Text('提交', style: TextStyle(fontSize: 16.0)),
                              onPressed: _isSubmiting
                                  ? null
                                  : () {
                                      FocusScope.of(context)
                                          .requestFocus(new FocusNode());
                                      if (_formKey.currentState.validate()) {
                                        setState(() {
                                          _isSubmiting = true;
                                        });
                                        final _url = _urlController.text;
                                        final _key = _keyController.text;
                                        BlocProvider.of<APIBloc>(context).add(
                                            SaveAPICredential(
                                                apiKey: _key, baseURL: _url));
                                      }
                                    },
                            ),
                          )
                        ],
                      )),
                ))));
  }
}
