import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("View words", style: TextStyle(fontSize: 25)),
      ),
      body: ListView.builder(
        itemBuilder: (BuildContext, index) {
          return Card(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 8, left: 5, bottom: 8),
                      child: Text("Word list",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 12, bottom: 8),
                      child: Text("Next date review"),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 4, right: 4, bottom: 4),
                      child: CircularPercentIndicator(
                        radius: 32.0,
                        lineWidth: 32 / 4,
                        percent: .90,
                        center: new Text("90%"),
                        progressColor: Colors.green,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
        padding: const EdgeInsets.all(8),
        shrinkWrap: true,
      ),
    );
  }
}
