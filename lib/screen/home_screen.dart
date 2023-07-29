import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:http_flutter/configs/config.dart';
import 'dart:convert';
import 'dart:io';

import 'package:http_flutter/models/album_model.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<Album> futureAlbum;

  Future<Album> fetchAlbum() async {
    final response =
        await http.get(Uri.parse('${Config.apiUrl}/albums/1'), headers: {
      HttpHeaders.authorizationHeader: '${Config.apiToken}',
    });

    if (response.statusCode == 200) {
      return Album.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Falló carga de album');
    }
  }

  @override
  void initState() {
    super.initState();
    futureAlbum = fetchAlbum();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('HTTP'),
        ),
        body: Center(
          child: FutureBuilder<Album>(
              future: futureAlbum,
              builder: (context, snapshop) {
                if (snapshop.hasData) {
                  return Text(snapshop.data!.title);
                } else if (snapshop.hasError) {
                  return Text('${snapshop.error}');
                }
                return const CircularProgressIndicator();
              }),
        ));
  }
}
