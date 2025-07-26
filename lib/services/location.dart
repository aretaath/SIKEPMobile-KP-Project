import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class LocationService {
  static Future<String> getCurrentAddress(Function(bool) onStatus) async {
    onStatus(false);
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) return 'Layanan lokasi dimatikan';

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied)
          return 'Izin lokasi ditolak';
      }
      if (permission == LocationPermission.deniedForever) {
        return 'Izin lokasi ditolak permanen. Silakan aktifkan di pengaturan.';
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
        final formatted =
            '${place.street ?? ''}, ${place.locality ?? ''}, ${place.subAdministrativeArea ?? ''}, ${place.administrativeArea ?? ''}';
        onStatus(true);
        return formatted.trim().isEmpty ? 'Alamat tidak ditemukan' : formatted;
      } else {
        return 'Alamat tidak ditemukan';
      }
    } catch (e) {
      return 'Gagal mendapatkan lokasi: $e';
    }
  }
}
