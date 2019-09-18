import 'package:flutter/material.dart';
import 'package:flutter_paging/flutter_paging.dart';

import 'smaple_data_source.dart';

class PagingListViewPage extends StatefulWidget {
  final StringDataSource dataSource = StringDataSource();

  @override
  _PagingListViewPageState createState() => _PagingListViewPageState();
}

class _PagingListViewPageState extends State<PagingListViewPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Paging ListView"),
      ),
      body: RefreshIndicator(
        onRefresh: widget.dataSource.refresh,
        child: PagingListView<String>.builder(
          itemBuilder: (context, index, item) {
            return Card(
                child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("paging->$item"),
            ));
          },
          dataSource: widget.dataSource,
          loadingIndicator: Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircularProgressIndicator(),
            ),
          ),
          noMoreDataAvailableItem: Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("no more data avaliable~"),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
//    widget.dataSource.close();
    super.dispose();
  }
}
