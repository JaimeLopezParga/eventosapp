import 'package:eventos_app/services/firestore-service.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class EventosActivosTabPage extends StatelessWidget {
  const EventosActivosTabPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        centerTitle: true,
        title: Text("Eventos Activos", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      body: Padding(
        padding: EdgeInsets.all(8),
        child: StreamBuilder(
          stream: FirestoreService().obtenerEventos(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData || snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else {
              return FutureBuilder<int>(
                future: FirestoreService().cantidadFuturo(), // Llamada al método futuro
                builder: (context, AsyncSnapshot<int> itemCountSnapshot) {
                  if (itemCountSnapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (itemCountSnapshot.hasError) {
                    return Center(child: Text('Error: ${itemCountSnapshot.error}'));
                  } else {
                    return ListView.separated(
                      separatorBuilder: (context, index) => Divider(),
                      itemCount: itemCountSnapshot.data ?? 0,
                      itemBuilder: (context, index) {
                        var evento = snapshot.data!.docs[index];
                        if (evento['proyeccion']==true){
                          return Slidable(
                            startActionPane: ActionPane(
                              motion: ScrollMotion(),
                              children: [
                                SlidableAction(
                                  icon: MdiIcons.sunCompass,
                                  label: 'Toggle',
                                  backgroundColor: Colors.yellow,
                                  onPressed: (context) {
                                    FirestoreService().modificarActivo(evento.id, false);
                                  },
                                ),
                              ],
                            ),
                            endActionPane: ActionPane(
                              motion: ScrollMotion(),
                              children: [
                                SlidableAction(
                                  icon: MdiIcons.sunCompass,
                                  label: 'Me gusta',
                                  backgroundColor: Colors.green,
                                  onPressed: (context) {
                                    FirestoreService().incrementarCantidadMG(evento.id);
                                  },
                                ),
                              ],
                            ),
                            child: ListTile(
                              leading: Image.network(evento['fotografia'], width: 50, height: 50), // Imagen del evento
                              title: Text('${evento['nombre']}'),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Descripción: ${evento['descripcion']}'),
                                  Text('Dirección: ${evento['direccion']}'),
                                  Text('Fecha: ${evento['fecha']}'),
                                  Text('Tipo: ${evento['tipo']}'),
                                  Text('Tipo: ${evento['cantidadmg']}'),
                                ],
                              ),
                            ),
                          );
                        } else{
                          return Container();
                        }
                      },
                    );
                  }
                },
              );
            }
          },
        ),
      ),
    );
  }
}
