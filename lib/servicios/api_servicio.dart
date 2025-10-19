import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:http/http.dart' as http;
import '../modelos/calidad_aire.dart';

class ApiServicio {
  static const String _baseUrl =
      "https://air-quality-api.open-meteo.com/v1/air-quality";

  /// Cargar las ciudades desde el archivo local JSON
  static Future<List<Map<String, dynamic>>> cargarCiudades() async {
    final String data = await rootBundle.loadString(
      'assets/datos/capitales_colombia.json',
    );
    final List<dynamic> jsonResult = json.decode(data);
    return jsonResult.cast<Map<String, dynamic>>();
  }

  /// Obtener datos de calidad del aire desde la API
  Future<CalidadAire?> obtenerCalidadAire(double lat, double lon) async {
    // Construimos la URL correctamente según la documentación de Open-Meteo
    final url = Uri.parse(
      "$_baseUrl?latitude=$lat&longitude=$lon&hourly=pm10,pm2_5,carbon_monoxide,nitrogen_dioxide,sulphur_dioxide,ozone&timezone=America/Bogota",
    );

    final respuesta = await http.get(url);

    if (respuesta.statusCode == 200) {
      final data = json.decode(respuesta.body);
      final hourly = data['hourly'];

      // Tomamos el primer valor disponible (hora 0)
      final pm10 = (hourly['pm10'][0] ?? 0).toDouble();
      final pm2_5 = (hourly['pm2_5'][0] ?? 0).toDouble();
      final o3 = (hourly['ozone'][0] ?? 0).toDouble();
      final no2 = (hourly['nitrogen_dioxide'][0] ?? 0).toDouble();
      final so2 = (hourly['sulphur_dioxide'][0] ?? 0).toDouble();
      final co = (hourly['carbon_monoxide'][0] ?? 0).toDouble();

      return CalidadAire.fromJson({
        'pm10': pm10,
        'pm2_5': pm2_5,
        'o3': o3,
        'no2': no2,
        'so2': so2,
        'co': co,
      });
    } else {
      print("Error al obtener datos: ${respuesta.statusCode}");
      print("URL fallida: $url");
      return null;
    }
  }
}
