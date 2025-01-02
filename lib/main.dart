import 'package:flutter/material.dart';

/// Entrypoint of the application.
void main() {
  runApp(const MyApp());
}

/// [Widget] building the [MaterialApp].
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Padding(
          padding: const EdgeInsets.only(bottom: 3),
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Dock(
              items: const [
                Icons.person,
                Icons.message,
                Icons.call,
                Icons.camera,
                Icons.photo,
                Icons.settings,
                Icons.music_note,
              ],
              builder: (icon, isHovered) {
                final double size = isHovered ? 50 : 40;
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: size,
                  height: size,
                  margin: const EdgeInsets.all(7),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors
                        .primaries[icon.hashCode % Colors.primaries.length],
                  ),
                  child: Center(
                    child: Icon(
                      icon,
                      color: Colors.white,
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

/// Dock of the reorderable [items].
class Dock<T extends Object> extends StatefulWidget {
  const Dock({
    super.key,
    this.items = const [],
    required this.builder,
  });

  /// Initial [T] items to put in this [Dock].
  final List<T> items;

  /// Builder function to build the [T] item.
  final Widget Function(T, bool isHovered) builder;

  @override
  State<Dock<T>> createState() => _DockState<T>();
}

/// State of the [Dock] used to manipulate the [_items].
class _DockState<T extends Object> extends State<Dock<T>> {
  /// [T] items being manipulated.
  late final List<T> _items = widget.items.toList();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.black12,
        border: Border.all(color: Colors.black12),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: _items.asMap().entries.map((entry) {
          final index = entry.key;
          final item = entry.value;

          return Draggable<T>(
            data: item,
            feedback: Material(
              color: Colors.transparent,
              child: widget.builder(item, true),
            ),
            childWhenDragging: const SizedBox.shrink(),
            child: DragTarget<T>(
              onAccept: (Item) {
                setState(() {
                  final fromIndex = _items.indexOf(Item);
                  final toIndex = index;
                  _items[fromIndex] = _items[toIndex];
                  _items[toIndex] = Item;
                });
              },
              builder: (context, data, _) {
                return MouseRegion(
                  onEnter: (_) => setState(() {}),
                  onExit: (_) => setState(() {}),
                  child: widget.builder(item, data.isNotEmpty),
                );
              },
            ),
          );
        }).toList(),
      ),
    );
  }
}
