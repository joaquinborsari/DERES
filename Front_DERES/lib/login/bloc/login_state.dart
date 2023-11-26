part of 'login_bloc.dart';

enum LoginStatus { initial, submitting, success, failure }

@immutable
class LoginState extends Equatable {
  const LoginState({
    required this.email,
    required this.password,
    required this.status,
    required this.obscurePassword,
    required this.privilage,
    required this.loginStatus,
  });

  const LoginState.initial()
      : this(
          email: const Email.pure(),
          password: const Password.pure(),
          status: FormzSubmissionStatus.initial,
          obscurePassword: true,
          privilage: Privilege.undefined,
          loginStatus: LoginStatus.initial,
        );

  final Email email;
  final Password password;
  final FormzSubmissionStatus status;
  final bool obscurePassword;
  final Privilege privilage;
  final LoginStatus loginStatus;

  @override
  List<Object?> get props =>
      [email, password, status, obscurePassword, privilage];

  LoginState copyWith({
    Email? email,
    Password? password,
    FormzSubmissionStatus? status,
    bool? obscurePassword,
    Privilege? privilege,
    LoginStatus? loginStatus,
  }) {
    return LoginState(
        email: email ?? this.email,
        password: password ?? this.password,
        status: status ?? this.status,
        obscurePassword: obscurePassword ?? this.obscurePassword,
        privilage: privilege ?? privilage,
        loginStatus: loginStatus ?? this.loginStatus);
  }
}
