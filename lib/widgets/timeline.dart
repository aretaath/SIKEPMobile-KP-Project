import 'package:flutter/material.dart';

class TimelineData {
  final String? waktuBerangkat;
  final List<String?> waktuTujuan; // waktu tiba di setiap tujuan
  final String? waktuPulang;
  final List<String> tujuan;

  TimelineData({
    required this.tujuan,
    this.waktuBerangkat,
    required this.waktuTujuan,
    this.waktuPulang,
  });
}

class TimelineWidget extends StatelessWidget {
  final TimelineData data;

  const TimelineWidget({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> items = [
      _TimelineItem(
        icon: Image.asset('doc/berangkat.png', width: 32, height: 32),
        time: data.waktuBerangkat ?? '--:--',
        label: 'Berangkat',
      ),
    ];

    for (int i = 0; i < data.tujuan.length; i++) {
      items.add(
        _TimelineItem(
          icon: Image.asset('doc/ditempat.png', width: 32, height: 32),
          time: data.waktuTujuan.length > i && data.waktuTujuan[i] != null
              ? data.waktuTujuan[i]!
              : '--:--',
          label: 'Ditempat (${data.tujuan[i]})',
        ),
      );
    }

    items.add(
      _TimelineItem(
        icon: Image.asset('doc/pulang.png', width: 32, height: 32),
        time: data.waktuPulang ?? '--:--',
        label: 'Pulang',
      ),
    );

    return Wrap(spacing: 24, alignment: WrapAlignment.center, children: items);
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
