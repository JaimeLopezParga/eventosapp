import 'package:eventos_app/pages/eventos_bn_page.dart';
import 'package:eventos_app/pages/login_usuario_page.dart';
import 'package:eventos_app/services/google_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


class InicioSesionPage extends StatefulWidget {
  
  @override
  State<InicioSesionPage> createState() => _InicioSesionPageState();
}

class _InicioSesionPageState extends State<InicioSesionPage> {
  final GoogleAuthService googleAuthService = GoogleAuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(
        centerTitle: true,
        title: Text('Bienvenido',
        style: TextStyle(color: Colors.white,
        fontWeight: FontWeight.bold),
        ),
        backgroundColor: Color(0xFF831B05),
      ),
      body: Center(
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () async {
                User? authenticatedUser = await googleAuthService.iniciarsesionGoogle();
                if (authenticatedUser != null) {
                  Navigator.push(
                    context, 
                    MaterialPageRoute(
                      builder: (context) => LoginUsuarioPage(
                        user: authenticatedUser, 
                        googleAuthService: googleAuthService),
                        ),
                        );
                } else {
                  print('Ha fallado en el inicio de sesión');
                }
              },
              child: Text('Iniciar Sesión con Google'),
            ),
            SizedBox(height: 20),
            ElevatedButton(onPressed: () {
              Navigator.push(context,
              MaterialPageRoute(builder: (context) => EventosBNPage(),
              ),
              );
            }, 
            child: Text('Entrar como Invitado'),
            ),
          ],
        ),

      ),);
  }
}