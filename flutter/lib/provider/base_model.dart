import 'package:flutter/material.dart';
import 'package:astro_music/enum/view_state.dart';
import 'package:astro_music/service/navigation_service.dart';
import 'getit.dart';

class BaseModel extends ChangeNotifier {
  final navigationService = getIt<NavigationService>();
  ViewState _state = ViewState.Idle;

  ViewState get state => _state;
  void setState(ViewState viewState) {
    _state = viewState;
    notifyListeners();
  }
}
