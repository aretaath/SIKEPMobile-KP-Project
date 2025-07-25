import 'package:flutter/material.dart';

class PerdinDetail extends StatefulWidget {
  const PerdinDetail({Key? key}) : super(key: key);

  @override
  _PerdinDetailState createState() => _PerdinDetailState();
}

class _PerdinDetailState extends State<PerdinDetail> {
  bool _showOfficialTripDetail = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFF38C7A8),
        borderRadius: BorderRadius.circular(15),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Perjalanan Dinas Hari Ini',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    _showOfficialTripDetail = !_showOfficialTripDetail;
                  });
                },
                child: Icon(
                  _showOfficialTripDetail
                      ? Icons.visibility_off
                      : Icons.visibility,
                  color: Colors.white70,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8), // Jarak standar antar elemen
          // Bagian detail yang hanya akan tampil jika _showOfficialTripDetail == true
          Visibility(
            visible: _showOfficialTripDetail,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  _InfoRow(
                    label: 'Nama Ketua',
                    value: 'Putut Indrayana, SE.M.EcDev',
                  ),
                  _InfoRow(label: 'NIP', value: '189012134151679801'),
                  _InfoRow(label: 'No SPD', value: '700/063/SPD.IRB.1/2025'),
                  _InfoRow(label: 'Tujuan', value: '1. SMP N 2 Tambak'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 90,
          child: Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
          ),
        ),
        Expanded(child: Text(value, style: const TextStyle(fontSize: 14))),
      ],
    );
  }
}
