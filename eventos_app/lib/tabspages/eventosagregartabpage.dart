import 'dart:io';
import 'package:eventos_app/services/firestore-service.dart';
import 'package:eventos_app/services/select_image_service.dart';
import 'package:eventos_app/services/upload_image.dart';
import 'package:flutter/material.dart';

class EventosAgregarTabPage extends StatefulWidget {
  @override
  _EventosAgregarTabPageState createState() => _EventosAgregarTabPageState();
}

class _EventosAgregarTabPageState extends State<EventosAgregarTabPage> {
  final TextEditingController _tituloController = TextEditingController();
  final TextEditingController _descripcionController = TextEditingController();
  final TextEditingController _fechaController = TextEditingController();
  final TextEditingController _ubicacionController = TextEditingController();

  List<String> _tiposEventos = [
    'Concierto',
    'Fiesta',
    'Evento Deportivo',
    'Seminario',
    'Charla',
    'Comunitario',
  ];

  String _tipoEventoSeleccionado = 'Concierto';
  File? _imagenSeleccionada;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Crear Nuevo Evento'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: _tituloController,
              decoration: InputDecoration(labelText: 'Título del Evento'),
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: _descripcionController,
              decoration: InputDecoration(labelText: 'Descripción del Evento'),
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: _fechaController,
              decoration: InputDecoration(labelText: 'Fecha del Evento'),
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: _ubicacionController,
              decoration: InputDecoration(labelText: 'Ubicación del Evento'),
            ),
            SizedBox(height: 10),
            DropdownButton<String>(
              value: _tipoEventoSeleccionado,
              onChanged: (String? newValue) {
                setState(() {
                  _tipoEventoSeleccionado = newValue!;
                });
              },
              items: _tiposEventos.map((String tipoEvento) {
                return DropdownMenuItem<String>(
                  value: tipoEvento,
                  child: Text(tipoEvento),
                );
              }).toList(),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () async {
                final imagen = await getImage();
                setState(() {
                  _imagenSeleccionada = File(imagen!.path);
                });
              },
              child: Text('Seleccionar Imagen'),
            ),
            SizedBox(height: 10),
            _imagenSeleccionada != null
                ? Image.file(_imagenSeleccionada!)
                : Container(
                    height: 200,
                    width: double.infinity,
                    color: Colors.green.shade700,
                  ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                // Lógica para guardar el evento
                await _guardarEvento();
              },
              child: Text('Guardar Evento'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _guardarEvento() async {
    // Aquí implementar la lógica para guardar el evento
    String nombre = _tituloController.text;
    String fechayhora = _fechaController.text;
    String descripcion = _descripcionController.text;
    String lugar = _ubicacionController.text;
    String tipo = _tipoEventoSeleccionado;

    FirestoreService().agregarEvento(nombre, fechayhora, descripcion, lugar, tipo, 0, true, true, '');

    // Acá se sube la imagen seleccionada
    if (_imagenSeleccionada != null) {
      bool subidaExitosa = await uploadImage(_imagenSeleccionada!);

      if (subidaExitosa) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('El evento y la imagen se han guardado con éxito'),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error al guardar la imagen')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Debes seleccionar una imagen')),
      );
    }
  }
}