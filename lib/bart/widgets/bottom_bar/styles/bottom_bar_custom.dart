import 'package:bart/bart/bart_model.dart';
import 'package:flutter/material.dart';

abstract class BartBottomBarCustom {
  const BartBottomBarCustom();

  @factory
  Widget create({
    required List<BartMenuRoute> routes,
    required void Function(int) onTap,
    required final int currentIndex,
  });
}
