import 'package:flutter_paging/flutter_paging.dart';

class StringDataSource extends KeyedDataSource<String> {

  @override
  Future<List<String>> loadAfter(String value) {
    if (int.parse(value) > 100) {
      return Future.value([]);
    }

    int seconds = 1;
    if (int.parse(value) / 2 == 0) {
      seconds = 2;
    } else if (int.parse(value) / 3 == 0) {
      seconds = 3;
    }

    return Future.delayed(Duration(seconds: seconds), () {
      return Future.value(List.generate(
          pageSize, (index) => "${int.parse(value) + 1 + index}"));
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
