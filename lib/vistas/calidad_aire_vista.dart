import 'package:flutter/material.dart';
import '../servicios/api_servicio.dart';
import '../modelos/calidad_aire.dart';

class CalidadAireVista extends StatefulWidget {
  const CalidadAireVista({super.key});

  @override
  State<CalidadAireVista> createState() => _CalidadAireVistaState();
}

class _CalidadAireVistaState extends State<CalidadAireVista> {
  final _formKey = GlobalKey<FormState>();
  final _api = ApiServicio();

  List<Map<String, dynamic>> _ciudades = [];
  Map<String, dynamic>? _ciudadSeleccionada;
  String _fecha = DateTime.now().toString().split(' ')[0];
  String _horas = '';
  CalidadAire? _resultado;
  String? _nivelRiesgo;
  double? _indiceExposicion;

  @override
  void initState() {
    super.initState();
    _cargarCiudades();
  }

  Future<void> _cargarCiudades() async {
    final ciudades = await ApiServicio.cargarCiudades();
    setState(() {
      _ciudades = ciudades;
    });
  }

  Future<void> _calcular() async {
    if (_formKey.currentState!.validate() && _ciudadSeleccionada != null) {
      final lat = _ciudadSeleccionada!['latitud'];
      final lon = _ciudadSeleccionada!['longitud'];
      final resultado = await _api.obtenerCalidadAire(lat, lon);

      if (resultado != null) {
        final horas = double.tryParse(_horas) ?? 0;
        final indice = resultado.pm2_5 * horas;
        String riesgo;

        if (indice < 100) {
          riesgo = "Bajo";
        } else if (indice < 200) {
          riesgo = "Moderado";
        } else {
          riesgo = "Alto";
        }

        setState(() {
          _resultado = resultado;
          _indiceExposicion = indice;
          _nivelRiesgo = riesgo;
        });
      }
    }
  }

  IconData _iconoRiesgo(String riesgo) {
    switch (riesgo) {
      case "Bajo":
        return Icons.sentiment_satisfied_alt;
      case "Moderado":
        return Icons.sentiment_neutral;
      case "Alto":
        return Icons.warning_amber_rounded;
      default:
        return Icons.help_outline;
    }
  }

  Color _colorRiesgo(String riesgo) {
    switch (riesgo) {
      case "Bajo":
        return Colors.green;
      case "Moderado":
        return Colors.orange;
      case "Alto":
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Calculadora de Calidad del Aire"),
        backgroundColor: Colors.teal,
      ),
      body: _ciudades.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    DropdownButtonFormField<Map<String, dynamic>>(
                      value: _ciudadSeleccionada,
                      items: _ciudades
                          .map(
                            (ciudad) => DropdownMenuItem(
                              value: ciudad,
                              child: Text(ciudad['nombre']),
                            ),
                          )
                          .toList(),
                      onChanged: (valor) {
                        setState(() {
                          _ciudadSeleccionada = valor;
                        });
                      },
                      decoration: const InputDecoration(
                        labelText: 'Ciudad',
                        border: OutlineInputBorder(),
                      ),
                      validator: (valor) =>
                          valor == null ? 'Selecciona una ciudad' : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      readOnly: true,
                      controller: TextEditingController(text: _fecha),
                      decoration: InputDecoration(
                        labelText: 'Fecha',
                        border: const OutlineInputBorder(),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.calendar_today),
                          onPressed: () async {
                            final DateTime? nuevaFecha = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(2020),
                              lastDate: DateTime(2030),
                            );
                            if (nuevaFecha != null) {
                              setState(() {
                                _fecha = nuevaFecha.toString().split(' ')[0];
                              });
                            }
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Horas de exposición',
                        border: OutlineInputBorder(),
                      ),
                      validator: (valor) {
                        if (valor == null || valor.isEmpty) {
                          return 'Ingresa las horas de exposición';
                        }
                        return null;
                      },
                      onChanged: (valor) => _horas = valor,
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton.icon(
                      onPressed: _calcular,
                      icon: const Icon(Icons.cloud),
                      label: const Text(
                        'Calcular Riesgo',
                        style: TextStyle(fontSize: 16),
                      ),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        backgroundColor: Colors.teal,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 4,
                      ),
                    ),
                    const SizedBox(height: 24),
                    if (_resultado != null)
                      Card(
                        color: Colors.teal.shade50,
                        elevation: 3,
                        margin: const EdgeInsets.only(top: 10),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Resultados de Calidad del Aire",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                              const Divider(),
                              Text("PM10: ${_resultado!.pm10} µg/m³"),
                              Text("PM2.5: ${_resultado!.pm2_5} µg/m³"),
                              Text("O₃: ${_resultado!.o3} µg/m³"),
                              Text("NO₂: ${_resultado!.no2} µg/m³"),
                              Text("SO₂: ${_resultado!.so2} µg/m³"),
                              Text("CO: ${_resultado!.co} µg/m³"),
                              const SizedBox(height: 10),
                              if (_indiceExposicion != null)
                                Text(
                                  "Índice de exposición: ${_indiceExposicion!.toStringAsFixed(1)}",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              if (_nivelRiesgo != null)
                                Container(
                                  margin: const EdgeInsets.only(
                                    top: 10,
                                    bottom: 5,
                                  ),
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: _colorRiesgo(
                                      _nivelRiesgo!,
                                    ).withAlpha(40),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(
                                        _iconoRiesgo(_nivelRiesgo!),
                                        color: _colorRiesgo(_nivelRiesgo!),
                                        size: 28,
                                      ),
                                      const SizedBox(width: 10),
                                      Text(
                                        "Nivel de riesgo: $_nivelRiesgo",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: _colorRiesgo(_nivelRiesgo!),
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
    );
  }
}
