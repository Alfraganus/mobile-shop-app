import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/models/singleSale.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
String _email='';
Future<List<SingleSale>> fetchAlbums(String url) async {
  try {
    final http.Response response = await http.get(
        Uri.parse(url)
    );
    print(jsonDecode(response.body));
    if (response.statusCode == 200) {
      return SingleSale.fetchData(jsonList: jsonDecode(response.body));
    }
    else {
      throw Exception('Failed to load sales');
    }

  }catch(e) {
    print(e);
  }
}



class FinishedSale extends StatefulWidget {
  @override
  _FinishedSaleState createState() => _FinishedSaleState();
  final int id;
  const FinishedSale({Key key, this.id}) : super(key: key);

}

class _FinishedSaleState extends State<FinishedSale> {
  Future<List<SingleSale>> futureAlbum;

  @protected
  void initState() {
    futureAlbum = fetchAlbums('https://api.spector77.uz/rest/sales/single-sale?expand=productCategory&sale_id=${widget.id}');
    _loadCounter();
    super.initState();
  }
  _loadCounter() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _email = (prefs.getString('token')??'');
      print(_email);
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('Sotilgan maxsulotlar'),
      ),
      body: Center(
        child: FutureBuilder<List<SingleSale>>(
          future: futureAlbum,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                  itemCount: snapshot.data.length,
                  // physics: Scrollable.of(context),
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        Card(
                            child: ListTile(
                              title: Text(snapshot.data[index].name),
                              subtitle:Text(snapshot.data[index].price.toString()+' so\'m'),
                              trailing:Text(snapshot.data[index].quantity.toString()+' dona'),
                            )
                        ),
                      ],
                    );
                  }
              );
            }
            else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            }
            return CircularProgressIndicator();
          },
        ),
      ),

    );

  }
}



