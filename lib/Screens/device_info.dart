import 'package:flutter/material.dart';

class DeviceSize {
  double width, height;
  DeviceSize(BuildContext context) {
    this.height = MediaQuery.of(context).size.height;
    this.width = MediaQuery.of(context).size.height;
  }
}
