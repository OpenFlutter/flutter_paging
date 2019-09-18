import 'package:flutter/widgets.dart';
import 'package:flutter_paging/flutter_paging.dart';

import 'keyed_data_source.dart';

class PagingView<Value> extends StatefulWidget {
  final KeyedDataSource<Value> dataSource;
  final PagingWidgetBuilder builder;
  final bool autoCloseStream;

  const PagingView(
      {Key key,
      @required this.dataSource,
      @required this.builder,
      this.autoCloseStream = true})
      : assert(dataSource != null),
        assert(builder != null),
        super(key: key);

  @override
  _PagingViewState createState() => _PagingViewState();
}

class _PagingViewState<Value> extends State<PagingView> {
  KeyedDataSource<Value> get dataSource => widget.dataSource;

  @override
  void dispose() {
    if(widget.autoCloseStream == true){
      dataSource?.close();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Value>>(
        initialData: [],
        stream: dataSource.outPagingData,
        builder: (context, snapshot) {
          return widget.builder(context,snapshot.data);
        });
  }
}
