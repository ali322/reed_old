import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reed/bloc/bloc.dart';

class AuthorizationScene extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Widget _renderAuthorization(context, state) {
      return Column(
        children: <Widget>[
          SizedBox(height: 20.0),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                width: 70.0,
                child:
                    Text('Site URL'.tr(), style: TextStyle(color: Colors.grey)),
              ),
              Expanded(child: Text(state.baseURL))
            ],
          ),
          SizedBox(height: 20.0),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                width: 70.0,
                child:
                    Text('API Key'.tr(), style: TextStyle(color: Colors.grey)),
              ),
              Expanded(child: Text(state.apiKey))
            ],
          ),
          SizedBox(height: 20.0),
        ],
      );
    }

    Widget _renderReset(context) {
      return OutlinedButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  content: Text('Are you sure to reset?'.tr()),
                  actions: <Widget>[
                    TextButton(
                      child: Text('Yes'.tr()),
                      onPressed: () {
                        context.read<APIBloc>().add(ResetAPICredential());
                        Future.delayed(const Duration(milliseconds: 300), () {
                          Navigator.of(context)
                              .popUntil((route) => route.isFirst);
                        });
                      },
                    ),
                    TextButton(
                      child:
                          Text('No'.tr(), style: TextStyle(color: Colors.grey)),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    )
                  ],
                );
              });
        },
        child: Center(
            child: Text('Reset'.tr(),
                style: TextStyle(fontSize: 16.0, color: Colors.redAccent))),
      );
    }

    return Scaffold(
      appBar: AppBar(
        elevation: 0.5,
        centerTitle: true,
        title: Text('Authorization'.tr()),
        leading: IconButton(
          icon: Icon(Icons.navigate_before),
          onPressed: () {
            Navigator.of(context).maybePop();
          },
        ),
      ),
      body: SafeArea(
          bottom: true,
          child: Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
            child: BlocBuilder<APIBloc, APIState>(
              builder: (context, state) {
                if (state is APICredentialLoadSuccess || state is APICredentialSaveSuccess) {
                  return Column(
                    children: <Widget>[
                      _renderAuthorization(context, state),
                      _renderReset(context)
                    ],
                  );
                }
                return Container();
              },
            ),
          )),
    );
  }
}
