abstract class AuthState {
  const AuthState();
}

// page position
// initial state
class AuthStateLoginPage extends AuthState {}

class AuthStateSignUpPage extends AuthState {}

class AuthStateForgetPasswordPage extends AuthState {}

//status
class AuthStateSuccess extends AuthState {}

class AuthStateFailed extends AuthState {}

// actions
// login mode
class AuthStateLoginCred extends AuthState {}

class AuthStateLoginGoogle extends AuthState {}

// sigup mode
class AuthStateSignUp extends AuthState {}

class AuthStateSingUpGoogle extends AuthState {}
