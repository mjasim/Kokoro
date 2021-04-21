import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kokoro/ui/views/planet_drilldown_view/planet_drilldown_viewmodel.dart';
import 'package:stacked/stacked.dart';
import 'dart:html';
import 'dart:ui' as ui;

class PlanetDrillDownView extends StatelessWidget {
  const PlanetDrillDownView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
//        ui.platformViewRegistry.registerViewFactory(
//            'hello-html',
//                (int viewId) => IFrameElement()
//                ..width = '640'
//                ..height = '360'
//                ..src = 'https://www.youtube.com/embed/xg4S67ZvsRs'
//                ..style.border = 'none');

    ui.platformViewRegistry.registerViewFactory("hello-html", (int viewId) {
      final Storage _localStorage = window.localStorage;
      final _jsonEncoder = JsonEncoder();
      _localStorage['test'] = _jsonEncoder.convert({'hello': 'world'});
      IFrameElement element = IFrameElement();
      window.onMessage.forEach((element) {
        print('Event Received in callback: ${element.data}');
        if (element.data == 'MODAL_CLOSED') {
          Navigator.pop(context);
        } else if (element.data == 'SUCCESS') {
          print('PAYMENT SUCCESSFULL!!!!!!!');
        }
      });

      element.src = 'assets/html/cpack.html';
      element.style.border = 'none';
      return element;
    });

    return ViewModelBuilder<PlanetDrillDownViewModel>.reactive(
      builder: (context, model, child) => Scaffold(
        body: Center(
          child: Container(
            width: 640,
            height: 640,
            child: HtmlElementView(viewType: 'hello-html'),
          ),
        ),
      ),
      viewModelBuilder: () => PlanetDrillDownViewModel(),
    );
  }
}
