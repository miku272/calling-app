abstract interface class AuthRemoteDatasource {
  Future<String> signUpWithEmailAndPassword({
    required String email,
    required String password,
  });
  Future<String> signInWithEmailAndPassword({
    required String email,
    required String password,
  });
  Future<void> sendPasswordResetEmail({required String email});
}
