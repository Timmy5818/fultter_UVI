import 'package:flutter/material.dart';
import 'api_server.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '即時紫外線指數',
      home: Scaffold(
        appBar: AppBar(),
        body: const UVIList(),
      ),
    );
  }
}

class UVIList extends StatefulWidget {
  const UVIList({Key? key}) : super(key: key);
  @override
  _UVIListState createState() => _UVIListState();
}

class _UVIListState extends State<UVIList> {
  Future<List<Station>>? futureStationList;

  @override
  void initState() {
    super.initState();
    futureStationList = fetchUVI();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder<List<Station>>(
        future: futureStationList,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            print(snapshot.data);
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                print('build ${index}');
                return ListTile(
                  title: Text(snapshot.data![index].siteName),
                  subtitle: Text(snapshot.data![index].UVI.toString()),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
