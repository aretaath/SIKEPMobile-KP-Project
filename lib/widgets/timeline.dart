import 'package:flutter/material.dart';

class TimelineData {
  final String? waktuBerangkat;
  final List<String?> waktuTujuan;
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
  final VoidCallback? onDitempatTap;

  const TimelineWidget({Key? key, required this.data, this.onDitempatTap})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    for (int i = data.waktuTujuan.length - 1; i >= 0; i--) {
      if (data.waktuTujuan[i] != null) {
        break;
      }
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: _TimelineItem(
            icon: Image.asset('doc/berangkat.png', width: 32, height: 32),
            time: data.waktuBerangkat ?? '--:--',
            label: 'Berangkat',
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
          child: _TimelineItem(
            icon: Image.asset('doc/pulang.png', width: 32, height: 32),
            time: data.waktuPulang ?? '--:--',
            label: 'Pulang',
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
