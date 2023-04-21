class SignUpWithEmailAndPasswordFailure {
  final String message;
  const SignUpWithEmailAndPasswordFailure(
      [this.message = "Unknown error occured."]);
  factory SignUpWithEmailAndPasswordFailure.code(String code) {
    switch (code) {
      case 'weak-password':
        return const SignUpWithEmailAndPasswordFailure(
            'Please enter a strong password');
      case 'invalid-email':
        return const SignUpWithEmailAndPasswordFailure(
            'Email is not valid or badly formatted');
      case 'email-already-in-use':
        return const SignUpWithEmailAndPasswordFailure(
            'An account already exists for that email');
      case 'operation-not-allowed':
        return const SignUpWithEmailAndPasswordFailure(
            'Operation is not allowed.Please contact support.');
      case 'user-disabled':
        return const SignUpWithEmailAndPasswordFailure(
            'This user has been disabled.Please contact support for help.');
      case 'wrong-password':
        return const SignUpWithEmailAndPasswordFailure(
            'Wrong password'); 
      case 'user-not-found':
        return const SignUpWithEmailAndPasswordFailure(
            'User not found.Check your email address and try again.'); 
      case 'account-exists-with-different-credential':
        return const SignUpWithEmailAndPasswordFailure(
            'Account exists with different credentials');
      default:
        return const SignUpWithEmailAndPasswordFailure();
    }
  }
}
