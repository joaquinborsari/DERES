part of 'sign_in_bloc.dart';

@immutable
abstract class SignInEvent extends Equatable {
  const SignInEvent();
}

class SignInEmailChanged extends SignInEvent {
  const SignInEmailChanged(this.email);

  final String email;

  @override
  List<Object?> get props => [email];
}

class SignInPasswordChanged extends SignInEvent {
  const SignInPasswordChanged(this.password);

  final String password;

  @override
  List<Object?> get props => [password];
}

class SignInConfirmationPasswordChanged extends SignInEvent {
  const SignInConfirmationPasswordChanged(this.password);

  final String password;

  @override
  List<Object?> get props => [password];
}

class SignInWithEmailAndPasswordRequested extends SignInEvent {
  const SignInWithEmailAndPasswordRequested();

  @override
  List<Object?> get props => [];
}

class SignInPasswordVisibilityChanged extends SignInEvent {
  const SignInPasswordVisibilityChanged({required this.obscure});

  final bool obscure;

  @override
  List<Object?> get props => [obscure];
}

class SignInPrivilageChanged extends SignInEvent {
  const SignInPrivilageChanged({required this.privilage});

  final Privilege privilage;

  @override
  List<Object?> get props => [privilage];
}
