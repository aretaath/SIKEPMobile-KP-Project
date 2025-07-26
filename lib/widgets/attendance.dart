import 'package:flutter/material.dart';

class AttendanceButton extends StatelessWidget {
  final double width;
  final double height;
  final VoidCallback onConfirm;
  final bool lokasiSiap;
  final String? waktuBerangkat;
  final List<String?> waktuTujuan;
  final String? waktuPulang;
  final List<String> tujuan;

  const AttendanceButton({
    Key? key,
    required this.width,
    required this.height,
    required this.onConfirm,
    required this.lokasiSiap,
    required this.waktuBerangkat,
    required this.waktuTujuan,
    required this.waktuPulang,
    required this.tujuan,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double buttonWidth = width > screenWidth ? screenWidth * 0.9 : width;

    int step = 0;
    if (waktuBerangkat != null && waktuBerangkat != '') {
      step++;
    }
    for (int i = 0; i < tujuan.length; i++) {
      if (waktuTujuan.length > i &&
          waktuTujuan[i] != null &&
          waktuTujuan[i] != '') {
        step++;
      } else {
        break;
      }
    }
    if (waktuTujuan.length == tujuan.length &&
        waktuTujuan.every((w) => w != null && w != '')) {
      if (waktuPulang != null && waktuPulang != '') {
        step++;
      }
    }

    String buttonText;
    if (step == 0) {
      buttonText = 'Catat Keberangkatan';
    } else if (step > 0 && step <= tujuan.length) {
      buttonText = 'Catat Kehadiran di Lokasi';
    } else if (step == tujuan.length + 1) {
      buttonText = 'Catat Pulang';
    } else {
      buttonText = 'Kepulangan Tercatat';
    }

    bool isLastStep = (step > tujuan.length + 1);

    return Center(
      child: SizedBox(
        width: buttonWidth,
        height: height,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: isLastStep ? Colors.grey : Colors.teal,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(height / 2),
            ),
          ),
          onPressed: (!lokasiSiap || isLastStep) ? null : onConfirm,
          child: lokasiSiap
              ? Text(
                  buttonText,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Poppins',
                  ),
                )
              : const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    strokeWidth: 2,
                  ),
                ),
        ),
      ),
    );
  }
}
