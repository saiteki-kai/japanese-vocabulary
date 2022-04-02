import 'dart:developer';

import 'package:flutter/material.dart';

class InsertWord extends StatefulWidget {
  const InsertWord({Key? key}) : super(key: key);

  @override
  State<InsertWord> createState() => _InsertWordState();
}

class _InsertWordState extends State<InsertWord> {
  List<bool> jlpt = [false, false, false, false, false];
  List<bool> pos = [
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false
  ];
  List<String> pos_names = [
    "adj-i",
    "adj-na",
    "adj-no",
    "adv",
    "aux",
    "aux-adj",
    "aux-v",
    "conj",
    "ctr",
    "exp",
    "int",
    "n",
    "n-adv",
    "n-pr",
    "pn",
    "pref",
    "prt",
    "suf",
    "vi",
    "vs-s",
    "vt"
  ];
  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.black,
            )),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Insert a new item'),
            IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.check,
                  color: Colors.black,
                ))
          ],
        ),
      ),
      body: Padding(
        padding:
            const EdgeInsets.only(top: 30, left: 30, right: 30, bottom: 30),
        child: Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            color: Colors.amber,
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              verticalDirection: VerticalDirection.down,
              children: [
                const Text(
                  "Text",
                  style: TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: 20,
                  ),
                ),
                const TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                ),
                const Text(
                  "Reading",
                  style: TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: 20,
                  ),
                ),
                const TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                ),
                const Text(
                  "Meaning",
                  style: TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: 20,
                  ),
                ),
                const TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                ),
                const Text(
                  "Part of speech",
                  style: TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: 20,
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: pos_names.length,
                    itemBuilder: (_, i) {
                      return ListTile(
                          title: Text(pos_names[i]),
                          onTap: () {
                            setState(() {
                              print("${pos_names[i]} : ${pos[i]}");
                              pos[i] = !pos[i];
                              print("${pos_names[i]} : ${pos[i]}");
                            });
                          });
                    },
                  ),
                ),
                const Text(
                  "JLPT",
                  style: TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: 20,
                  ),
                ),
                ToggleButtons(
                  children: [
                    Text("N5"),
                    Text("N4"),
                    Text("N3"),
                    Text("N2"),
                    Text("N1"),
                  ],
                  onPressed: (int index) {
                    setState(() {
                      for (int buttonIndex = 0;
                          buttonIndex < jlpt.length;
                          buttonIndex++) {
                        if (buttonIndex == index) {
                          jlpt[buttonIndex] = !jlpt[buttonIndex];
                        } else {
                          jlpt[buttonIndex] = false;
                        }
                      }
                    });
                  },
                  isSelected: jlpt,
                )
              ],
            ),
          ),
        ),
      ),
    ));
  }
}
