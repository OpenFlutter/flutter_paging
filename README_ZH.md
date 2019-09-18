# flutter_paging [![pub package](https://img.shields.io/pub/v/flutter_paging.svg)](https://pub.dartlang.org/packages/flutter_paging)

分布加载，实现数据与UI解耦。


<img src="https://github.com/OpenFlutter/flutter_paging/blob/master/arts/paging.gif" width="300" height="480">


Note: 这个项目还处于开发阶段. 欢迎[Pull Requests](https://github.com/OpenFlutter/flutter_paging/pulls).


## 安装

首先, 添加 `flutter_paging`，参加[dependency in your pubspec.yaml file](https://flutter.io/using-packages/).

## Widgets 

- PagingView : 分页组件基础控件.

- PagingListView : PagingView的子类，包裹了ListView.

## KeyedDataSource

`KeyedDataSource` 分页的核心，数据的获取由`dataSource`完成。

Note: 不要忘记调用 `dataSource.init()`


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

