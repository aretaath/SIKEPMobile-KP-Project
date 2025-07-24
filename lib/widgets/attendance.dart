import 'package:flutter/material.dart';
import 'dart:async';

class AttendanceButton extends StatefulWidget {
  final double width;
  final double height;
  final void Function(String? selectedTujuan) onConfirm;
  final List<String> tujuan;
  final String? selectedTujuan;
  final VoidCallback? onRequestSelectTujuan;

  const AttendanceButton({
    Key? key,
    required this.width,
    required this.height,
    required this.onConfirm,
    required this.tujuan,
    this.selectedTujuan,
    required this.onRequestSelectTujuan,
  }) : super(key: key);

  @override
  _attendanceButtonState createState() => _attendanceButtonState();
}

class _attendanceButtonState extends State<AttendanceButton> {
  int _step = 0;
  bool _isWaiting = false;
  Timer? _timer;
  DateTime? _waktuBerangkat;
  String? _lastSelectedTujuan;

  String get _buttonText {
    if (_step == 0) {
      return 'Catat Keberangkatan';
    } else if (_step > 0 && _step <= widget.tujuan.length) {
      return 'Catat Kehadiran di Lokasi';
    } else if (_step == widget.tujuan.length + 1) {
      return 'Catat Pulang';
    } else {
      return 'Kepulangan Tercatat';
    }
  }

  String get _successText {
    if (_step == 0) {
      return 'Keberangkatan Tercatat';
    } else if (_step > 0 && _step <= widget.tujuan.length) {
      return _lastSelectedTujuan != null
          ? 'Tiba di $_lastSelectedTujuan'
          : 'Tiba di lokasi';
    } else if (_step == widget.tujuan.length + 1) {
      return 'Kepulangan Tercatat';
    } else {
      return 'Kepulangan Tercatat';
    }
  }

  @override
  void didUpdateWidget(covariant AttendanceButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedTujuan != null) {
      _lastSelectedTujuan = widget.selectedTujuan;
    }
  }

  bool get _isLastStep => _step > widget.tujuan.length + 1;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _handlePressed() {
    if (_step > 0 &&
        _step <= widget.tujuan.length &&
        (widget.selectedTujuan == null || _lastSelectedTujuan == null)) {
      if (widget.onRequestSelectTujuan != null) {
        widget.onRequestSelectTujuan!();
      }
      return;
    }

    setState(() {
      _isWaiting = true;
    });
    widget.onConfirm(_lastSelectedTujuan);

    if (_step < widget.tujuan.length) {
      _timer = Timer(const Duration(seconds: 10), () {
        setState(() {
          _step++;
          _isWaiting = false;
        });
      });
    } else if (_step == widget.tujuan.length) {
      _timer = Timer(const Duration(seconds: 10), () {
        setState(() {
          _step++;
          _isWaiting = false;
          //_lastSelectedTujuan = null;
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
