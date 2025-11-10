import 'package:flutter/material.dart';
import 'package:astro_music/provider/base_view.dart';
import 'package:astro_music/view/premium_screen_view_model.dart';

import 'components/body.dart';

class PremiumScreen extends StatelessWidget {
  static String routeName = '/premium-screen';
  const PremiumScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseView<PremiumScreenViewModel>(
        onModelReady: (model) => {},
        builder: (context, model, child) {
          return Scaffold(
            backgroundColor: Color(0xff6a6886),
            body: Body(
              model: model,
            ),
          );
        });
  }
}
