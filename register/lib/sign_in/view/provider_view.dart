import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:register/sign_in/sign_in.dart';

class ProviderPage extends Page<void> {
  const ProviderPage();

  static const path = '/provider';

  @override
  Route<void> createRoute(BuildContext context) {
    return MaterialPageRoute(
      settings: this,
      builder: (context) {
        return const ProviderView();
      },
    );
  }
}

class ProviderView extends StatelessWidget {
  const ProviderView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: GestureDetector(
          onTap: () {},
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
                'Ingrese los Datos',
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
          height: 800,
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    onChanged: (value) {
                      context
                          .read<SignInBloc>()
                          .add(SignInUserNameChanged(value));
                    },
                    decoration: const InputDecoration(
                      hintText: 'Nombre',
                    ),
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    onChanged: (value) {
                      context.read<SignInBloc>().add(SignInTypeChanged(value));
                    },
                    decoration: const InputDecoration(
                      hintText: 'Tipo de Empresa',
                    ),
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    onChanged: (value) {
                      context
                          .read<SignInBloc>()
                          .add(SignInContactsChanged(value));
                    },
                    decoration: const InputDecoration(
                      hintText: 'Persona de Contacto',
                    ),
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 32),
                  TextField(
                    onChanged: (value) {
                      context.read<SignInBloc>().add(SignInPhoneChanged(value));
                    },
                    decoration: const InputDecoration(
                      hintText: 'Telefono de Contacto',
                    ),
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 32),
                  TextField(
                    onChanged: (value) {
                      context
                          .read<SignInBloc>()
                          .add(SignInAddressChanged(value));
                    },
                    decoration: const InputDecoration(
                      hintText: 'Dirección',
                    ),
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 32),
                  TextField(
                    onChanged: (value) {
                      context.read<SignInBloc>().add(SignInRutChanged(value));
                    },
                    decoration: const InputDecoration(
                      hintText: 'Rut',
                    ),
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 40),
                ],
              ),
              const _RegisterButton(),
            ],
          ),
        ),
      ),
    );
  }
}

class _RegisterButton extends StatelessWidget {
  const _RegisterButton();

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: () {
        context.read<SignInBloc>().add(const SignInDataChanged());
      },
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: Colors.orangeAccent,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        textStyle: const TextStyle(fontSize: 18),
      ),
      child: const Text('Finalizar'),
    );
  }
}
