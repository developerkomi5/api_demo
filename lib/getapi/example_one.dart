import 'dart:convert';
import 'package:api_demo/models/posts_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ExampleOne extends StatefulWidget {
  const ExampleOne({super.key});

  @override
  State<ExampleOne> createState() => _ExampleOneState();
}

class _ExampleOneState extends State<ExampleOne> {
  //PostsModel is stored in postList array
  List<PostsModel> postList = [];
  //for hitting the api/ receiving the response of api and parse it to PostsModel
  Future<List<PostsModel>> getPostApi() async {
    final response =
        await http.get(Uri.parse('https://jsonplaceholder.typicode.com/posts'));
    var data = jsonDecode(response.body.toString());
    if (response.statusCode == 200) {
      postList
          .clear(); //for not refreshing the data all the time you do hot reload
      for (Map i in data) {
        //adding all the data of that url/api if status code is 200
        postList.add(PostsModel.fromJson(i));
      }
      return postList;
    } else {
      return postList;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("API Demo"),
      ),
      body: Column(
        children: [
          //expanded widget is for having all data in our screen in scrollable mode
          Expanded(
            //future function is for running the app when postapi is call
            child: FutureBuilder(
              future: getPostApi(),
              builder: (context, snapshot) {
                //till the response is not received this if is executed
                if (!snapshot.hasData) {
                  return Text('Loading...');
                } else {
                  return ListView.builder(
                      itemCount: postList.length,
                      itemBuilder: (context, index) {
                        return Card(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Title',
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(postList[index].title.toString()),
                                const SizedBox(height: 5),
                                const Text(
                                  'Description',
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 5),
                                Text(postList[index].body.toString()),
                              ],
                            ),
                          ),
                        );
                      });
                }
              },
            ),
          )
        ],
      ),
    );
  }
}
