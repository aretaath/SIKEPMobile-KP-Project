import 'package:flutter/material.dart';
import 'dart:async';

class SliderConfirm extends StatefulWidget {
  final double width;
  final double height;
  final VoidCallback onConfirm;
  final List<String> tujuan;

  const SliderConfirm({
    Key? key,
    required this.width,
    required this.height,
    required this.onConfirm,
    required this.tujuan,
  }) : super(key: key);

  @override
  _SliderConfirmState createState() => _SliderConfirmState();
}

class _SliderConfirmState extends State<SliderConfirm> {
  int _step = 0;
  bool _isWaiting = false;
  Timer? _timer;
  DateTime? _waktuBerangkat;

  String get _buttonText {
    if (_step == 0) {
      return 'Catat Keberangkatan';
    } else if (_step > 0 && _step <= widget.tujuan.length) {
      return 'Ditempat';
    } else if (_step == widget.tujuan.length + 1) {
      return 'Catat Pulang';
    } else {
      return 'Catat Pulang';
    }
  }

  String get _successText {
    if (_step == 0) {
      return 'Keberangkatan Tercatat';
    } else if (_step > 0 && _step <= widget.tujuan.length) {
      return 'Tiba di ${widget.tujuan[_step - 1]}';
    } else if (_step == widget.tujuan.length + 1) {
      return 'Kepulangan Tercatat';
    } else {
      return 'Kepulangan Tercatat';
    }
  }

  bool get _isLastStep => _step > widget.tujuan.length + 1;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _handlePressed() {
    setState(() {
      _isWaiting = true;
    });
    widget.onConfirm();

    if (_step < widget.tujuan.length) {
      _timer = Timer(const Duration(seconds: 30), () {
        setState(() {
          _step++;
          _isWaiting = false;
        });
      });
    } else if (_step == widget.tujuan.length) {
      _timer = Timer(const Duration(seconds: 30), () {
        setState(() {
          _step++;
          _isWaiting = false;
        });
      });
    } else {
      setState(() {
        _step++;
        _isWaiting = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double buttonWidth = widget.width > screenWidth
        ? screenWidth * 0.9
        : widget.width;

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (_waktuBerangkat != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Text(
                'Berangkat: ${_waktuBerangkat != null ? TimeOfDay.fromDateTime(_waktuBerangkat!).format(context) : ''}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
            ),
          SizedBox(
            width: buttonWidth,
            height: widget.height,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: _isWaiting ? Colors.teal[400] : Colors.teal,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(widget.height / 2),
                ),
              ),
              onPressed: _isWaiting || _isLastStep ? null : _handlePressed,
              child: Text(
                _isWaiting ? _successText : _buttonText,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Poppins',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
