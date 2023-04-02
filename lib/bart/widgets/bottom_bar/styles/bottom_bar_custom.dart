import 'package:bart/bart/bart_model.dart';
import 'package:flutter/material.dart';

abstract class BartBottomBarFactory {
  const BartBottomBarFactory();

  @factory
  Widget create({
    required BuildContext context,
    required List<BartMenuRoute> routes,
    required void Function(int) onTap,
    required final int currentIndex,
  });
}
