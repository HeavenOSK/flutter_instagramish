import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instagramish/instagramish.dart';

const colors = [
  Colors.blue,
  Colors.green,
  Colors.red,
  Colors.amber,
  Colors.purpleAccent,
  Colors.blue,
  Colors.green,
];

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ValueNotifier<int> currentIndexController = ValueNotifier<int>(0);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.white,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Scaffold(
        appBar: CupertinoNavigationBar(
          middle: Text('$WheelDotsIndicator\'s Example'),
        ),
        body: Column(
          children: [
            const SizedBox(height: 28),
            AspectRatio(
              aspectRatio: 1,
              child: PageView(
                children:
                    colors.map((color) => ColoredBox(color: color)).toList(),
                onPageChanged: (page) {
                  currentIndexController.value = page;
                },
              ),
            ),
            const SizedBox(height: 6),
            WheelDotsIndicator(
              itemCount: colors.length,
              indexController: currentIndexController,
            ),
          ],
        ),
      ),
    );
  }
}
