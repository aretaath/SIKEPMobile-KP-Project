import 'package:sikep/models/spd.dart';

bool validateSPD(PerdinModel spd) {
  if (spd.anggota.isEmpty) return false;
  if (spd.anggota.contains(spd.nipKetua)) return false;
  return true;
}
