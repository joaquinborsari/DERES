import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:go_router/go_router.dart';
import 'package:topicos/admin/view/admin_page.dart';
import 'package:topicos/company/view/company_page.dart';
import 'package:topicos/extensions/privilege.dart';
import 'package:topicos/home/view/home_page.dart';
import 'package:topicos/sign_in/sign_in.dart';
import 'package:topicos/supplier/supplier.dart';

class SignInView extends StatelessWidget {
  const SignInView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<SignInBloc, SignInState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (context, state) {
        if (state.status.isSuccess) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              const SnackBar(content: Text('Account registered successfully')),
            );
          if (context.canPop()) {
            context.pop();
          } else {
            //context.go(HomePage.path);
          }
        } else if (state.status.isFailure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              const SnackBar(content: Text('Something went wrong')),
            );
        }
        switch (state.privilege) {
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
      child: Scaffold(
        appBar: AppBar(
          title: GestureDetector(
            onTap: () {
              context.go(HomePage.path);
            },
            child: Row(
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
                  'Registrarse',
                ),
              ],
            ),
          ),
          centerTitle: false,
          backgroundColor: Colors.orangeAccent,
        ),
        body: Center(
          child: Container(
            width: 800,
            height: 400,
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
            child: const Column(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    EmailTextField(),
                    SizedBox(height: 16),
                    PasswordTextField(),
                    SizedBox(height: 16),
                    ConfirmationPasswordTextField(),
                    SizedBox(height: 32),
                    Text(
                      "Tipo de Usuario",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    _TypeUser(),
                    SizedBox(height: 40),
                  ],
                ),
                SignInButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TypeUser extends StatelessWidget {
  const _TypeUser();

  @override
  Widget build(BuildContext context) {
    final typeUser = context.select((SignInBloc bloc) => bloc.state.privilege);
    return Row(
      children: [
        Expanded(
          child: CheckboxListTile(
              title: const Text("Usuario"),
              value: typeUser == Privilege.user,
              onChanged: ((value) {
                context.read<SignInBloc>().add(
                    const SignInPrivilageChanged(privilage: Privilege.user));
              })),
        ),
        const SizedBox(width: 32),
        Expanded(
          child: CheckboxListTile(
              title: const Text("Proveedor"),
              value: typeUser == Privilege.provider,
              onChanged: ((value) {
                context.read<SignInBloc>().add(const SignInPrivilageChanged(
                    privilage: Privilege.provider));
              })),
        ),
      ],
    );
  }
}

class EmailTextField extends StatelessWidget {
  const EmailTextField({super.key});

  @override
  Widget build(BuildContext context) {
    final valid = context.select((SignInBloc bloc) => bloc.emailIsValid);

    return TextField(
      onChanged: (value) =>
          context.read<SignInBloc>().add(SignInEmailChanged(value)),
      decoration: InputDecoration(
        hintText: 'Email',
        errorText: valid ? null : 'Please enter a valid email',
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
        context.select((SignInBloc bloc) => bloc.obscurePassowrds);

    final valid = context.select((SignInBloc bloc) => bloc.passwordIsValid);

    return TextField(
      autocorrect: false,
      keyboardType: TextInputType.visiblePassword,
      onChanged: (value) =>
          context.read<SignInBloc>().add(SignInPasswordChanged(value)),
      decoration: InputDecoration(
        hintText: 'Password',
        errorText: valid ? null : 'Password must be at least 6 characters long',
        suffixIcon: IconButton(
          icon: Icon(obscurePassword ? Icons.visibility : Icons.visibility_off),
          onPressed: () {
            context.read<SignInBloc>().add(
                  SignInPasswordVisibilityChanged(obscure: !obscurePassword),
                );
          },
        ),
      ),
      enableIMEPersonalizedLearning: false,
      obscureText: obscurePassword,
    );
  }
}

class ConfirmationPasswordTextField extends StatelessWidget {
  const ConfirmationPasswordTextField({super.key});

  @override
  Widget build(BuildContext context) {
    final obscurePassword =
        context.select((SignInBloc bloc) => bloc.obscurePassowrds);

    final valid = context.select((SignInBloc bloc) => bloc.passwordsMatch);

    return TextField(
      autocorrect: false,
      keyboardType: TextInputType.visiblePassword,
      onChanged: (value) => context.read<SignInBloc>().add(
            SignInConfirmationPasswordChanged(value),
          ),
      decoration: InputDecoration(
        hintText: 'Password confirmation',
        errorText: valid ? null : 'Passwords do not match',
        suffixIcon: IconButton(
          icon: Icon(obscurePassword ? Icons.visibility : Icons.visibility_off),
          onPressed: () {
            context.read<SignInBloc>().add(
                  SignInPasswordVisibilityChanged(obscure: !obscurePassword),
                );
          },
        ),
      ),
      enableIMEPersonalizedLearning: false,
      obscureText: obscurePassword,
    );
  }
}

class SignInButton extends StatelessWidget {
  const SignInButton({super.key});

  @override
  Widget build(BuildContext context) {
    final validToSubmit = context.select((SignInBloc bloc) => bloc.valid);

    return OutlinedButton(
      onPressed: () {
        validToSubmit
            ? () {
                context
                    .read<SignInBloc>()
                    .add(const SignInWithEmailAndPasswordRequested());
              }
            : null;
      },
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: Colors.orangeAccent,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        textStyle: const TextStyle(fontSize: 18),
      ),
      child: const Text('Registrarse'),
    );
  }
}
