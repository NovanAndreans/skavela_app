import 'package:flutter/material.dart';

class AppLoading {
  static final ValueNotifier<bool> isLoading = ValueNotifier(false);
  static final ValueNotifier<String> message =
      ValueNotifier("Loading...");

  static void show([String msg = "Loading..."]) {
    message.value = msg;
    isLoading.value = true;
  }

  static void hide() {
    isLoading.value = false;
  }
}