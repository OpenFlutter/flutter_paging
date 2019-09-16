import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_paging/flutter_paging.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  final StringDataSource dataSource = StringDataSource();

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: RefreshIndicator(
        onRefresh: _handleRefresh,
        child: StreamBuilder<List<String>>(
            stream: dataSource.outPagingData,
            initialData: [],
            builder: (context, snapshot) {
              return ListView.builder(
                itemBuilder: (context, index) {
                  dataSource.inPagingDataIndex.add(index);
                  var lists = snapshot.data;
                  final String value = (lists != null && lists.length > index)
                      ? lists[index]
                      : null;
                  if (value == null) {
                    return Center(child: CircularProgressIndicator());
                  } else {
                    return Text(value);
                  }
                },
                itemCount: snapshot.data.length + 1,
              );
            }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Future<void> _handleRefresh() {
    final Completer<void> completer = Completer<void>();
    Timer(const Duration(seconds: 1), () {
      completer.complete();
    });
    return completer.future.then<void>((_) {
      dataSource.inPagingDataIndex.add(-1);
    });
  }

  @override
  void dispose() {
    dataSource.close();
    super.dispose();
  }
}

class StringDataSource with KeyedDataSource<String> {
  StringDataSource() {
    init();
  }

  @override
  Future<List<String>> loadAfter(String value) {
    int seconds = 1;
    if(int.parse(value)/2 ==0){
      seconds = 2;
    }else if(int.parse(value)/3 ==0){
      seconds = 3;
    }

    return Future.delayed(Duration(seconds: seconds), () {
      return Future.value(
          List.generate(pageSize, (index) => "${int.parse(value)+1 + index}"));
    });
  }

  @override
  Future<List<String>> loadInitial() {
    return Future.delayed(Duration(seconds: 3), () {
      return Future.value(List.generate(pageSize, (index) => "$index"));
    });
  }

  @override
  int get pageSize => 10;
}
