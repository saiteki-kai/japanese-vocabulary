import 'package:flutter/material.dart';

class WordsScreen extends StatefulWidget {
  const WordsScreen({Key? key}) : super(key: key);

  @override
  State<WordsScreen> createState() => _WordsScreenState();
}

class _WordsScreenState extends State<WordsScreen> {
  String text = "Default";
  int _currentIndex = 0;
  List<int> contenido = [0, 1];
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.max,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      TextButton(onPressed: () {}, child: const Text("Words")),
                      TextButton(onPressed: () {}, child: const Text("Kanji")),
                    ],
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.sort),
                        onPressed: () {},
                      ),
                      IconButton(
                        icon: const Icon(Icons.tune),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ],
              ),
              Row(
                children: [
                  const Icon(Icons.search),
                  const Expanded(
                    child: TextField(
                      decoration: InputDecoration(hintText: "Item to search"),
                    ),
                  ),
                  IconButton(onPressed: () {}, icon: const Icon(Icons.cancel)),
                ],
              ),
              Center(
                  child: TextButton(
                child: const Text("Click here"),
                onPressed: () {
                  setState(() {
                    text = "Edited";
                    contenido.add(contenido.length);
                  });
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text("Hello world!"),
                    duration: Duration(seconds: 1),
                  ));
                },
              )),
              Expanded(
                  child: ListView.separated(
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return Text("Item ${contenido[index]}");
                      },
                      separatorBuilder: (context, index) {
                        return Divider(
                          thickness: 6,
                          color: Colors.purple,
                        );
                      },
                      itemCount: contenido.length))
            ],
          ),
        ),
      );
  }
}