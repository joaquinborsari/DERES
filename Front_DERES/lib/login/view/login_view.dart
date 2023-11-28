import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:go_router/go_router.dart';
import 'package:topicos/admin/view/admin_page.dart';
import 'package:topicos/company/view/company_page.dart';
import 'package:topicos/extensions/privilege.dart';
import 'package:topicos/login/login.dart';
import 'package:topicos/supplier/supplier.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        switch (state.privilage) {
          case Privilege.admin:
            context.go(AdminPage.path);
            break;
          case Privilege.provider:
            context.go(CompanyPage.path);
            break;
          case Privilege.user:
            context.go(SupplierPage.path);
            break;
          default:
        }
      },
      listenWhen: (previous, current) {
        return previous.privilage != current.privilage;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              Container(
                width: 40.0,
                height: 40.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 3),
                  image: const DecorationImage(
                      image: AssetImage('lib/assets/deres.png'),
                      fit: BoxFit.cover,
                      scale: 2),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              const Text(
                'Iniciar sesión',
              ),
            ],
          ),
          centerTitle: false,
          backgroundColor: Colors.orangeAccent,
        ),
        body: Center(
          child: Container(
            width: 800,
            height: 300,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  offset: Offset(0, 2),
                  blurRadius: 6,
                ),
              ],
            ),
            child: BlocListener<LoginBloc, LoginState>(
              listenWhen: (previous, current) =>
                  previous.status != current.status,
              listener: (context, state) {
                if (state.status.isSuccess) {
                  ScaffoldMessenger.of(context)
                    ..hideCurrentSnackBar()
                    ..showSnackBar(
                      const SnackBar(content: Text('Ingreso exitoso')),
                    );
                  if (context.canPop()) {
                    context.pop();
                  } else {
                    // context.go(HomePage.path);
                  }
                } else if (state.status.isFailure) {
                  ScaffoldMessenger.of(context)
                    ..hideCurrentSnackBar()
                    ..showSnackBar(
                      const SnackBar(content: Text('Algo salió mal')),
                    );
                }
              },
              child: const Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  EmailTextField(),
                  SizedBox(height: 16),
                  PasswordTextField(),
                  SizedBox(height: 32),
                  LoginButton(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class EmailTextField extends StatelessWidget {
  const EmailTextField({super.key});

  @override
  Widget build(BuildContext context) {
    final valid = context.select((LoginBloc bloc) {
      final email = bloc.state.email;
      return email.isValid || email.isPure;
    });

    return TextField(
      onChanged: (value) =>
          context.read<LoginBloc>().add(LoginEmailChanged(value)),
      decoration: const InputDecoration(
        hintText: 'Email',
      ),
      keyboardType: TextInputType.emailAddress,
    );
  }
}

class PasswordTextField extends StatelessWidget {
  const PasswordTextField({super.key});

  @override
  Widget build(BuildContext context) {
    final obscurePassword =
        context.select((LoginBloc bloc) => bloc.obscurePassowrd);

    return TextField(
      autocorrect: false,
      keyboardType: TextInputType.visiblePassword,
      onChanged: (value) =>
          context.read<LoginBloc>().add(LoginPasswordChanged(value)),
      decoration: InputDecoration(
        hintText: 'Password',
        suffixIcon: IconButton(
          icon: Icon(obscurePassword ? Icons.visibility : Icons.visibility_off),
          onPressed: () {
            context
                .read<LoginBloc>()
                .add(LoginPasswordVisibilityChanged(obscure: !obscurePassword));
          },
        ),
      ),
      enableIMEPersonalizedLearning: false,
      obscureText: obscurePassword,
    );
  }
}

class LoginButton extends StatelessWidget {
  const LoginButton({super.key});

  @override
  Widget build(BuildContext context) {
    final validToSubmit = context.select((LoginBloc bloc) => bloc.valid);

    return OutlinedButton(
      onPressed: validToSubmit
          ? () {
              context
                  .read<LoginBloc>()
                  .add(const LoginWithEmailAndPasswordRequested());
            }
          : null,
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: Colors.orangeAccent,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        textStyle: const TextStyle(fontSize: 18),
      ),
      child: const Text('Ingresar'),
    );
  }
}
