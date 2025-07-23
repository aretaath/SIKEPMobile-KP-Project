import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:intl/intl.dart';
import 'package:sikep/widgets/attendance.dart';
import 'package:sikep/widgets/timeline.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();

  static const TextStyle _userNameStyle = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 18,
    color: Colors.black,
  );

  static const TextStyle _userNipStyle = TextStyle(
    fontWeight: FontWeight.normal,
    fontSize: 14,
    color: Colors.black54,
  );
  static const TextStyle _timeStyle = TextStyle(
    fontWeight: FontWeight.w700,
    fontSize: 40,
    color: Colors.black,
  );
  static const TextStyle _dateStyle = TextStyle(
    fontSize: 14,
    color: Colors.black54,
  );
}

class _HomePageState extends State<HomePage> {
  String? _waktuBerangkat;
  List<String?> _waktuTujuan = [null, null];
  String? _waktuPulang;
  List<String> _tujuan = ['Kantor Cabang', 'Lokasi Proyek'];
  String? _lokasiBerangkat;
  String? _lokasiPulang;

  int _step = 0;

  bool _showOfficialTripDetail = true;
  bool _showNotesForm = false;

  final List<String> _savedNotes = [];
  final TextEditingController _noteController = TextEditingController();

  String _currentTime = '';
  String _currentDay = '';
  String _currentDate = '';
  String _currentAddress = 'Memuat lokasi...';

  Timer? _timer;
  int? _selectedTujuanIndex;

  List<String?> _lokasiTujuan = [null, null];

  @override
  void initState() {
    super.initState();
    _startDateTimeUpdates();
    _fetchCurrentLocation();
  }

  void _startDateTimeUpdates() {
    _updateDateTime();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      _updateDateTime();
    });
  }

  void _updateDateTime() {
    final now = DateTime.now();
    const locale = 'id_ID';

    setState(() {
      _currentTime = DateFormat('HH:mm', locale).format(now);
      _currentDay = DateFormat('EEEE', locale).format(now);
      _currentDate = DateFormat('d MMMM yyyy', locale).format(now);
    });
  }

  Future<void> _fetchCurrentLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() {
          _currentAddress = 'Layanan lokasi dimatikan';
        });
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          setState(() {
            _currentAddress = 'Izin lokasi ditolak';
          });
          return;
        }
      }
      if (permission == LocationPermission.deniedForever) {
        setState(() {
          _currentAddress =
              'Izin lokasi ditolak permanen. Silakan aktifkan di pengaturan.';
        });
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best,
        timeLimit: Duration(seconds: 10),
      );

      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        final place = placemarks.first;
        setState(() {
          _currentAddress =
              '${place.street ?? ''}, ${place.locality ?? ''}, ${place.subAdministrativeArea ?? ''}, ${place.administrativeArea ?? ''}';
          if (_currentAddress.trim().isEmpty) {
            _currentAddress = 'Alamat tidak ditemukan';
          }
        });
      } else {
        setState(() {
          _currentAddress = 'Alamat tidak ditemukan';
        });
      }
    } catch (e) {
      setState(() {
        _currentAddress = 'Gagal mendapatkan lokasi: $e';
      });
    }
  }

  void _showBerangkatInfo() {
    if (_waktuBerangkat == null) return;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Detail Keberangkatan'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Waktu: $_waktuBerangkat',
              style: const TextStyle(color: Colors.teal, fontSize: 14),
            ),
            const SizedBox(height: 8),
            Text(
              'Lokasi: ${_lokasiBerangkat ?? 'Tidak tersedia'}',
              style: const TextStyle(color: Colors.black54, fontSize: 13),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }

  void _showTujuanDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Pilih Tujuan'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(_tujuan.length, (i) {
              final sudahDicatat = _waktuTujuan[i] != null;
              return Column(
                children: [
                  ListTile(
                    title: Text(
                      _tujuan[i],
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          sudahDicatat
                              ? 'Tiba: ${_waktuTujuan[i]}'
                              : 'Belum dicatat',
                          style: TextStyle(
                            color: sudahDicatat ? Colors.teal : Colors.red,
                            fontSize: 13,
                          ),
                        ),
                        if (_lokasiTujuan[i] != null)
                          Text(
                            'Lokasi: ${_lokasiTujuan[i]}',
                            style: const TextStyle(
                              fontSize: 13,
                              color: Colors.black54,
                            ),
                          ),
                      ],
                    ),
                    trailing: sudahDicatat
                        ? const Icon(Icons.check_circle, color: Colors.teal)
                        : ElevatedButton(
                            onPressed: () {
                              setState(() {
                                _selectedTujuanIndex = i;
                              });
                              Navigator.pop(context);
                            },
                            child: const Text('Pilih'),
                          ),
                  ),
                  if (i != _tujuan.length - 1)
                    const Divider(height: 0, thickness: 0.5),
                ],
              );
            }),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Tutup'),
            ),
          ],
        );
      },
    );
  }

  void _showPulangInfo() {
    if (_waktuPulang == null) return;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Detail Kepulangan'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Waktu: $_waktuPulang',
              style: const TextStyle(color: Colors.teal, fontSize: 14),
            ),
            const SizedBox(height: 8),
            Text(
              'Lokasi: ${_lokasiPulang ?? 'Tidak tersedia'}',
              style: const TextStyle(color: Colors.black54, fontSize: 13),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }

  void _catatWaktu() {
    final now = TimeOfDay.now().format(context);
    setState(() {
      if (_step == 0) {
        _waktuBerangkat = now;
        _lokasiBerangkat = _currentAddress;
      } else if (_step > 0 && _step <= _tujuan.length) {
        if (_selectedTujuanIndex != null) {
          _waktuTujuan[_selectedTujuanIndex!] = now;
          _lokasiTujuan[_selectedTujuanIndex!] = _currentAddress;
          _selectedTujuanIndex = null;
        }
      } else if (_step > _tujuan.length) {
        _waktuPulang = now;
        _lokasiPulang = _currentAddress;
      }
      _step++;
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
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Container(
              width: maxContentWidth,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _userInfo(),
                  const SizedBox(height: 30),
                  _dateTimeLocation(),
                  const SizedBox(height: 30),
                  _timeline(),
                  const SizedBox(height: 25),
                  _attendanceButton(),
                  const SizedBox(height: 30),
                  _perdinDetail(),
                  const SizedBox(height: 25),
                  _perdinNotes(),
                  const SizedBox(height: 25),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _userInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text('Nama Pegawai', style: HomePage._userNameStyle),
        Text('NIP Pegawai', style: HomePage._userNipStyle),
      ],
    );
  }

  Widget _dateTimeLocation() {
    return Center(
      child: Column(
        children: [
          Text(_currentTime, style: HomePage._timeStyle),
          const SizedBox(height: 4),
          Text('$_currentDay, $_currentDate', style: HomePage._dateStyle),
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

  Widget _timeline() {
    return TimelineWidget(
      data: TimelineData(
        tujuan: _tujuan,
        waktuBerangkat: _waktuBerangkat,
        waktuTujuan: _waktuTujuan,
        waktuPulang: _waktuPulang,
        lokasiBerangkat: _lokasiBerangkat,
        lokasiPulang: _lokasiPulang,
      ),
      onDitempatTap: _showTujuanDialog,
      onBerangkatTap: _showBerangkatInfo,
      onPulangTap: _showPulangInfo,
    );
  }

  Widget _attendanceButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: AttendanceButton(
        width: 300,
        height: 50,
        onConfirm: (selectedTujuan) {
          _catatWaktu();
        },
        tujuan: _tujuan,
        selectedTujuan: _selectedTujuanIndex != null
            ? _tujuan[_selectedTujuanIndex!]
            : null,
        onRequestSelectTujuan: _showTujuanDialog,
      ),
    );
  }

  Widget _perdinDetail() {
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
          const SizedBox(height: 8),
          if (_showOfficialTripDetail)
            Container(
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
        ],
      ),
    );
  }

  Widget _perdinNotes() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFF38C7A8),
        borderRadius: BorderRadius.circular(15),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Catatan Perjalanan Dinas',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    _showNotesForm = !_showNotesForm;
                    if (_showNotesForm) {
                      _noteController.clear();
                    }
                  });
                },
                child: Icon(
                  _showNotesForm ? Icons.close : Icons.add,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (_showNotesForm)
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x3f000000),
                    offset: Offset(0, 0),
                    blurRadius: 5,
                  ),
                ],
              ),
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    constraints: BoxConstraints(minHeight: 80, maxHeight: 120),
                    child: TextField(
                      controller: _noteController,
                      maxLines: null,
                      expands: true,
                      textAlignVertical: TextAlignVertical.top,
                      decoration: InputDecoration(
                        hintText: 'Tulis catatan ...',
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 12,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  SizedBox(
                    width: double.infinity,
                    height: 42,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xff3cbb92),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      onPressed: () {
                        if (_noteController.text.trim().isNotEmpty) {
                          setState(() {
                            _savedNotes.add(_noteController.text.trim());
                            _noteController.clear();
                            _showNotesForm = false;
                          });
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Catatan tidak boleh kosong'),
                            ),
                          );
                        }
                      },
                      child: const Text(
                        'Simpan',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          if (_savedNotes.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 12.0),
              child: Column(
                children: _savedNotes
                    .map((note) => _perdinNoteDisplay(note))
                    .toList(),
              ),
            ),
        ],
      ),
    );
  }

  Widget _perdinNoteDisplay(String note) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade300),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
      child: Text(
        note,
        style: const TextStyle(fontSize: 16, color: Colors.black),
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
