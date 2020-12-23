import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/style.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:reed/model/model.dart';
import 'package:reed/bloc/bloc.dart';
import 'package:reed/repository/repository.dart';

import '../bloc/bloc.dart';

class EntryScene extends StatefulWidget {
  final Function onFetched;
  final int id;
  const EntryScene({Key key, @required this.id, @required this.onFetched})
      : assert(id != null),
        super(key: key);
  @override
  State<StatefulWidget> createState() => _EntryState();
}

class _EntryState extends State<EntryScene> {
  EntryBloc _bloc;
  @override
  void initState() {
    super.initState();
    EntryRepository _repository = context.read<EntryRepository>();
    _bloc = EntryBloc(repository: _repository);
    _bloc.add(FetchEntry(id: widget.id));
  }

  Future<void> _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Cound not launch $url';
    }
  }

  Widget _renderTitle(BuildContext context, Entry entry) {
    return Container(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
        child: Text(entry.title, style: TextStyle(fontSize: 16.0)));
  }

  Widget _renderBrief(BuildContext context, Entry entry) {
    return Container(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.only(bottom: 10.0, left: 10.0, right: 10.0),
        child: Row(children: <Widget>[
          Text(entry.author != '' ? entry.author : entry.feed.title,
              style: TextStyle(fontSize: 12.0, color: Colors.grey)),
          SizedBox(width: 12.0),
          Text(fromNow(entry.publishedAt),
              style: TextStyle(fontSize: 12.0, color: Colors.grey))
        ]));
  }

  Widget _renderBody(BuildContext context, Entry entry) {
    return BlocBuilder<SettingsBloc, SettingsState>(
      builder: (context, state) {
        return Container(
            child: Html(
                data: entry.content,
                style: {
                  "html": Style(
                      fontSize: FontSize(state.values['fontSize']),
                      letterSpacing: state.values['letterSpacing']),
                },
                onImageError: (exception, stackTrace) {
                  // print("===>$exception");
                }));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
        value: _bloc,
        child: Scaffold(
            appBar: AppBar(
              elevation: 0.5,
              centerTitle: true,
              leading: IconButton(
                icon: Icon(Icons.navigate_before),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              actions: <Widget>[
                BlocConsumer<EntryBloc, EntryState>(
                  listener: (context, state) {
                    if (state is EntryFetchSuccess) {
                      widget.onFetched(widget.id);
                    }
                  },
                  builder: (context, state) {
                    if (state is EntryFetchSuccess) {
                      final _entry = state.entry;
                      return PopupMenuButton(
                        onSelected: (int val) {
                          if (val == 1) {
                            Clipboard.setData(ClipboardData(text: _entry.url))
                                .then((_) {
                              Scaffold.of(context).showSnackBar(SnackBar(
                                  content: Text(
                                      'Article Link copied to clipboard'
                                          .tr())));
                            });
                          }
                          if (val == 2) {
                            _launchURL(_entry.url).catchError((_) {
                              Scaffold.of(context).showSnackBar(SnackBar(
                                  content:
                                      Text('Article Link open failed'.tr())));
                            });
                          }
                        },
                        itemBuilder: (context) => [
                          PopupMenuItem(
                            value: 1,
                            child: Text('Copy Link'.tr()),
                          ),
                          PopupMenuItem(
                            value: 2,
                            child: Text('Open In Browser'.tr()),
                          )
                        ],
                      );
                    }
                    return Container();
                  },
                )
              ],
            ),
            body: SafeArea(
                bottom: true,
                child: BlocBuilder<EntryBloc, EntryState>(
                  builder: (BuildContext context, state) {
                    if (state is EntryFetchSuccess) {
                      final _entry = state.entry;
                      return SingleChildScrollView(
                          child: Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12.0),
                              child: Column(children: <Widget>[
                                _renderTitle(context, _entry),
                                _renderBrief(context, _entry),
                                _renderBody(context, _entry)
                              ])));
                    }
                    return Center(
                        child: CircularProgressIndicator(strokeWidth: 2.0));
                  },
                ))));
  }
}
