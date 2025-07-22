import 'package:flutter/material.dart';

class SliderConfirm extends StatefulWidget {
  final double width;
  final double height;
  final VoidCallback onConfirm;

  const SliderConfirm({
    Key? key,
    this.width = 357,
    this.height = 60,
    required this.onConfirm,
  }) : super(key: key);

  @override
  _SliderConfirmState createState() => _SliderConfirmState();
}

class _SliderConfirmState extends State<SliderConfirm> {
  double _dragPosition = 0.0;
  bool _confirmed = false;

  @override
  Widget build(BuildContext context) {
    final double maxDrag = widget.width - widget.height;

    return GestureDetector(
      onHorizontalDragUpdate: (details) {
        if (_confirmed) return;
        setState(() {
          _dragPosition += details.delta.dx;
          if (_dragPosition < 0) _dragPosition = 0;
          if (_dragPosition > maxDrag) _dragPosition = maxDrag;
          if (_dragPosition == maxDrag) {
            _confirmed = true;
            widget.onConfirm();
          }
        });
      },
      onHorizontalDragEnd: (_) {
        if (!_confirmed) {
          setState(() {
            _dragPosition = 0;
          });
        }
      },
      child: Container(
        width: widget.width,
        height: widget.height,
        decoration: BoxDecoration(
          color: _confirmed ? Colors.teal[400] : Colors.grey.shade300,
          borderRadius: BorderRadius.circular(widget.height / 2),
        ),
        child: Stack(
          children: [
            Center(
              child: Text(
                _confirmed ? 'Sukses Tercatat' : 'Geser untuk catat kehadiran',
                style: TextStyle(
                  color: _confirmed ? Colors.white : Colors.black87,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Poppins',
                ),
                textAlign: TextAlign.center,
              ),
            ),

            Positioned(
              left: _dragPosition,
              top: 0,
              bottom: 0,
              child: Container(
                width: widget.height,
                height: widget.height,
                decoration: BoxDecoration(
                  color: _confirmed ? Colors.white : Colors.teal[400],
                  shape: BoxShape.circle,
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 5,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Icon(
                  _confirmed ? Icons.check : Icons.arrow_forward,
                  color: _confirmed ? Colors.teal[400] : Colors.white,
                  size: 28,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
