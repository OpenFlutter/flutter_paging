import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_paging/flutter_paging.dart';

import 'paging_foundation.dart';
import 'paging_view.dart';

class PagingListView<T> extends StatelessWidget {
  final bool fromBuilder;

  /// If non-null, forces the children to have the given extent in the scroll
  /// direction.
  ///
  /// Specifying an [itemExtent] is more efficient than letting the children
  /// determine their own extent because the scrolling machinery can make use of
  /// the foreknowledge of the children's extent to save work, for example when
  /// the scroll position changes drastically.
  final double itemExtent;

  final Axis scrollDirection;
  final bool reverse;
  final ScrollController controller;
  final bool primary;
  final ScrollPhysics physics;
  final bool shrinkWrap;
  final EdgeInsetsGeometry padding;

  final PagingItemWidgetBuilder<T> itemBuilder;

  final IndexedWidgetBuilder separatorBuilder;

  final bool addAutomaticKeepAlives;

  final bool addRepaintBoundaries;
  final bool addSemanticIndexes;
  final double cacheExtent;
  final int semanticChildCount;
  final DragStartBehavior dragStartBehavior;

  final KeyedDataSource<T> dataSource;

  final Widget loadingIndicator;
  final Widget noMoreDataAvailableItem;

  PagingListView.builder(
      {Key key,
      this.scrollDirection = Axis.vertical,
      this.reverse = false,
      this.controller,
      this.primary,
      this.physics,
      this.shrinkWrap = false,
      this.padding,
      this.itemExtent,
      @required this.itemBuilder,
      @required this.dataSource,
      this.addAutomaticKeepAlives = true,
      this.addRepaintBoundaries = true,
      this.addSemanticIndexes = true,
      this.cacheExtent,
      this.semanticChildCount,
      this.dragStartBehavior = DragStartBehavior.start,
      this.loadingIndicator,
      this.noMoreDataAvailableItem})
      : assert(dataSource != null),
        assert(itemBuilder != null),
        separatorBuilder = null,
        fromBuilder = true;

  PagingListView.separated(
      {Key key,
      this.scrollDirection = Axis.vertical,
      this.reverse = false,
      this.controller,
      this.primary,
      this.physics,
      this.shrinkWrap = false,
      this.padding,
      @required this.itemBuilder,
      @required this.separatorBuilder,
      @required this.dataSource,
      this.addAutomaticKeepAlives = true,
      this.addRepaintBoundaries = true,
      this.addSemanticIndexes = true,
      this.cacheExtent,
      this.loadingIndicator,
      this.noMoreDataAvailableItem})
      : assert(dataSource != null),
        assert(itemBuilder != null),
        assert(separatorBuilder != null),
        dragStartBehavior = null,
        semanticChildCount = null,
        itemExtent = null,
        fromBuilder = false;

  @override
  Widget build(BuildContext context) {
    return PagingView<T>(
        dataSource: dataSource,
        builder: (context, items) {
          int itemCount = 1;
          if (items != null) {
            itemCount = items.length + 1;
          }
          return ListView.builder(
            scrollDirection: scrollDirection,
            reverse: reverse,
            controller: controller,
            primary: primary,
            physics: physics,
            shrinkWrap: shrinkWrap,
            padding: padding,
            itemExtent: itemExtent,
            addAutomaticKeepAlives: addAutomaticKeepAlives,
            addSemanticIndexes: addSemanticIndexes,
            cacheExtent: cacheExtent,
            semanticChildCount: semanticChildCount,
            dragStartBehavior: dragStartBehavior,
            itemBuilder: (context, index) {
              dataSource.inPagingDataIndex.add(index);
              var lists = items;
              final T value =
                  (lists != null && lists.length > index) ? lists[index] : null;

              if (value == null) {
                if (dataSource.noMoreDataAvailable) {
                  return noMoreDataAvailableItem == null
                      ? Container()
                      : noMoreDataAvailableItem;
                } else {
                  return loadingIndicator == null
                      ? Container()
                      : loadingIndicator;
                }
              } else {
                return itemBuilder(context, index, value);
              }
            },
            itemCount: itemCount,
          );
        });
  }
}
