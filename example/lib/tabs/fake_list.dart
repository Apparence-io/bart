import 'package:flutter/material.dart';

class FakeListPage extends StatelessWidget {
  const FakeListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: ListView.builder(
        itemExtent: 250.0,
        itemBuilder: (BuildContext context, int index) => Container(
          padding: const EdgeInsets.all(10.0),
          child: Material(
            color: index.isEven ? Colors.cyan : Colors.deepOrange,
            child: Center(
              child: Text(index.toString()),
            ),
          ),
        ),
      ),
    );
  }
}
