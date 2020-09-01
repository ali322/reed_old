import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:reed/bloc/bloc.dart';

class AuthorizeScene extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _AuthorizeState();
}

class _AuthorizeState extends State<AuthorizeScene> {
  final _scaffoldKey = new GlobalKey<ScaffoldState>();
  final _formKey = new GlobalKey<FormState>();
  bool _isSubmiting = false;
  TextEditingController _urlController = new TextEditingController();
  TextEditingController _keyController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        resizeToAvoidBottomPadding: false,
        appBar: AppBar(
            brightness: Theme.of(context).brightness,
            elevation: 0.0,
            backgroundColor: Colors.transparent,
            leading: Theme(
              data: Theme.of(context)
                  .copyWith(brightness: Theme.of(context).brightness),
              child: IconButton(
                icon: Icon(Icons.navigate_before),
                onPressed: () {
                  SystemChannels.platform.invokeMethod('SystemNavigator.pop');
                },
              ),
            )),
        body: SafeArea(
            bottom: true,
            child: BlocListener<APIBloc, APIState>(
                listener: (BuildContext context, APIState state) {
                  if (state is APICredentialSaveFailure) {
                    Scaffold.of(context).showSnackBar(
                        SnackBar(content: Text('Submit Failed'.tr())));
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
                                const EdgeInsets.only(bottom: 40.0, top: 60.0),
                            child: Column(
                              children: <Widget>[
                                Image.asset('assets/image/REED_TEXT.png', width: 200.0),
                              ],
                            ),
                          ),
                          TextFormField(
                            controller: _urlController,
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'site url can not be empty'.tr();
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              hintText: "Please input site url".tr(),
                              hintStyle: TextStyle(fontSize: 14.0),
                            ),
                          ),
                          TextFormField(
                            controller: _keyController,
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'api key can not be empty';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              hintText: "Please input api key".tr(),
                              hintStyle: TextStyle(fontSize: 14.0),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 20.0),
                            child: RaisedButton(
                              child: Text('Submit'.tr(),
                                  style: TextStyle(fontSize: 16.0)),
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
                                                title: '',
                                                apiKey: _key,
                                                baseURL: _url));
                                      }
                                    },
                            ),
                          )
                        ],
                      )),
                ))));
  }
}
