class PerdinModel {
  final String noSpd;
  final String tanggalSpd;
  final String nipKetua;
  final List<String> anggota;
  final List<String> tujuan;
  final String catatan;

  PerdinModel({
    required this.noSpd,
    required this.tanggalSpd,
    required this.nipKetua,
    required this.anggota,
    required this.tujuan,
    required this.catatan,
  });

  factory PerdinModel.fromMap(Map<String, dynamic> data) {
    return PerdinModel(
      noSpd: data['no_spd'] ?? '',
      tanggalSpd: data['tanggal_spd'] ?? '',
      nipKetua: data['nip_ketua'] ?? '',
      anggota: List<String>.from(data['anggota'] ?? []),
      tujuan: List<String>.from(data['tujuan'] ?? []),
      catatan: data['catatan'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'no_spd': noSpd,
      'tanggal_spd': tanggalSpd,
      'nip_ketua': nipKetua,
      'anggota': anggota,
      'tujuan': tujuan,
      'catatan': catatan,
    };
  }
}
