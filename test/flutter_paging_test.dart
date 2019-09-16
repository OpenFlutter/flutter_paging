import 'package:flutter_paging/flutter_paging.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

void main() {
  FakePagingDataSource dataSource;

  setUp(() {
    dataSource = FakePagingDataSource();
    dataSource.init();

  });

  test('init', () {
    dataSource.init();
    verify(dataSource.init());
  });

}

class FakePagingDataSource extends Mock implements KeyedDataSource<String> {}
