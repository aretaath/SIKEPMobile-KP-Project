class UserModel {
  final String nip;
  final String nama;
  final String nik;
  final String password;

  UserModel({
    required this.nip,
    required this.nama,
    required this.nik,
    required this.password,
  });

  factory UserModel.fromMap(Map<String, dynamic> data) {
    return UserModel(
      nip: data['nip'] ?? '',
      nama: data['nama'] ?? '',
      nik: data['nik'] ?? '',
      password: data['password'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {'nip': nip, 'nama': nama, 'nik': nik, 'password': password};
  }
}
