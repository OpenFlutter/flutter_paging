import 'dart:async';

import 'package:rxdart/rxdart.dart';

abstract class KeyedDataSource<Value> {

  Completer<Value> completer = Completer();

  final _fetchedPagingData = <int, List<Value>>{};
  final _pagingDataBeingFetched = Set<int>();

  PublishSubject<int> _pagingDataIndexController = PublishSubject<int>();

  Sink<int> get inPagingDataIndex => _pagingDataIndexController.sink;

  BehaviorSubject<List<Value>> _pagingDataController = BehaviorSubject();

  Sink<List<Value>> get _inPagingDataList => _pagingDataController.sink;
  Stream<List<Value>> get outPagingData => _pagingDataController.stream;



  int get pageSize;

  void init() {
    _pagingDataIndexController
        .bufferTime(Duration(microseconds: 500))
        // and, do not update where this is no need
        .where((batch) => batch.isNotEmpty)
        .listen(_handlePagingIndexes);
  }

  void _handlePagingIndexes(List<int> indexes) {
    indexes.forEach((index) {
      if (index < 0) {
        _pagingDataBeingFetched.clear();
        _fetchedPagingData.clear();
        _inPagingDataList.add([]);
        return;
      }
      final int pageIndex = 1 + (index + 1) ~/ pageSize ?? 10;
      if (!_fetchedPagingData.containsKey(pageIndex)) {
        if (!_pagingDataBeingFetched.contains(pageIndex)) {
          _pagingDataBeingFetched.add(pageIndex);
          var preIndex = pageIndex - 1;
          if (preIndex != 0) {
            if (_fetchedPagingData[preIndex].isNotEmpty) {
              loadAfter(_fetchedPagingData[preIndex].last)
                  .then((newData) => _handleFetchedData(newData, pageIndex));
            }
          } else {
            loadInitial().then((newData) {
              _handleFetchedData(newData, pageIndex);
              completer?.complete();
            }).catchError((error){
              completer?.complete();
            });
          }
        }
      }
    });
  }

  void _handleFetchedData(List<Value> orderItems, int pageIndex) {
    _fetchedPagingData[pageIndex] = orderItems;
    _pagingDataBeingFetched.remove(pageIndex);

    List<Value> orders = [];
    List<int> pageIndexes = _fetchedPagingData.keys.toList();
    pageIndexes.sort((a, b) => a.compareTo(b));

    final int minPageIndex = pageIndexes[0];
    final int maxPageIndex = pageIndexes[pageIndexes.length - 1];

    if (minPageIndex == 1) {
      for (int i = 1; i <= maxPageIndex; i++) {
        if (!_fetchedPagingData.containsKey(i)) {
          // As soon as there is a hole, stop
          break;
        }
        // Add the list of fetched movies to the list
        orders.addAll(_fetchedPagingData[i]);
      }
    }

    if (orders.isNotEmpty) {
      _inPagingDataList.add(orders);
    }
  }

  void close() {
    _pagingDataIndexController.close();
    _pagingDataController.close();
  }


  Future<List<Value>> loadInitial();

  Future<List<Value>> loadAfter(Value value);
}
