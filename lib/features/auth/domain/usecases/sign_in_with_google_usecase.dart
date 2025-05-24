import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:offgrid_nation_app/core/session/auth_session.dart';
import 'package:offgrid_nation_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:offgrid_nation_app/injection_container.dart';
import 'package:offgrid_nation_app/core/utils/jwt_util.dart'; // 🔐

class SignInWithGoogleUseCase {
  final AuthRepository repository;
  final FirebaseAuth firebaseAuth;
  final GoogleSignIn googleSignIn;

  SignInWithGoogleUseCase({
    required this.repository,
    required this.firebaseAuth,
    required this.googleSignIn,
  });

  Future<String> call() async {
    try {
      // ✅ Step 1: Sign-in with Google
      final googleUser = await googleSignIn.signIn();
      if (googleUser == null) {
        throw Exception('Google sign-in aborted by user.');
      }

      final googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await firebaseAuth.signInWithCredential(
        credential,
      );
      final user = userCredential.user;
      if (user == null) {
        throw Exception('Firebase user is null after sign-in.');
      }

      // ✅ Step 2: Extract user info
      final uid = user.uid;
      final email = user.email ?? '';
      final phone = user.phoneNumber ?? '';
      final displayName = user.displayName ?? 'User';

      // ✅ Step 3: Generate JWT locally using shared secret
      final jwtToken = JwtUtil.generateUserJwt(
        uid: uid,
        email: email,
        displayName: displayName,
      );

      // ✅ Step 4: Send to your backend
      final authKey = await repository.googleLogin(jwtToken);

      // ✅ Step 5: Save session
      await sl<AuthSession>().saveSessionToken(authKey, uid);

      return authKey;
    } catch (e) {
      throw Exception('Google sign-in failed: $e');
    }
  }
}
