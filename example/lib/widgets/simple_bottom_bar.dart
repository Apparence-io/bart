import 'package:bart/bart.dart';
import 'package:bart/bart/widgets/bottom_bar/styles/bottom_bar_custom.dart';
import 'package:flutter/material.dart';

class SimpleBottomBar extends BartBottomBarFactory {
  @override
  Widget create({
    required List<BartMenuRoute> routes,
    required void Function(int) onTap,
    required int currentIndex,
  }) {
    return Container(
      height: 85,
      decoration: BoxDecoration(
        color: Colors.blue,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.7),
            blurRadius: 3,
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            for (var i = 0; i < routes.length; i++)
              Expanded(
                child: GestureDetector(
                  onTap: () => onTap(i),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        routes[i].icon,
                        color: currentIndex == i ? Colors.white : Colors.black,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        routes[i].label!,
                        style: TextStyle(
                          color:
                              currentIndex == i ? Colors.white : Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
