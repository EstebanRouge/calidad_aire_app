class CalidadAire {
  final double pm10;
  final double pm2_5;
  final double o3;
  final double no2;
  final double so2;
  final double co;

  CalidadAire({
    required this.pm10,
    required this.pm2_5,
    required this.o3,
    required this.no2,
    required this.so2,
    required this.co,
  });

  /// Construye el objeto desde un mapa JSON (respetando valores nulos o mixtos)
  factory CalidadAire.fromJson(Map<String, dynamic> json) {
    double _parse(dynamic value) {
      if (value == null) return 0.0;
      if (value is num) return value.toDouble();
      if (value is String) return double.tryParse(value) ?? 0.0;
      return 0.0;
    }

    return CalidadAire(
      pm10: _parse(json['pm10']),
      pm2_5: _parse(json['pm2_5']),
      o3: _parse(json['o3']),
      no2: _parse(json['no2']),
      so2: _parse(json['so2']),
      co: _parse(json['co']),
    );
  }

  /// Calcula un índice de riesgo simplificado según los valores promedios
  String nivelRiesgo() {
    final promedio = (pm10 + pm2_5 + o3 + no2 + so2 + co) / 6;

    if (promedio < 50) return "Buena 🌿";
    if (promedio < 100) return "Moderada 😐";
    if (promedio < 150) return "Dañina para grupos sensibles ⚠️";
    if (promedio < 200) return "Dañina para la salud 😷";
    if (promedio < 300) return "Muy dañina 🚫";
    return "Peligrosa ☠️";
  }

  /// Devuelve un color sugerido según el nivel de riesgo
  int colorRiesgo() {
    final promedio = (pm10 + pm2_5 + o3 + no2 + so2 + co) / 6;

    if (promedio < 50) return 0xFF81C784; // verde
    if (promedio < 100) return 0xFFFFF176; // amarillo
    if (promedio < 150) return 0xFFFFB74D; // naranja
    if (promedio < 200) return 0xFFE57373; // rojo claro
    if (promedio < 300) return 0xFFD32F2F; // rojo oscuro
    return 0xFF4A148C; // morado oscuro
  }

  @override
  String toString() {
    return 'CalidadAire(pm10: $pm10, pm2_5: $pm2_5, o3: $o3, no2: $no2, so2: $so2, co: $co)';
  }
}
