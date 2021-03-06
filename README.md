# flutter_paging [![pub package](https://img.shields.io/pub/v/flutter_paging.svg)](https://pub.dartlang.org/packages/flutter_paging)

Paging your widgets. Decoupling UI and data.


<img src="https://github.com/OpenFlutter/flutter_paging/blob/master/arts/paging.gif" width="300" height="480">


Note: This plugin is still under development. [Pull Requests](https://github.com/OpenFlutter/flutter_paging/pulls) are most welcome.


## Installation

First, add `flutter_paging` as a [dependency in your pubspec.yaml file](https://flutter.io/using-packages/).

## Widgets Included

- PagingView : Base paging view.

- PagingListView : Quick implementation of ListView supports paging.

## KeyedDataSource

`KeyedDataSource` is core of paging. Try something else with `KeyedDataSource`  

Note: don't forget to call `dataSource.init()`


## Example

```dart

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

```

