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

class TimelineWidget extends StatefulWidget {
  final TimelineData data;

  const TimelineWidget({Key? key, required this.data}) : super(key: key);

  @override
  _TimelineWidgetState createState() => _TimelineWidgetState();
}

class _TimelineWidgetState extends State<TimelineWidget> {
  @override
  Widget build(BuildContext context) {
    final List<_TimelineItem> items = [];

    if (widget.data.waktuBerangkat != null &&
        widget.data.waktuBerangkat != '') {
      items.add(
        _TimelineItem(
          icon: Image.asset('doc/berangkat.png', width: 32, height: 32),
          time: widget.data.waktuBerangkat ?? '--:--',
          label: 'Berangkat',
        ),
      );

      for (int i = 0; i < widget.data.tujuan.length; i++) {
        final tujuanLabel = 'Tiba di ${widget.data.tujuan[i]}';
        if (widget.data.waktuTujuan.length > i &&
            widget.data.waktuTujuan[i] != null &&
            widget.data.waktuTujuan[i] != '') {
          items.add(
            _TimelineItem(
              icon: Image.asset('doc/ditempat.png', width: 32, height: 32),
              time: widget.data.waktuTujuan[i] ?? '--:--',
              label: tujuanLabel,
            ),
          );
        } else {
          items.add(
            _TimelineItem(
              icon: Image.asset('doc/ditempat.png', width: 32, height: 32),
              time: '--:--',
              label: tujuanLabel,
            ),
          );
          break;
        }
      }

      if (widget.data.waktuTujuan.length == widget.data.tujuan.length &&
          widget.data.waktuTujuan.every((w) => w != null && w != '') &&
          widget.data.waktuPulang != null &&
          widget.data.waktuPulang != '') {
        items.add(
          _TimelineItem(
            icon: Image.asset('doc/pulang.png', width: 32, height: 32),
            time: widget.data.waktuPulang ?? '--:--',
            label: 'Pulang',
          ),
        );
      } else if (widget.data.waktuTujuan.length == widget.data.tujuan.length &&
          widget.data.waktuTujuan.every((w) => w != null && w != '') &&
          (widget.data.waktuPulang == null || widget.data.waktuPulang == '')) {
        items.add(
          _TimelineItem(
            icon: Image.asset('doc/pulang.png', width: 32, height: 32),
            time: '--:--',
            label: 'Pulang',
          ),
        );
      }
    } else {
      items.add(
        _TimelineItem(
          icon: Image.asset('doc/berangkat.png', width: 32, height: 32),
          time: '--:--',
          label: 'Berangkat',
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: items,
    );
  }
}

class _TimelineItem extends StatelessWidget {
  final Image icon;
  final String time;
  final String label;

  const _TimelineItem({
    Key? key,
    required this.icon,
    required this.time,
    required this.label,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          icon,
          const SizedBox(width: 12),
          Text(
            time,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(width: 12),
          Text(label, style: const TextStyle(fontSize: 15)),
        ],
      ),
    );
  }
}
