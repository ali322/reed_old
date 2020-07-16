import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:package_info/package_info.dart';

class AboutScene extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _AboutState();
}

class _AboutState extends State<AboutScene> {
  String _version = '';
  @override
  void initState() {
    super.initState();
    _fetchAPPInfo();
  }

  void _fetchAPPInfo() async {
    final _appInfo = await PackageInfo.fromPlatform();
    setState(() {
      _version = _appInfo.version;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.white,
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
                Navigator.of(context).maybePop();
              },
            ),
          )),
      body: SafeArea(
        bottom: true,
        child: Center(
          child: Column(
            children: <Widget>[
              SizedBox(height: 20.0),
              Image.asset('assets/image/REED_TEXT.png', width: 200.0),
              SizedBox(height: 20.0),
              Text('v$_version',
                  style: TextStyle(fontSize: 14.0, color: Colors.grey)),
              SizedBox(height: 20.0),
              Text('Made By {}'.tr(args: ['alichen']))
            ],
          ),
        ),
      ),
    );
  }
}
