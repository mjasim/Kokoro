import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kokoro/ui/views/planet_drilldown_view/planet_drilldown_viewmodel.dart';
import 'package:stacked/stacked.dart';
import 'dart:html';
import 'dart:ui' as ui;


class PlanetDrillDownView extends StatefulWidget {
  @override
  _PlanetDrillDownViewState createState() => _PlanetDrillDownViewState();
}

class _PlanetDrillDownViewState extends State<PlanetDrillDownView> {
  static final _jsonEncoder = JsonEncoder();

  static PlanetDrillDownViewModel _model = PlanetDrillDownViewModel();

  @override
  void initState() {
    ui.platformViewRegistry.registerViewFactory("circle-packing", (int viewId) {
      final Storage _localStorage = window.localStorage;
      _model.init();
      _localStorage['planet_data'] = _jsonEncoder.convert(_model.drillDownData);
      _localStorage['planet_pic'] =
          _jsonEncoder.convert("../images/circle-cropped(2).png");
      IFrameElement element = IFrameElement();
      window.onMessage.forEach((element) {
        print('Event Received in callback: ${element.data}');
      });

      element.src = 'assets/html/cpack.html';
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


    return ViewModelBuilder<PlanetDrillDownViewModel>.reactive(
      builder: (context, model, child) {
        return Scaffold(
          body: Center(
            child: Container(
              width: 640,
              height: 640,
              child: HtmlElementView(viewType: 'circle-packing'),
            ),
          ),
        );
      },
      onModelReady: (model) => model.init(),
      viewModelBuilder: () => _model,
    );
  }
}

