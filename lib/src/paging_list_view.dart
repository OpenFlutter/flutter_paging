import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_paging/flutter_paging.dart';
import 'paging_foundation.dart';

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

  final PagingWidgetBuilder<T> itemBuilder;

  final IndexedWidgetBuilder separatorBuilder;

  final bool addAutomaticKeepAlives;

  final bool addRepaintBoundaries;
  final bool addSemanticIndexes;
  final double cacheExtent;
  final int semanticChildCount;
  final DragStartBehavior dragStartBehavior;

  final KeyedDataSource dataSource;


  final Widget loadingIndicator;

  PagingListView.builder({
    Key key,
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
  })
      : separatorBuilder = null,
        fromBuilder=true;

  PagingListView.separated({Key key,
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
    this.loadingIndicator
  })
      : dragStartBehavior = null,
        semanticChildCount = null,
        itemExtent = null,
        fromBuilder = false;



  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<T>>(
        stream: dataSource.outPagingData,
        initialData: null,
        builder: (context, snapshot) {
          int itemCount = snapshot?.data?.length ?? 0 + 1;
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
              var lists = snapshot.data;
              final T value =
              (lists != null && lists.length > index) ? lists[index] : null;
              if (value == null) {
                return loadingIndicator == null
                    ? Container()
                    : loadingIndicator;
              } else {
                return itemBuilder(context, index, value);
              }
            },
            itemCount: itemCount,
          );
        });
  }
}



