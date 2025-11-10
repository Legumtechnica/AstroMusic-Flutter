import 'package:flutter/material.dart';
import 'package:astro_music/provider/base_view.dart';
import 'package:astro_music/src/widgets/bottom_nav_bar.dart';
import 'package:astro_music/view/discover_screen_view_model.dart';
import 'components/body.dart';

class DiscoverScreen extends StatelessWidget {
  static String routeName = '/discover-screen';
  const DiscoverScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseView<DiscoverScreenViewModel>(
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
