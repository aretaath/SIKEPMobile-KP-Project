import 'package:flutter/material.dart';

class TimelineData {
  final String? waktuBerangkat;
  final List<String?> waktuTujuan;
  final String? waktuPulang;
  final List<String> tujuan;
  final String? lokasiBerangkat;
  final String? lokasiPulang;

  TimelineData({
    required this.tujuan,
    this.waktuBerangkat,
    required this.waktuTujuan,
    this.waktuPulang,
    this.lokasiBerangkat,
    this.lokasiPulang,
  });
}

class TimelineWidget extends StatelessWidget {
  final TimelineData data;
  final VoidCallback? onDitempatTap;
  final VoidCallback? onBerangkatTap;
  final VoidCallback? onPulangTap;

  const TimelineWidget({
    Key? key,
    required this.data,
    this.onDitempatTap,
    this.onBerangkatTap,
    this.onPulangTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: GestureDetector(
            onTap: onBerangkatTap,
            child: _TimelineItem(
              icon: Image.asset('doc/berangkat.png', width: 32, height: 32),
              time: data.waktuBerangkat ?? '--:--',
              label: 'Berangkat',
            ),
          ),
        ),
        Expanded(
          child: GestureDetector(
            onTap: onDitempatTap,
            child: _TimelineItem(
              icon: Image.asset('doc/ditempat.png', width: 32, height: 32),
              time:
                  '${data.waktuTujuan.where((w) => w != null).length}/${data.tujuan.length}',
              label: 'Ditempat',
            ),
          ),
        ),
        Expanded(
          child: GestureDetector(
            onTap: onPulangTap,
            child: _TimelineItem(
              icon: Image.asset('doc/pulang.png', width: 32, height: 32),
              time: data.waktuPulang ?? '--:--',
              label: 'Pulang',
            ),
          ),
        ),
      ],
    );
  }
}

class _TimelineItem extends StatelessWidget {
  final Widget icon;
  final String time;
  final String label;

  const _TimelineItem({
    required this.icon,
    required this.time,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        icon,
        const SizedBox(height: 4),
        Text(
          time,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Colors.black87,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.normal,
            fontSize: 14,
            color: Colors.black54,
          ),
        ),
      ],
    );
  }
}
