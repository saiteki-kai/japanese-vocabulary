import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("View words"),
      ),
      body: ListView(
        padding: const EdgeInsets.all(8),
        shrinkWrap: true,
        children: [
          Card(
              child: ListTile(
            title: Text("List Item 1"),
            subtitle: Text("review time"),
          )),
          Card(
              child: ListTile(
            title: Text("List Item 2"),
            subtitle: Text("review time"),
          )),
          Card(
              child: ListTile(
            title: Text("List Item 3"),
            subtitle: Text("review time"),
          )),
        ],
      ),
    );
  }
}
