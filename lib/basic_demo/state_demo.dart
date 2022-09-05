import 'package:flutter/material.dart';

class TapBoxC extends StatefulWidget {
  final bool active;
  final ValueChanged<bool> onChanged;

  const TapBoxC({Key? key, this.active: false, required this.onChanged})
      : super(key: key);

  @override
  State<TapBoxC> createState() => _TapBoxCState();
}

class _TapBoxCState extends State<TapBoxC> {
  bool _highlight = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (TapDownDetails details) {
        setState(() {
          _highlight = true;
        });
      },
      onTapUp: (TapUpDetails details) {
        setState(() {
          _highlight = false;
        });
      },
      onTapCancel: () {
        setState(() {
          _highlight = false;
        });
      },
      onTap: () {
        widget.onChanged(!widget.active);
      },
      child: Container(
        child: Center(
          child: Text(
            widget.active ? "Active" : "Inactive",
            style: const TextStyle(fontSize: 32.0, color: Colors.white),
          ),
        ),
        width: 200,
        decoration: BoxDecoration(
            color: widget.active ? Colors.lightGreen[700] : Colors.grey[600],
            borderRadius: BorderRadius.circular(4.0),
            border:
                _highlight ? Border.all(color: Colors.teal, width: 10) : null),
      ),
    );
  }
}

class PrentWidgetC extends StatefulWidget {
  const PrentWidgetC({Key? key}) : super(key: key);

  @override
  State<PrentWidgetC> createState() => _PrentWidgetCState();
}

class _PrentWidgetCState extends State<PrentWidgetC> {
  bool _active = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: TapBoxC(
        active: _active,
        onChanged: (bool newValue) {
          setState(() {
            _active = newValue;
          });
        },
      ),
    );
  }
}
