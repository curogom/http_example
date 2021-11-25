import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http_example/connect.dart';
import 'package:http/http.dart' as http;
import 'package:http_example/dog_response.dart';

class DogsGrid extends StatefulWidget {
  const DogsGrid({Key? key}) : super(key: key);

  @override
  _DogsGridState createState() => _DogsGridState();
}

class _DogsGridState extends State<DogsGrid> {
  List<String> dogImages = [];

  addDogImages(http.Response response) {
    DogResponse dogResponse = DogResponse.fromJson(jsonDecode(response.body));
    dogImages = dogImages + dogResponse.message;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cute Dogs')),
      body: FutureBuilder(
          future: fetchDogs(28),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasData) {
                http.Response response = snapshot.data;
                addDogImages(response);

                return GridView.builder(
                  itemBuilder: (BuildContext context, int i) {
                    if (i < dogImages.length) {
                      fetchDogs(18).then((http.Response response) {
                        addDogImages(response);
                      });
                    }

                    return Image.network(dogImages[i]);
                  },
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3, //1 개의 행에 보여줄 item 개수
                    childAspectRatio: 1 / 1, //item 의 가로 1, 세로 2 의 비율
                    mainAxisSpacing: 3, //수평 Padding
                    crossAxisSpacing: 10, //수직 Padding
                  ),
                );
              }
            }
            return const Center(child: CircularProgressIndicator(),);
          }),
    );
  }
}