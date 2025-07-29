import 'package:sikep/models/perdin.dart';

bool validateSPD(PerdinModel spd) {
  if (spd.nipAnggota.isEmpty) return false;
  if (spd.nipAnggota.contains(spd.nipKetua)) return false;
  return true;
}
