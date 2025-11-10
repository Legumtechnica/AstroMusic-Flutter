import 'package:flutter/material.dart';
import 'package:astro_music/config/size_config.dart';
import 'package:astro_music/provider/base_view.dart';
import 'package:astro_music/view/splash_screen_view_model.dart';
import 'components/body.dart';

class SplashScreen extends StatelessWidget {
  static String routeName = '/splash-screen';
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return BaseView<SplashScreenViewModel>(
        onModelReady: (model) => {
              model.animateSlider(1, context),
            },
        builder: (context, model, child) {
          return Scaffold(
            body: Body(
              model: model,
            ),
          );
        });
  }
}
