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

class SignInUserNameChanged extends SignInEvent {
  const SignInUserNameChanged(this.username);

  final String username;

  @override
  List<Object?> get props => [username];
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

class SignInPhoneChanged extends SignInEvent {
  const SignInPhoneChanged(this.phone);

  final String phone;

  @override
  List<Object?> get props => [phone];
}

class SignInAddressChanged extends SignInEvent {
  const SignInAddressChanged(this.address);

  final String address;

  @override
  List<Object?> get props => [address];
}

class SignInContactsChanged extends SignInEvent {
  const SignInContactsChanged(this.contact);

  final String contact;

  @override
  List<Object?> get props => [contact];
}

class SignInRutChanged extends SignInEvent {
  const SignInRutChanged(this.rut);

  final String rut;

  @override
  List<Object?> get props => [rut];
}

class SignInTypeChanged extends SignInEvent {
  const SignInTypeChanged(this.type);

  final String type;

  @override
  List<Object?> get props => [type];
}

class SignInPhonehanged extends SignInEvent {
  const SignInPhonehanged(this.phone);

  final String phone;

  @override
  List<Object?> get props => [phone];
}

class SignInDataChanged extends SignInEvent {
  const SignInDataChanged();

  @override
  List<Object?> get props => [];
}
