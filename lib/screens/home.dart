import 'dart:async';
import 'package:flutter/material.dart';
import 'package:sikep/widgets/attendance.dart';
import 'package:sikep/widgets/timeline.dart';
import 'package:sikep/widgets/perdin_detail.dart';
import 'package:sikep/widgets/perdin_notes.dart';
import 'package:sikep/widgets/user_info.dart';
import 'package:sikep/services/location.dart';
import 'package:sikep/utils/datetime.dart';
import 'package:sikep/widgets/logout.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? _waktuBerangkat;
  List<String?> _waktuTujuan = [null, null];
  String? _waktuPulang;
  List<String> _tujuan = ['Kantor Cabang', 'Lokasi Proyek'];
  String? _lokasiBerangkat;
  String? _lokasiPulang;
  List<String?> _lokasiTujuan = [null, null];

  int _step = 0;
  bool _lokasiSiap = false;
  bool _showNotesForm = false;

  final List<String> _savedNotes = [];
  final TextEditingController _noteController = TextEditingController();

  String _currentTime = '';
  String _currentDay = '';
  String _currentDate = '';
  String _currentAddress = 'Memuat lokasi...';

  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startDateTimeUpdates();
    _fetchCurrentLocation();
  }

  void _startDateTimeUpdates() {
    _updateDateTime();
    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (_) => _updateDateTime(),
    );
  }

  void _updateDateTime() {
    final data = DateTimeUtil.getFormattedNow();
    setState(() {
      _currentTime = data['time']!;
      _currentDay = data['day']!;
      _currentDate = data['date']!;
    });
  }

  void _fetchCurrentLocation() async {
    final address = await LocationService.getCurrentAddress((status) {
      setState(() {
        _lokasiSiap = status;
      });
    });

    setState(() {
      _currentAddress = address;
    });
  }

  void _catatWaktu() {
    final now = TimeOfDay.now().format(context);
    setState(() {
      if (_step == 0) {
        _waktuBerangkat = now;
        _lokasiBerangkat = _currentAddress;
        _step++;
      } else if (_step > 0 && _step <= _tujuan.length) {
        int tujuanIndex = _waktuTujuan.indexWhere((w) => w == null);
        if (tujuanIndex != -1) {
          _waktuTujuan[tujuanIndex] = now;
          _lokasiTujuan[tujuanIndex] = _currentAddress;
          _step++;
        }
      } else if (_step > _tujuan.length) {
        _waktuPulang = now;
        _lokasiPulang = _currentAddress;
        _step++;
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final maxContentWidth = screenWidth > 400 ? 390.0 : screenWidth * 0.95;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        actions: const [],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Container(
              width: maxContentWidth,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const UserInfo(),
                  const SizedBox(height: 30),
                  _dateTimeLocation(),
                  const SizedBox(height: 30),
                  TimelineWidget(
                    data: TimelineData(
                      tujuan: _tujuan,
                      waktuBerangkat: _waktuBerangkat,
                      waktuTujuan: _waktuTujuan,
                      waktuPulang: _waktuPulang,
                      lokasiBerangkat: _lokasiBerangkat,
                      lokasiPulang: _lokasiPulang,
                    ),
                  ),
                  const SizedBox(height: 25),
                  AttendanceButton(
                    width: 300,
                    height: 50,
                    onConfirm: _catatWaktu,
                    lokasiSiap: _lokasiSiap,
                    waktuBerangkat: _waktuBerangkat,
                    waktuTujuan: _waktuTujuan,
                    waktuPulang: _waktuPulang,
                    tujuan: _tujuan,
                  ),
                  const SizedBox(height: 30),
                  const PerdinDetail(),
                  const SizedBox(height: 25),
                  PerdinNotes(
                    showForm: _showNotesForm,
                    savedNotes: _savedNotes,
                    controller: _noteController,
                    toggleForm: () {
                      setState(() {
                        _showNotesForm = !_showNotesForm;
                        if (_showNotesForm) _noteController.clear();
                      });
                    },
                    onSave: (note) {
                      setState(() {
                        _savedNotes.add(note);
                        _noteController.clear();
                        _showNotesForm = false;
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _dateTimeLocation() {
    return Center(
      child: Column(
        children: [
          Text(
            _currentTime,
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 40,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '$_currentDay, $_currentDate',
            style: const TextStyle(fontSize: 14, color: Colors.black54),
          ),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black, width: 1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.location_on, color: Colors.teal, size: 18),
                const SizedBox(width: 5),
                Flexible(
                  child: Text(
                    _currentAddress,
                    style: const TextStyle(fontSize: 14),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
