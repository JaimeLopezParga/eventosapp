import 'package:eventos_app/pages/eventos_bn_page.dart';
import 'package:eventos_app/pages/inicio_sesion_page.dart';
import 'package:eventos_app/services/google_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';



class LoginUsuarioPage extends StatelessWidget {

  final User user;
  final GoogleAuthService googleAuthService;

  LoginUsuarioPage({Key? key, required this.user, required this.googleAuthService}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(
      centerTitle: true,
        title: Text('Sesión Iniciada',
        style: TextStyle(color: Colors.white,
        fontWeight: FontWeight.bold),
        ),
        backgroundColor: Color(0xFF831B05),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Se ha logueado correctamente, ¿Que desea hacer?',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await googleAuthService.signOut();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => InicioSesionPage(),
                  ),
                  );
              },
              child: Text('Cerrar Sesión'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EventosBNPage(),
                  ),
                );
              },
              child: Text('Ir a Eventos'),
            ),
          ],
        ),
      ),
      );
  }
}