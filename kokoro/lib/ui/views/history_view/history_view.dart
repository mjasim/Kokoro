import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:kokoro/ui/smart_widgets/top_navigation_bar/top_navigation_bar.dart';
import 'package:kokoro/ui/views/history_view/history_viewmodel.dart';
import 'package:stacked/stacked.dart';

import 'dart:html';
import 'dart:ui' as ui;

class HistoryView extends StatefulWidget {
  @override
  _HistoryViewState createState() => _HistoryViewState();
}

class _HistoryViewState extends State<HistoryView> {
  static final _jsonEncoder = JsonEncoder();

  static HistoryViewModel _model = HistoryViewModel();

  @override
  void initState() {
    final Storage _localStorage = window.localStorage;
    _model.init();
    _localStorage['user_info'] = _jsonEncoder.convert({"id": "hero", "img": "http://marvel-force-chart.surge.sh/marvel_force_chart_img/top_captainamerica.png"});
    _localStorage['history_data'] = _jsonEncoder.convert([
      {"idx": "Year", "name": "Year", "size": 0, "parent": ""},
      {"idx": "Jan", "name": "Jan", "size": 0, "parent": "Year"},
      {"idx": "Feb", "name": "Feb", "size": 0, "parent": "Year"},
      {"idx": "Mar", "name": "Mar", "size": 0, "parent": "Year"},
      {"idx": "Apr", "name": "Apr", "size": 0, "parent": "Year"},
      {"idx": "May", "name": "May", "size": 0, "parent": "Year"},
      {"idx": "Jun", "name": "Jun", "size": 0, "parent": "Year"},
      {"idx": "Jul", "name": "Jul", "size": 0, "parent": "Year"},
      {"idx": "Aug", "name": "Aug", "size": 0, "parent": "Year"},
      {"idx": "Sep", "name": "Sep", "size": 0, "parent": "Year"},
      {"idx": "Oct", "name": "Oct", "size": 0, "parent": "Year"},
      {"idx": "Nov", "name": "Nov", "size": 0, "parent": "Year"},
      {"idx": "Dec", "name": "Dec", "size": 0, "parent": "Year"},
      {"idx": "JanPost", "name": "Post", "size": 1, "parent": "Jan"},
      {"idx": "JanVid", "name": "Video", "size": 1, "parent": "Jan"},
      {"idx": "JanPhoto", "name": "Photo", "size": 1, "parent": "Jan"},
      {"idx": "FebPost", "name": "Post", "size": 1, "parent": "Feb"},
      {"idx": "FebVid", "name": "Video", "size": 1, "parent": "Feb"},
      {"idx": "FebPhoto", "name": "Photo", "size": 1, "parent": "Feb"},
      {"idx": "MarPost", "name": "Post", "size": 1, "parent": "Mar"},
      {"idx": "MarVid", "name": "Video", "size": 1, "parent": "Mar"},
      {"idx": "MarPhoto", "name": "Photo", "size": 1, "parent": "Mar"},
      {"idx": "AprPost", "name": "Post", "size": 1, "parent": "Apr"},
      {"idx": "AprVid", "name": "Video", "size": 1, "parent": "Apr"},
      {"idx": "AprPhoto", "name": "Photo", "size": 1, "parent": "Apr"},
      {"idx": "MayPost", "name": "Post", "size": 1, "parent": "May"},
      {"idx": "MayVid", "name": "Video", "size": 1, "parent": "May"},
      {"idx": "MayPhoto", "name": "Photo", "size": 1, "parent": "May"},
      {"idx": "JunPost", "name": "Post", "size": 1, "parent": "Jun"},
      {"idx": "JunVid", "name": "Video", "size": 1, "parent": "Jun"},
      {"idx": "JunPhoto", "name": "Photo", "size": 1, "parent": "Jun"},
      {"idx": "JulPost", "name": "Post", "size": 1, "parent": "Jul"},
      {"idx": "JulVid", "name": "Video", "size": 1, "parent": "Jul"},
      {"idx": "JulPhoto", "name": "Photo", "size": 1, "parent": "Jul"},
      {"idx": "AugPost", "name": "Post", "size": 1, "parent": "Aug"},
      {"idx": "AugVid", "name": "Video", "size": 1, "parent": "Aug"},
      {"idx": "AugPhoto", "name": "Photo", "size": 1, "parent": "Aug"},
      {"idx": "SepPost", "name": "Post", "size": 1, "parent": "Sep"},
      {"idx": "SepVid", "name": "Video", "size": 1, "parent": "Sep"},
      {"idx": "MarPhoto", "name": "Photo", "size": 1, "parent": "Sep"},
      {"idx": "OctPost", "name": "Post", "size": 1, "parent": "Oct"},
      {"idx": "OctVid", "name": "Video", "size": 1, "parent": "Oct"},
      {"idx": "OctPhoto", "name": "Photo", "size": 1, "parent": "Oct"},
      {"idx": "NovPost", "name": "Post", "size": 1, "parent": "Nov"},
      {"idx": "NovVid", "name": "Video", "size": 1, "parent": "Nov"},
      {"idx": "NovPhoto", "name": "Photo", "size": 1, "parent": "Nov"},
      {"idx": "DecPost", "name": "Post", "size": 1, "parent": "Dec"},
      {"idx": "DecVid", "name": "Video", "size": 1, "parent": "Dec"},
      {"idx": "DecPhoto", "name": "Photo", "size": 1, "parent": "Dec"}
    ]);
    ui.platformViewRegistry.registerViewFactory("history-sunburst",
        (int viewId) {
      print('ViewID $viewId');

      IFrameElement element = IFrameElement();
      window.onMessage.forEach((element) {
        print('Event Received in callback: ${element.data}');
      });

      element.src = 'assets/html/history.html';
      element.style.border = 'none';
      return element;
    });
    super.initState();
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<HistoryViewModel>.reactive(
      builder: (context, model, child) {
        final Storage _localStorage = window.localStorage;
        _localStorage['user_info'] = _jsonEncoder.convert(model.userInfo);

        return Scaffold(
          body: Center(
            child: Row(
              children: [
                TextButton(onPressed: () => model.changeUserInfo(), child: Text('Press me')),
                Container(
                  width: 450,
                  height: 450,
                  child: Center(
                    child: HtmlElementView(viewType: 'history-sunburst', key: Key(_jsonEncoder.convert(model.userInfo))),
                  ),
                ),
                Container(
                  width: 450,
                  height: 450,
                  child: Center(
                    child: HtmlElementView(viewType: 'history-sunburst'),
                  ),
                ),
                Container(
                  width: 450,
                  height: 450,
                  child: Center(
                    child: HtmlElementView(viewType: 'history-sunburst'),
                  ),
                ),
              ],
            )
          ),
        );
      },
      viewModelBuilder: () => _model,
      onModelReady: (model) => model.init(),
    );
  }
}
