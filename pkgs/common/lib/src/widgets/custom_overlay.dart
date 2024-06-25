import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

/// 自定义OverlayEntry
class CustomOverlayEntry {
  final WidgetBuilder builder;

  CustomOverlayEntry({required this.builder});

  CustomOverlayState? _overlay;
  final GlobalKey<_CustomOverlayEntryWidgetState> _key = GlobalKey<_CustomOverlayEntryWidgetState>();

  /// 移除OverlayEntry
  void remove() {
    assert(_overlay != null);
    assert(!_disposedByOwner);
    final CustomOverlayState overlay = _overlay!;
    _overlay = null;
    if (!overlay.mounted) {
      return;
    }

    overlay._entries.remove(this);
    if (SchedulerBinding.instance.schedulerPhase == SchedulerPhase.persistentCallbacks) {
      SchedulerBinding.instance.addPostFrameCallback((Duration duration) {
        overlay._markDirty();
      });
    } else {
      overlay._markDirty();
    }
  }

  void _didUnmount() {
    assert(!mounted);
    if (_disposedByOwner) {
      _overlayStateMounted.dispose();
    }
  }

  bool _disposedByOwner = false;

  /// Discards any resources used by this [OverlayEntry].
  ///
  /// This method must be called after [remove] if the [OverlayEntry] is
  /// inserted into an [Overlay].
  ///
  /// After this is called, the object is not in a usable state and should be
  /// discarded (calls to [addListener] will throw after the object is disposed).
  /// However, the listeners registered may not be immediately released until
  /// the widget built using this [OverlayEntry] is unmounted from the widget
  /// tree.
  ///
  /// This method should only be called by the object's owner.
  void dispose() {
    assert(!_disposedByOwner);
    assert(_overlay == null, 'An OverlayEntry must first be removed from the Overlay before dispose is called.');
    _disposedByOwner = true;
    if (!mounted) {
      _overlayStateMounted.dispose();
    }
  }

  /// Whether the [OverlayEntry] is currently mounted in the widget tree.
  ///
  /// The [OverlayEntry] notifies its listeners when this value changes.
  bool get mounted => _overlayStateMounted.value;

  /// Whether the `_OverlayState`s built using this [OverlayEntry] is currently
  /// mounted.
  final ValueNotifier<bool> _overlayStateMounted = ValueNotifier<bool>(false);

  void markNeedsBuild() {
    assert(!_disposedByOwner);
    _key.currentState?._markNeedsBuild();
  }
}

class CustomOverlay extends StatefulWidget {
  const CustomOverlay({
    super.key,
    this.child,
    this.initialEntries = const [],
  });

  final Widget? child;
  final List<CustomOverlayEntry> initialEntries;

  /// 获取OverlayState
  static CustomOverlayState of(
    BuildContext context, {
    bool rootOverlay = false,
    Widget? debugRequiredFor,
  }) {
    final CustomOverlayState? result =
        maybeOf(context, rootOverlay: rootOverlay);
    assert(() {
      if (result == null) {
        final List<DiagnosticsNode> information = <DiagnosticsNode>[
          ErrorSummary('No CustomOverlay widget found. Please wrap CustomOverlay on the top of the widget tree'),
        ];
        throw FlutterError.fromParts(information);
      }
      return true;
    }());
    return result!;
  }

  static CustomOverlayState? maybeOf(
    BuildContext context, {
    bool rootOverlay = false,
  }) {
    return rootOverlay
        ? context.findRootAncestorStateOfType<CustomOverlayState>()
        : context.findAncestorStateOfType<CustomOverlayState>();
  }

  @override
  State<CustomOverlay> createState() => CustomOverlayState();
}

class CustomOverlayState extends State<CustomOverlay> {
  final List<CustomOverlayEntry> _entries = <CustomOverlayEntry>[];

  void insert(CustomOverlayEntry entry) {
    assert(!_entries.contains(entry),
        'The specified entry is already present in the Overlay.');
    assert(entry._overlay == null,
        'The specified entry is already present in another Overlay.');
    entry._overlay = this;
    setState(() {
      _entries.add(entry);
    });
  }

  void insertAll(Iterable<CustomOverlayEntry> entries) {
    assert(
      entries.every((CustomOverlayEntry entry) => !_entries.contains(entry)),
      'One or more of the specified entries are already present in the CustomOverlay.',
    );
    assert(
      entries.every((CustomOverlayEntry entry) => entry._overlay == null),
      'One or more of the specified entries are already present in another CustomOverlay.',
    );
    if (entries.isEmpty) {
      return;
    }
    for (final CustomOverlayEntry entry in entries) {
      assert(entry._overlay == null);
      entry._overlay = this;
    }
    setState(() {
      _entries.addAll(entries);
    });
  }

  void _markDirty() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        if (widget.child != null) Positioned.fill(child: widget.child!),
        for(final entry in _entries)
          _CustomOverlayEntryWidget(
            key: entry._key,
            entry: entry,
          ),
      ],
    );
  }
}


class _CustomOverlayEntryWidget extends StatefulWidget {
  const _CustomOverlayEntryWidget({
    required Key key,
    required this.entry,
  }) : super(key: key);

  final CustomOverlayEntry entry;

  @override
  _CustomOverlayEntryWidgetState createState() => _CustomOverlayEntryWidgetState();
}

class _CustomOverlayEntryWidgetState extends State<_CustomOverlayEntryWidget> {
  @override
  void initState() {
    super.initState();
    widget.entry._overlayStateMounted.value = true;
  }

  @override
  void dispose() {
    widget.entry._overlayStateMounted.value = false;
    widget.entry._didUnmount();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.entry.builder(context);
  }

  void _markNeedsBuild() {
    setState(() { /* the state that changed is in the builder */ });
  }
}
