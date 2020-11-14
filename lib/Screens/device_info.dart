import 'package:flutter/material.dart';

class DeviceSize {
  DeviceSize(BuildContext context) {
    this.height = MediaQuery.of(context).size.height;
    this.width = MediaQuery.of(context).size.height;
  }

  double width, height;
}
