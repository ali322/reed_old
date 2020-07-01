import 'package:flutter/material.dart';
import 'package:reed/model/model.dart';
import 'package:flutter_html/flutter_html.dart';

class ItemScene extends StatelessWidget {
  final Item item;

  const ItemScene({@required this.item}) : assert(item != null);

  Widget _renderTitle(BuildContext context) {
    return Container(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
        child: Text(item.title, style: TextStyle(fontSize: 16.0)));
  }

  Widget _renderBrief(BuildContext context) {
    return Container(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.only(bottom: 10.0, left: 10.0, right: 10.0),
        child: Row(children: <Widget>[
          Text(item.author,
              style: TextStyle(fontSize: 12.0, color: Colors.grey)),
          SizedBox(width: 12.0),
          Text(fromNow(item.createdAt),
              style: TextStyle(fontSize: 12.0, color: Colors.grey))
        ]));
  }

  Widget _renderBody(BuildContext context) {
    return Container(
        child: Html(
      data: item.content,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0.5,
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.navigate_before),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        body: SafeArea(
          bottom: true,
          child: SingleChildScrollView(
              child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Column(children: <Widget>[
                    _renderTitle(context),
                    _renderBrief(context),
                    _renderBody(context)
                  ]))),
        ));
  }
}
