import 'package:flutter/material.dart';
import 'package:get/get.dart';
class SettingScreen extends StatelessWidget {
  const SettingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Setting Screen'.tr)),
      body: Center(
        child: Text(
          'Welcome to the Setting Screen!'.tr,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
    );
  }
}
