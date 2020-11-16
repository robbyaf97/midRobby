import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<List<dsn>> fetchMhss(http.Client client) async {
  final response =
      await client.get('https://flutterrobby.000webhostapp.com/dsn.php');

  // Use the compute function to run parseMhss in a separate isolate.
  return compute(parseMhss, response.body);
}

// A function that converts a response body into a List<dsn>.
List<dsn> parseMhss(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();

  return parsed.map<dsn>((json) => dsn.fromJson(json)).toList();
}

class dsn {
  final String nidn;
  final String nama_dosen;
  final String jenjang_akademik;
  final String pendidikan_terakhir;
  final String home_base;

  dsn({this.nidn, this.nama_dosen, this.jenjang_akademik, this.pendidikan_terakhir, this.home_base});

  factory dsn.fromJson(Map<String, dynamic> json) {
    return dsn(
      nidn: json['nidn'] as String,
      nama_dosen: json['nama_dosen'] as String,
      jenjang_akademik: json['jenjang_akademik'] as String,
      pendidikan_terakhir: json['pendidikan_terakhir'] as String,
      home_base: json['home_base'] as String,
    );
  }
}

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appTitle = 'Data Dosen Bina Darma';

    return MaterialApp(
      title: appTitle,
      home: MyHomePage(title: appTitle),
    );
  }
}

class MyHomePage extends StatelessWidget {
  final String title;

  MyHomePage({Key key, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: FutureBuilder<List<dsn>>(
        future: fetchMhss(http.Client()),
        builder: (context, snapshot) {
          if (snapshot.hasError) print(snapshot.error);

          return snapshot.hasData
              ? MhssList(MhsData: snapshot.data)
              : Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}

class MhssList extends StatelessWidget {
  final List<dsn> MhsData;

  MhssList({Key key, this.MhsData}) : super(key: key);



Widget viewData(var data,int index)
{
return Container(
    width: 350,
    child: Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      color: Colors.yellow,
      elevation: 15,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
            //ClipRRect(
              //      borderRadius: BorderRadius.only(
                //      topLeft: Radius.circular(8.0),
                  //    topRight: Radius.circular(8.0),
                   // ),
                   // child: Image.network(
                    //    "https://elearning.binadarma.ac.id/pluginfile.php/1/theme_lambda/logo/1602057627/ubd_logo.png"
                    //    width: 100,
                     //   height: 50,
                        //fit:BoxFit.fill

                   // ),
                 // ),
            
          ListTile(
           //leading: Image.network(
             //   "https://elearning.binadarma.ac.id/pluginfile.php/1/theme_lambda/logo/1602057627/ubd_logo.png",
             // ),
            title: Text(data[index].nidn, style: TextStyle(color: Colors.black)),
            subtitle: Text(data[index].nama_dosen, style: TextStyle(color: Colors.black)),
          ),
          ListTile(
           //leading: Image.network(
             //   "https://elearning.binadarma.ac.id/pluginfile.php/1/theme_lambda/logo/1602057627/ubd_logo.png",
             // ),
            title: Text(data[index].jenjang_akademik, style: TextStyle(color: Colors.black)),
            subtitle: Text(data[index].home_base, style: TextStyle(color: Colors.black)),
          ),
          ButtonTheme.bar(
            child: ButtonBar(
              children: <Widget>[
                FlatButton(
                  child: const Text('Edit', style: TextStyle(color: Colors.black)),
                  onPressed: () {},
                ),
                FlatButton(
                  child: const Text('Delete', style: TextStyle(color: Colors.black)),
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}



  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
      ),
      itemCount: MhsData.length,
      itemBuilder: (context, index) {
        return viewData(MhsData,index);
      },
    );
  }
}