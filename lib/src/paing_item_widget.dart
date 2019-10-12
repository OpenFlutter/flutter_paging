import 'package:flutter/widgets.dart';

import '../flutter_paging.dart';
import 'paging_foundation.dart';

class PagingItemWidget<T> extends StatelessWidget {
  final PagingItemWidgetBuilder<T> itemBuilder;
  final KeyedDataSource<T> dataSource;

  final Widget loadingIndicator;
  final Widget noMoreDataAvailableItem;

  final int index;
  final List<T> snapshot;

  const PagingItemWidget(
      {Key key,
      @required this.itemBuilder,
      @required this.dataSource,
      this.loadingIndicator,
      this.noMoreDataAvailableItem,
      @required this.index,
      @required this.snapshot})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    dataSource.inPagingDataIndex.add(index);
    final T value =
        (snapshot != null && snapshot.length > index) ? snapshot[index] : null;

    if (value == null) {
      if (dataSource.noMoreDataAvailable) {
        return noMoreDataAvailableItem == null
            ? Container()
            : noMoreDataAvailableItem;
      } else {
        return loadingIndicator == null ? Container() : loadingIndicator;
      }
    } else {
      return itemBuilder(context, index, value);
    }
  }
}
