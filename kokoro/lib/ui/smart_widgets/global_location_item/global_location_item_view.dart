import 'package:flutter/material.dart';
import 'package:kokoro/ui/smart_widgets/global_location_item/global_location_item_viewmodel.dart';
import 'package:stacked/stacked.dart';

class GlobalLocationItemView extends StatelessWidget {
  const GlobalLocationItemView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<GlobalLocationItemViewModel>.reactive(
      builder: (context, model, child) => !model.isClicked
          ? GestureDetector(
              child: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFFe0f2f1),
                ),
              ),
              onTap: () {
                model.clicked();
              },
            )
          : Stack(
              children: [
                GestureDetector(
                  child: Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.red,
                    ),
                  ),
                  onTap: () {
                    model.clicked();
                  },
                )
              ],
            ),
      viewModelBuilder: () => GlobalLocationItemViewModel(),
    );
  }
}
