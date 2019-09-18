import 'package:flutter/widgets.dart';

/// Signature for a function that creates a widget for a given item of type 'T'.
typedef PagingItemWidgetBuilder<T> = Widget Function(
    BuildContext context, int index, T item);

typedef PagingWidgetBuilder<T> = Widget Function(
    BuildContext context, List<T> items);
