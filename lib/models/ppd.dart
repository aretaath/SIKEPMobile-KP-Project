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

class PpdModel {
  final String noSpd;
  final LogEntry berangkat;
  final LogEntry lokasi;
  final LogEntry pulang;
  final String totalPerjadin;

  PpdModel({
    required this.noSpd,
    required this.berangkat,
    required this.lokasi,
    required this.pulang,
    required this.totalPerjadin,
  });

  factory PpdModel.fromMap(Map<String, dynamic> data) {
    return PpdModel(
      noSpd: data['no_spd'] ?? '',
      berangkat: LogEntry.fromMap(data['log']['berangkat']),
      lokasi: LogEntry.fromMap(data['log']['lokasi']),
      pulang: LogEntry.fromMap(data['log']['pulang']),
      totalPerjadin: data['total_perjadin'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'no_spd': noSpd,
      'log': {
        'berangkat': berangkat.toMap(),
        'lokasi': lokasi.toMap(),
        'pulang': pulang.toMap(),
      },
      'total_perjadin': totalPerjadin,
    };
  }
}
