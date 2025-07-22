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
        icon: Icons.login,
        time: data.waktuBerangkat ?? '--:--',
        label: 'Berangkat',
      ),
    ];

    for (int i = 0; i < data.tujuan.length; i++) {
      items.add(_TimelineItem(
        icon: Icons.radio_button_unchecked,
        time: data.waktuTujuan.length > i && data.waktuTujuan[i] != null
            ? data.waktuTujuan[i]!
            : '--:--',
        label: 'Ditempat (${data.tujuan[i]})',
      ));
    }

    items.add(_TimelineItem(
      icon: Icons.logout,
      time: data.waktuPulang ?? '--:--',
      label: 'Pulang',
    ));

    return Wrap(
      spacing: 24,
      alignment: WrapAlignment.center,
      children: items,
    );
  }
}

class _TimelineItem extends StatelessWidget {
  final IconData icon;
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
        Icon(icon, size: 32, color: Colors.teal),
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