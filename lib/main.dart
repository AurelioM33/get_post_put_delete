import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get_post_put_delete/post.dart';
import 'dart:async';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'http packges',
      theme: ThemeData(
        primarySwatch: Colors.amber,
        primaryColor: Colors.blue,
      ),
      home: const HomeWidget(),
    );
  }
}
//Get Api request

Future<Post> fetchPost() async {
  final uri = Uri.parse("https://jsonplaceholder.typicode.com/posts/1");
  final response = await http.get(uri);

  if (response.statusCode == 200) {
    return Post.fromjson(
      json.decode(response.body),
    );
  } else {
    throw Exception('Falha ao carregar o Post');
  }
}

//Post Api Request

Future<void> createPost(String title, String body) async {
  Post newpost = Post(id: 1, userId: 1, title: title, description: body);
  Map<String, dynamic> postData = newpost.toJson();
  String json = jsonEncode(postData);

  final uri = Uri.parse("https://jsonplaceholder.typicode.com/posts");
  final response = await http.post(uri, body: json);

  if (response.statusCode == 201) {
    print("Cadastrado com sucesso");
  } else {
    throw Exception('Falha ao carregar o Post');
  }
}

//Update Api Request

Future<void> updatePost(int id, String title, String body) async {
  int postId = id;
  Post data = Post(id: 1, userId: 1, title: title, description: body);
  Map<String, dynamic> updateData = data.toJson();
  String json = jsonEncode(updateData);

  final uri = Uri.parse("https://jsonplaceholder.typicode.com/posts/$postId");
  final response = await http.put(uri, body: json);

  if (response.statusCode == 200) {
    print("Atualizado com sucesso");
  } else {
    throw Exception('Falha ao carregar o post');
  }
}

// Delete Api Request

Future<void> deletePost(int id) async {
  final uri = Uri.parse("https://jsonplaceholder.typicode.com/posts/${id}");
  final response = await http.delete(uri);

  if (response.statusCode == 200) {
    print("Apagado com sucesso");
  } else {
    throw Exception('Falha ao carregar o post');
  }
}

class HomeWidget extends StatefulWidget {
  const HomeWidget({super.key});

  @override
  State<HomeWidget> createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  Future<Post?>? post;

  void clickGetButton() {
    setState(() {
      post = fetchPost();
    });
  }

  void clickDeleteButton() {
    setState(() {
      deletePost(1);
    });
  }

  void clickPostButton() {
    setState(() {
      createPost("Top Post", "Esse é um exemplo post");
    });
  }

  void clickUpdateButton() {
    setState(() {
      updatePost(1, "Update Post", "Nova atualização exemplo post");
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: const Center(
            child: Text("http package"),
          ),
        ),
        body: SizedBox(
          height: 550,
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              FutureBuilder<Post?>(
                future: post,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text("${snapshot.error}");
                  } else {
                    return Container();
                  }
                },
              ),
              SizedBox(
                width: 200,
                child: ElevatedButton(
                  onPressed: () => clickGetButton(),
                  child: const Text("GET"),
                ),
              ),
              SizedBox(
                width: 200,
                child: ElevatedButton(
                  onPressed: () => clickPostButton(),
                  child: const Text("POST"),
                ),
              ),
              SizedBox(
                width: 200,
                child: ElevatedButton(
                  onPressed: () => clickUpdateButton(),
                  child: const Text("UPDATE"),
                ),
              ),
              SizedBox(
                width: 200,
                child: ElevatedButton(
                  onPressed: () => clickDeleteButton(),
                  child: const Text("DELETE"),
                ),
              ),
            ],
          ),
        ),
      );
}

Widget buildDataWidget(context, snapshot) => Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: Text(
            snapshot.data.title,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            snapshot.data.description,
          ),
        ),
      ],
    );
