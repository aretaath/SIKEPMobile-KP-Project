class LogEntry {
  final String lokasi;
  final String waktu;

  LogEntry({required this.lokasi, required this.waktu});

  factory LogEntry.fromMap(Map<String, dynamic> data) {
    return LogEntry(lokasi: data['lokasi'] ?? '', waktu: data['waktu'] ?? '');
  }

  Map<String, dynamic> toMap() {
    return {'lokasi': lokasi, 'waktu': waktu};
  }
}

class PerdinModel {
  final String noSpd;
  final String tanggalSpd;
  final String nipKetua;
  final List<String> nipAnggota;
  final List<String> tujuan;
  final String catatan;
  final LogEntry berangkat;
  final LogEntry lokasi;
  final LogEntry pulang;
  final String totalPerjadin;

  PerdinModel({
    required this.noSpd,
    required this.tanggalSpd,
    required this.nipKetua,
    required this.nipAnggota,
    required this.tujuan,
    required this.catatan,
    required this.berangkat,
    required this.lokasi,
    required this.pulang,
    required this.totalPerjadin,
  });

  factory PerdinModel.fromMap(Map<String, dynamic> data) {
    return PerdinModel(
      noSpd: data['no_spd'] ?? '',
      tanggalSpd: data['tanggal_spd'] ?? '',
      nipKetua: data['nip_ketua'] ?? '',
      nipAnggota: List<String>.from(data['nip_anggota'] ?? []),
      tujuan: List<String>.from(data['tujuan'] ?? []),
      catatan: data['catatan'] ?? '',
      berangkat: LogEntry.fromMap(data['log']['berangkat']),
      lokasi: LogEntry.fromMap(data['log']['lokasi']),
      pulang: LogEntry.fromMap(data['log']['pulang']),
      totalPerjadin: data['total_perjadin'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'no_spd': noSpd,
      'tanggal_spd': tanggalSpd,
      'nip_ketua': nipKetua,
      'nip_Anggota': nipAnggota,
      'tujuan': tujuan,
      'catatan': catatan,
      'log': {
        'berangkat': berangkat.toMap(),
        'lokasi': lokasi.toMap(),
        'pulang': pulang.toMap(),
      },
      'total_perjadin': totalPerjadin,
    };
  }
}
