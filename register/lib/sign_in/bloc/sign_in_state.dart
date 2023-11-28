part of 'sign_in_bloc.dart';

enum Privilege {
  user,
  admin,
  provider,
  all,
  undefined;
}

class SignInState extends Equatable {
  const SignInState({
    required this.status,
    required this.email,
    required this.password,
    required this.confirmationPassword,
    required this.obscurePasswords,
    required this.privilege,
    required this.username,
    required this.address,
    required this.contact,
    required this.phone,
    required this.rut,
    required this.type,
  });

  const SignInState.initial()
      : this(
            status: FormzSubmissionStatus.initial,
            email: const Email.pure(),
            password: const Password.pure(),
            confirmationPassword: '',
            privilege: Privilege.undefined,
            obscurePasswords: true,
            username: '',
            address: '',
            contact: '',
            rut: '',
            type: '',
            phone: '');

  final FormzSubmissionStatus status;
  final Email email;
  final Password password;
  final String confirmationPassword;
  final bool obscurePasswords;
  final Privilege privilege;
  final String username;
  final String rut;
  final String type;
  final String contact;
  final String phone;
  final String address;

  SignInState copyWith({
    FormzSubmissionStatus? status,
    Email? email,
    Password? password,
    String? confirmationPassword,
    bool? obscurePasswords,
    Privilege? privilege,
    String? username,
    String? phone,
    String? rut,
    String? type,
    String? contact,
    String? address,
  }) {
    return SignInState(
      status: status ?? this.status,
      confirmationPassword: confirmationPassword ?? this.confirmationPassword,
      email: email ?? this.email,
      obscurePasswords: obscurePasswords ?? this.obscurePasswords,
      password: password ?? this.password,
      privilege: privilege ?? this.privilege,
      username: username ?? this.username,
      phone: phone ?? this.phone,
      rut: rut ?? this.rut,
      type: type ?? this.type,
      contact: contact ?? this.contact,
      address: address ?? this.address,
    );
  }

  @override
  List<Object> get props => [
        status,
        email,
        password,
        confirmationPassword,
        obscurePasswords,
        privilege,
        username,
        address,
        phone,
        rut,
        type,
        contact,
      ];
}
