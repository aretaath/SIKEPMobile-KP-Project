class UserModel {
  final String nip;
  final String nama;
  final String nik;
  final String password;
  final String role;
  final String? noSpd;

  UserModel({
    required this.nip,
    required this.nama,
    required this.nik,
    required this.password,
    required this.role,
    required this.noSpd,
  });

  factory UserModel.fromMap(Map<String, dynamic> data) {
    return UserModel(
      nip: data['nip'] ?? '',
      nama: data['nama'] ?? '',
      nik: data['nik'] ?? '',
      password: data['password'] ?? '',
      role: data['role'] ?? 'anggota',
      noSpd: data['no_spd'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'nip': nip,
      'nama': nama,
      'nik': nik,
      'password': password,
      'role': role,
      'no_spd': noSpd,
    };
  }
}
