// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// The default insert/remove animation duration.
const Duration animatedDuration = Duration(milliseconds: 380);

// Incoming and outgoing AnimatedGrid items.
class _ActiveItem implements Comparable<_ActiveItem> {
  _ActiveItem.incoming(this.controller, this.itemIndex) : removedItemBuilder = null;
  _ActiveItem.outgoing(this.controller, this.itemIndex, this.removedItemBuilder);
  _ActiveItem.index(this.itemIndex)
      : controller = null,
        removedItemBuilder = null;

  final AnimationController? controller;
  final AnimatedListRemovedItemBuilder? removedItemBuilder;
  int itemIndex;

  @override
  int compareTo(_ActiveItem other) => itemIndex - other.itemIndex;
}

/// A scrolling container that animates items when they are inserted or removed.
///
/// This widget's [AnimatedGridState] can be used to dynamically insert or
/// remove items. To refer to the [AnimatedGridState] either provide a
/// [GlobalKey] or use the static [of] method from an item's input callback.
///
/// This widget is similar to one created by [ListView.builder].
///
/// {@youtube 560 315 https://www.youtube.com/watch?v=ZtfItHwFlZ8}
///
/// {@tool dartpad}
/// This sample application uses an [AnimatedGrid] to create an effect when
/// items are removed or added to the list.
///
/// ** See code in examples/api/lib/widgets/animated_list/animated_list.0.dart **
/// {@end-tool}
///
/// See also:
///
///  * [SliverAnimatedGrid], a sliver that animates items when they are inserted
///    or removed from a list.
class AnimatedGrid extends StatefulWidget {
  /// Creates a scrolling container that animates items when they are inserted
  /// or removed.
  const AnimatedGrid({
    Key? key,
    required this.itemBuilder,
    this.initialItemCount = 0,
    this.scrollDirection = Axis.vertical,
    this.reverse = false,
    this.controller,
    this.primary,
    this.physics,
    this.shrinkWrap = false,
    this.padding,
    this.clipBehavior = Clip.hardEdge,
    this.crossAxisCount = 1,
    this.mainAxisSpacing = 0,
    this.crossAxisSpacing = 0,
    this.childAspectRatio = 1,
  }) : super(key: key);

  /// The number of children in the cross axis.
  final int crossAxisCount;

  /// The number of logical pixels between each child along the main axis.
  final double mainAxisSpacing;

  /// The number of logical pixels between each child along the cross axis.
  final double crossAxisSpacing;

  /// The ratio of the cross-axis to the main-axis extent of each child.
  final double childAspectRatio;

  /// Called, as needed, to build list item widgets.
  ///
  /// List items are only built when they're scrolled into view.
  ///
  /// The [AnimatedGridItemBuilder] index parameter indicates the item's
  /// position in the list. The value of the index parameter will be between 0
  /// and [initialItemCount] plus the total number of items that have been
  /// inserted with [AnimatedGridState.insertItem] and less the total number of
  /// items that have been removed with [AnimatedGridState.removeItem].
  ///
  /// Implementations of this callback should assume that
  /// [AnimatedGridState.removeItem] removes an item immediately.
  final AnimatedListItemBuilder itemBuilder;

  /// {@template flutter.widgets.animatedGrid.initialItemCount}
  /// The number of items the list will start with.
  ///
  /// The appearance of the initial items is not animated. They
  /// are created, as needed, by [itemBuilder] with an animation parameter
  /// of [kAlwaysCompleteAnimation].
  /// {@endtemplate}
  final int initialItemCount;

  /// The axis along which the scroll view scrolls.
  ///
  /// Defaults to [Axis.vertical].
  final Axis scrollDirection;

  /// Whether the scroll view scrolls in the reading direction.
  ///
  /// For example, if the reading direction is left-to-right and
  /// [scrollDirection] is [Axis.horizontal], then the scroll view scrolls from
  /// left to right when [reverse] is false and from right to left when
  /// [reverse] is true.
  ///
  /// Similarly, if [scrollDirection] is [Axis.vertical], then the scroll view
  /// scrolls from top to bottom when [reverse] is false and from bottom to top
  /// when [reverse] is true.
  ///
  /// Defaults to false.
  final bool reverse;

  /// An object that can be used to control the position to which this scroll
  /// view is scrolled.
  ///
  /// Must be null if [primary] is true.
  ///
  /// A [ScrollController] serves several purposes. It can be used to control
  /// the initial scroll position (see [ScrollController.initialScrollOffset]).
  /// It can be used to control whether the scroll view should automatically
  /// save and restore its scroll position in the [PageStorage] (see
  /// [ScrollController.keepScrollOffset]). It can be used to read the current
  /// scroll position (see [ScrollController.offset]), or change it (see
  /// [ScrollController.animateTo]).
  final ScrollController? controller;

  /// Whether this is the primary scroll view associated with the parent
  /// [PrimaryScrollController].
  ///
  /// On iOS, this identifies the scroll view that will scroll to top in
  /// response to a tap in the status bar.
  ///
  /// Defaults to true when [scrollDirection] is [Axis.vertical] and
  /// [controller] is null.
  final bool? primary;

  /// How the scroll view should respond to user input.
  ///
  /// For example, determines how the scroll view continues to animate after the
  /// user stops dragging the scroll view.
  ///
  /// Defaults to matching platform conventions.
  final ScrollPhysics? physics;

  /// Whether the extent of the scroll view in the [scrollDirection] should be
  /// determined by the contents being viewed.
  ///
  /// If the scroll view does not shrink wrap, then the scroll view will expand
  /// to the maximum allowed size in the [scrollDirection]. If the scroll view
  /// has unbounded constraints in the [scrollDirection], then [shrinkWrap] must
  /// be true.
  ///
  /// Shrink wrapping the content of the scroll view is significantly more
  /// expensive than expanding to the maximum allowed size because the content
  /// can expand and contract during scrolling, which means the size of the
  /// scroll view needs to be recomputed whenever the scroll position changes.
  ///
  /// Defaults to false.
  final bool shrinkWrap;

  /// The amount of space by which to inset the children.
  final EdgeInsetsGeometry? padding;

  /// {@macro flutter.material.Material.clipBehavior}
  ///
  /// Defaults to [Clip.hardEdge].
  final Clip clipBehavior;

  /// The state from the closest instance of this class that encloses the given
  /// context.
  ///
  /// This method is typically used by [AnimatedGrid] item widgets that insert
  /// or remove items in response to user input.
  ///
  /// If no [AnimatedGrid] surrounds the context given, then this function will
  /// assert in debug mode and throw an exception in release mode.
  ///
  /// This method can be expensive (it walks the element tree).
  ///
  /// See also:
  ///
  ///  * [maybeOf], a similar function that will return null if no
  ///    [AnimatedGrid] ancestor is found.
  static AnimatedGridState of(BuildContext context) {
    final AnimatedGridState? result = context.findAncestorStateOfType<AnimatedGridState>();
    assert(() {
      if (result == null) {
        throw FlutterError.fromParts(<DiagnosticsNode>[
          ErrorSummary('AnimatedGrid.of() called with a context that does not contain an AnimatedGrid.'),
          ErrorDescription(
            'No AnimatedGrid ancestor could be found starting from the context that was passed to AnimatedGrid.of().',
          ),
          ErrorHint(
            'This can happen when the context provided is from the same StatefulWidget that '
            'built the AnimatedGrid. Please see the AnimatedGrid documentation for examples '
            'of how to refer to an AnimatedGridState object:\n'
            '  https://api.flutter.dev/flutter/widgets/AnimatedGridState-class.html',
          ),
          context.describeElement('The context used was'),
        ]);
      }
      return true;
    }());
    return result!;
  }

  /// The state from the closest instance of this class that encloses the given
  /// context.
  ///
  /// This method is typically used by [AnimatedGrid] item widgets that insert
  /// or remove items in response to user input.
  ///
  /// If no [AnimatedGrid] surrounds the context given, then this function will
  /// return null.
  ///
  /// This method can be expensive (it walks the element tree).
  ///
  /// See also:
  ///
  ///  * [of], a similar function that will throw if no [AnimatedGrid] ancestor
  ///    is found.
  static AnimatedGridState? maybeOf(BuildContext context) {
    return context.findAncestorStateOfType<AnimatedGridState>();
  }

  @override
  AnimatedGridState createState() => AnimatedGridState();
}

/// The state for a scrolling container that animates items when they are
/// inserted or removed.
///
/// When an item is inserted with [insertItem] an animation begins running. The
/// animation is passed to [AnimatedGrid.itemBuilder] whenever the item's widget
/// is needed.
///
/// When an item is removed with [removeItem] its animation is reversed.
/// The removed item's animation is passed to the [removeItem] builder
/// parameter.
///
/// An app that needs to insert or remove items in response to an event
/// can refer to the [AnimatedGrid]'s state with a global key:
///
/// ```dart
/// GlobalKey<AnimatedGridState> listKey = GlobalKey<AnimatedGridState>();
/// ...
/// AnimatedGrid(key: listKey, ...);
/// ...
/// listKey.currentState.insert(123);
/// ```
///
/// [AnimatedGrid] item input handlers can also refer to their [AnimatedGridState]
/// with the static [AnimatedGrid.of] method.
class AnimatedGridState extends State<AnimatedGrid> with TickerProviderStateMixin<AnimatedGrid> {
  final GlobalKey<SliverAnimatedGridState> _sliverAnimatedGridKey = GlobalKey();

  set itemCount(int value) {
    _sliverAnimatedGridKey.currentState!.itemCount = value;
  }

  /// Insert an item at [index] and start an animation that will be passed
  /// to [AnimatedGrid.itemBuilder] when the item is visible.
  ///
  /// This method's semantics are the same as Dart's [List.insert] method:
  /// it increases the length of the list by one and shifts all items at or
  /// after [index] towards the end of the list.
  void insertItem(int index, {Duration duration = animatedDuration}) {
    _sliverAnimatedGridKey.currentState!.insertItem(index, duration: duration);
  }

  /// Remove the item at [index] and start an animation that will be passed
  /// to [builder] when the item is visible.
  ///
  /// Items are removed immediately. After an item has been removed, its index
  /// will no longer be passed to the [AnimatedGrid.itemBuilder]. However the
  /// item will still appear in the list for [duration] and during that time
  /// [builder] must construct its widget as needed.
  ///
  /// This method's semantics are the same as Dart's [List.remove] method:
  /// it decreases the length of the list by one and shifts all items at or
  /// before [index] towards the beginning of the list.
  void removeItem(int index, AnimatedListRemovedItemBuilder builder, {Duration duration = animatedDuration}) {
    _sliverAnimatedGridKey.currentState!.removeItem(index, builder, duration: duration);
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      scrollDirection: widget.scrollDirection,
      reverse: widget.reverse,
      controller: widget.controller,
      primary: widget.primary,
      physics: widget.physics,
      shrinkWrap: widget.shrinkWrap,
      clipBehavior: widget.clipBehavior,
      slivers: <Widget>[
        SliverPadding(
          padding: widget.padding ?? EdgeInsets.zero,
          sliver: SliverAnimatedGrid(
            crossAxisCount: widget.crossAxisCount,
            mainAxisSpacing: widget.mainAxisSpacing,
            crossAxisSpacing: widget.crossAxisSpacing,
            childAspectRatio: widget.childAspectRatio,
            key: _sliverAnimatedGridKey,
            itemBuilder: widget.itemBuilder,
            initialItemCount: widget.initialItemCount,
          ),
        ),
      ],
    );
  }
}

/// A sliver that animates items when they are inserted or removed.
///
/// This widget's [SliverAnimatedGridState] can be used to dynamically insert or
/// remove items. To refer to the [SliverAnimatedGridState] either provide a
/// [GlobalKey] or use the static [SliverAnimatedGrid.of] method from an item's
/// input callback.
///
/// {@tool dartpad}
/// This sample application uses a [SliverAnimatedGrid] to create an animated
/// effect when items are removed or added to the list.
///
/// ** See code in examples/api/lib/widgets/animated_list/sliver_animated_list.0.dart **
/// {@end-tool}
///
/// See also:
///
///  * [SliverList], which does not animate items when they are inserted or
///    removed.
///  * [AnimatedGrid], a non-sliver scrolling container that animates items when
///    they are inserted or removed.
class SliverAnimatedGrid extends StatefulWidget {
  /// Creates a sliver that animates items when they are inserted or removed.
  const SliverAnimatedGrid({
    Key? key,
    required this.itemBuilder,
    this.initialItemCount = 0,
    this.crossAxisCount = 1,
    this.mainAxisSpacing = 0,
    this.crossAxisSpacing = 0,
    this.childAspectRatio = 1,
  }) : super(key: key);

  /// Called, as needed, to build list item widgets.
  ///
  /// List items are only built when they're scrolled into view.
  ///
  /// The [AnimatedGridItemBuilder] index parameter indicates the item's
  /// position in the list. The value of the index parameter will be between 0
  /// and [initialItemCount] plus the total number of items that have been
  /// inserted with [SliverAnimatedGridState.insertItem] and less the total
  /// number of items that have been removed with
  /// [SliverAnimatedGridState.removeItem].
  ///
  /// Implementations of this callback should assume that
  /// [SliverAnimatedGridState.removeItem] removes an item immediately.
  final AnimatedListItemBuilder itemBuilder;

  /// {@macro flutter.widgets.animatedGrid.initialItemCount}
  final int initialItemCount;

  /// The number of children in the cross axis.
  final int crossAxisCount;

  /// The number of logical pixels between each child along the main axis.
  final double mainAxisSpacing;

  /// The number of logical pixels between each child along the cross axis.
  final double crossAxisSpacing;

  /// The ratio of the cross-axis to the main-axis extent of each child.
  final double childAspectRatio;

  @override
  SliverAnimatedGridState createState() => SliverAnimatedGridState();

  /// The state from the closest instance of this class that encloses the given
  /// context.
  ///
  /// This method is typically used by [SliverAnimatedGrid] item widgets that
  /// insert or remove items in response to user input.
  ///
  /// If no [SliverAnimatedGrid] surrounds the context given, then this function
  /// will assert in debug mode and throw an exception in release mode.
  ///
  /// This method can be expensive (it walks the element tree).
  ///
  /// See also:
  ///
  ///  * [maybeOf], a similar function that will return null if no
  ///    [SliverAnimatedGrid] ancestor is found.
  static SliverAnimatedGridState of(BuildContext context) {
    final SliverAnimatedGridState? result = context.findAncestorStateOfType<SliverAnimatedGridState>();
    assert(() {
      if (result == null) {
        throw FlutterError(
          'SliverAnimatedGrid.of() called with a context that does not contain a SliverAnimatedGrid.\n'
          'No SliverAnimatedGridState ancestor could be found starting from the '
          'context that was passed to SliverAnimatedGridState.of(). This can '
          'happen when the context provided is from the same StatefulWidget that '
          'built the AnimatedGrid. Please see the SliverAnimatedGrid documentation '
          'for examples of how to refer to an AnimatedGridState object: '
          'https://api.flutter.dev/flutter/widgets/SliverAnimatedGridState-class.html\n'
          'The context used was:\n'
          '  $context',
        );
      }
      return true;
    }());
    return result!;
  }

  /// The state from the closest instance of this class that encloses the given
  /// context.
  ///
  /// This method is typically used by [SliverAnimatedGrid] item widgets that
  /// insert or remove items in response to user input.
  ///
  /// If no [SliverAnimatedGrid] surrounds the context given, then this function
  /// will return null.
  ///
  /// This method can be expensive (it walks the element tree).
  ///
  /// See also:
  ///
  ///  * [of], a similar function that will throw if no [SliverAnimatedGrid]
  ///    ancestor is found.
  static SliverAnimatedGridState? maybeOf(BuildContext context) {
    return context.findAncestorStateOfType<SliverAnimatedGridState>();
  }
}

/// The state for a sliver that animates items when they are
/// inserted or removed.
///
/// When an item is inserted with [insertItem] an animation begins running. The
/// animation is passed to [SliverAnimatedGrid.itemBuilder] whenever the item's
/// widget is needed.
///
/// When an item is removed with [removeItem] its animation is reversed.
/// The removed item's animation is passed to the [removeItem] builder
/// parameter.
///
/// An app that needs to insert or remove items in response to an event
/// can refer to the [SliverAnimatedGrid]'s state with a global key:
///
/// ```dart
/// GlobalKey<SliverAnimatedGridState> listKey = GlobalKey<SliverAnimatedGridState>();
/// ...
/// SliverAnimatedGrid(key: listKey, ...);
/// ...
/// listKey.currentState.insert(123);
/// ```
///
/// [SliverAnimatedGrid] item input handlers can also refer to their
/// [SliverAnimatedGridState] with the static [SliverAnimatedGrid.of] method.
class SliverAnimatedGridState extends State<SliverAnimatedGrid> with TickerProviderStateMixin {
  final List<_ActiveItem> _incomingItems = <_ActiveItem>[];
  final List<_ActiveItem> _outgoingItems = <_ActiveItem>[];
  int itemCount = 0;

  @override
  void initState() {
    super.initState();
    itemCount = widget.initialItemCount;
  }

  @override
  void dispose() {
    for (final _ActiveItem item in _incomingItems.followedBy(_outgoingItems)) {
      item.controller!.dispose();
    }
    super.dispose();
  }

  _ActiveItem? _removeActiveItemAt(List<_ActiveItem> items, int itemIndex) {
    final int i = binarySearch(items, _ActiveItem.index(itemIndex));
    return i == -1 ? null : items.removeAt(i);
  }

  _ActiveItem? _activeItemAt(List<_ActiveItem> items, int itemIndex) {
    final int i = binarySearch(items, _ActiveItem.index(itemIndex));
    return i == -1 ? null : items[i];
  }

  // The insertItem() and removeItem() index parameters are defined as if the
  // removeItem() operation removed the corresponding list entry immediately.
  // The entry is only actually removed from the ListView when the remove animation
  // finishes. The entry is added to _outgoingItems when removeItem is called
  // and removed from _outgoingItems when the remove animation finishes.

  int _indexToItemIndex(int index) {
    int itemIndex = index;
    for (final _ActiveItem item in _outgoingItems) {
      if (item.itemIndex <= itemIndex) {
        itemIndex += 1;
      } else {
        break;
      }
    }
    return itemIndex;
  }

  int _itemIndexToIndex(int itemIndex) {
    int index = itemIndex;
    for (final _ActiveItem item in _outgoingItems) {
      assert(item.itemIndex != itemIndex);
      if (item.itemIndex < itemIndex) {
        index -= 1;
      } else {
        break;
      }
    }
    return index;
  }

  /// Insert an item at [index] and start an animation that will be passed to
  /// [SliverAnimatedGrid.itemBuilder] when the item is visible.
  ///
  /// This method's semantics are the same as Dart's [List.insert] method:
  /// it increases the length of the list by one and shifts all items at or
  /// after [index] towards the end of the list.
  void insertItem(int index, {Duration duration = animatedDuration}) {
    final int itemIndex = _indexToItemIndex(index);
    assert(itemIndex >= 0 && itemIndex <= itemCount);

    // Increment the incoming and outgoing item indices to account
    // for the insertion.
    for (final _ActiveItem item in _incomingItems) {
      if (item.itemIndex >= itemIndex) item.itemIndex += 1;
    }
    for (final _ActiveItem item in _outgoingItems) {
      if (item.itemIndex >= itemIndex) item.itemIndex += 1;
    }

    final AnimationController controller = AnimationController(
      duration: duration,
      vsync: this,
    );
    final _ActiveItem incomingItem = _ActiveItem.incoming(
      controller,
      itemIndex,
    );
    setState(() {
      _incomingItems
        ..add(incomingItem)
        ..sort();
      itemCount += 1;
    });

    controller.forward().then<void>((_) {
      _removeActiveItemAt(_incomingItems, incomingItem.itemIndex)!.controller!.dispose();
    });
  }

  /// Remove the item at [index] and start an animation that will be passed
  /// to [builder] when the item is visible.
  ///
  /// Items are removed immediately. After an item has been removed, its index
  /// will no longer be passed to the [SliverAnimatedGrid.itemBuilder]. However
  /// the item will still appear in the list for [duration] and during that time
  /// [builder] must construct its widget as needed.
  ///
  /// This method's semantics are the same as Dart's [List.remove] method:
  /// it decreases the length of the list by one and shifts all items at or
  /// before [index] towards the beginning of the list.
  void removeItem(int index, AnimatedListRemovedItemBuilder builder, {Duration duration = animatedDuration}) {
    final int itemIndex = _indexToItemIndex(index);
    assert(itemIndex >= 0 && itemIndex < itemCount);
    assert(_activeItemAt(_outgoingItems, itemIndex) == null);

    final _ActiveItem? incomingItem = _removeActiveItemAt(_incomingItems, itemIndex);
    final AnimationController controller =
        incomingItem?.controller ?? AnimationController(duration: duration, value: 1.0, vsync: this);
    final _ActiveItem outgoingItem = _ActiveItem.outgoing(controller, itemIndex, builder);
    setState(() {
      _outgoingItems
        ..add(outgoingItem)
        ..sort();
    });

    controller.reverse().then<void>((void value) {
      _removeActiveItemAt(_outgoingItems, outgoingItem.itemIndex)!.controller!.dispose();

      // Decrement the incoming and outgoing item indices to account
      // for the removal.
      for (final _ActiveItem item in _incomingItems) {
        if (item.itemIndex > outgoingItem.itemIndex) item.itemIndex -= 1;
      }
      for (final _ActiveItem item in _outgoingItems) {
        if (item.itemIndex > outgoingItem.itemIndex) item.itemIndex -= 1;
      }

      setState(() => itemCount -= 1);
    });
  }

  Widget _itemBuilder(BuildContext context, int itemIndex) {
    final _ActiveItem? outgoingItem = _activeItemAt(_outgoingItems, itemIndex);
    if (outgoingItem != null) {
      return outgoingItem.removedItemBuilder!(
        context,
        outgoingItem.controller!.view,
      );
    }

    final _ActiveItem? incomingItem = _activeItemAt(_incomingItems, itemIndex);
    final Animation<double> animation = incomingItem?.controller?.view ?? kAlwaysCompleteAnimation;
    return widget.itemBuilder(
      context,
      _itemIndexToIndex(itemIndex),
      animation,
    );
  }

  @override
  Widget build(BuildContext context) {
    return widget.crossAxisCount > 1
        ? SliverGrid(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: widget.crossAxisCount,
              mainAxisSpacing: widget.mainAxisSpacing,
              crossAxisSpacing: widget.crossAxisSpacing,
            ),
            delegate: _createDelegate(),
          )
        : SliverList(
            delegate: _createDelegate(),
          );
  }

  SliverChildDelegate _createDelegate() {
    return SliverChildBuilderDelegate(_itemBuilder, childCount: itemCount);
  }
}
