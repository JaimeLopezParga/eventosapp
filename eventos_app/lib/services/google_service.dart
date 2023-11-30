  import 'package:firebase_auth/firebase_auth.dart';
  import 'package:google_sign_in/google_sign_in.dart';


class GoogleAuthService {

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

//Iniciar sesión con Google
Future<User?> iniciarsesionGoogle() async {
  try {
    // Acá se solicita al usuario con que cuenta de google en el teléfono desea iniciar sesión
    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

    // Si el usuario cancela el inicio de sesión, regresará un null
    if (googleUser == null) return null;

    // Se obtiene la credencial con la que se inicia sesión
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    // Se crean credenciales de Firebase con las de Google    
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    // Se inicia sesión en Firebase con las credenciales de Google
    UserCredential userCredential =
        await _auth.signInWithCredential(credential);

    // Se devuelve el usuario autenticado
    return userCredential.user;
    
  } catch (e) {
    // Acá se captura y maneja errores durante el proceso de inicio de sesión
    print("Ha ocurrido un error en el proceso: $e");
    throw Exception("Ha fallado el inicio de sesión");
  }
  
}

// Este método es para cerrar sesión
Future<void> signOut() async {
  // Cerramos sesión en Firebase
  await _auth.signOut();
  // Cerramos sesión de la cuenta de Google
  await _googleSignIn.signOut();
}

}