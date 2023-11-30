import 'package:eventos_app/providers/autenticacion.dart';
import 'package:eventos_app/tabspages/eventosactivostabpage.dart';
import 'package:eventos_app/tabspages/eventosagregartabpage.dart';
import 'package:eventos_app/tabspages/eventospasadostabpage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class EventosBNPage extends StatefulWidget {
  const EventosBNPage({Key? key}) : super(key: key);

  @override
  State<EventosBNPage> createState() => _EventosBNPageState();
}

class _EventosBNPageState extends State<EventosBNPage> {
  int paginaSeleccionada = 0;
  late Widget pagina;

  @override
  void initState() {
    super.initState();
    pagina = EventosPasadosTabPage();
  }

  void cambiarPagina(int index) {
    setState(() {
      paginaSeleccionada = index;
      switch (paginaSeleccionada) {
        case 0:
          pagina = EventosPasadosTabPage();
          break;
        case 1:
          pagina = EventosActivosTabPage();
          break;
        case 2:
          // Obtenemos el estado de invitado desde el provider
          bool esInvitado = context.read<Autenticacion>().isGuest;

          // Muestra la página de invitados o EventosAgregarTabPage dependiendo del estado
          if (esInvitado) {
            _mostrarMensajeInvitado(); // Muestra el mensaje para usuarios invitados
          } else {
            pagina = EventosAgregarTabPage();
          }
          break;
      }
    });
  }

  void _mostrarMensajeInvitado() {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text('Acceso Restringido'),
        content: Column(
          children: [
            Text(
              'Lo siento, como invitado no puedes agregar eventos.',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 10),
            Text(
              'Que te diviertas viendo los eventos pasados como también los activos.',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop(); // Cierra el cuadro de diálogo
            },
            child: Text('Aceptar'),
          ),
        ],
      );
    },
  );
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        centerTitle: true,
        title: Text(
          'Eventos "La confrontación" ',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: pagina,
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.yellow,
        currentIndex: paginaSeleccionada,
        type: BottomNavigationBarType.shifting,
        items: [
          BottomNavigationBarItem(
            label: 'Eventos Pasados',
            icon: Icon(MdiIcons.closeOutline),
            backgroundColor: Colors.black,
          ),
          BottomNavigationBarItem(
            label: 'Eventos Activos',
            icon: Icon(MdiIcons.giftOpenOutline),
            backgroundColor: Colors.black,
          ),
          BottomNavigationBarItem(
            label: 'Agregar Evento',
            icon: Icon(MdiIcons.clockIn),
            backgroundColor: Colors.black,
          ),
        ],
        onTap: (index) {
          cambiarPagina(index); // Cambia de página al hacer clic en un tab
        },
      ),
      floatingActionButton: context.watch<Autenticacion>().isGuest
          ? null // Deshabilita el botón de agregar eventos para invitados
          : FloatingActionButton(
              onPressed: () {
                // Clic del botón agregar eventos
              },
              child: Icon(Icons.add),
            ),
    );
  }
}