import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:topicos/company/bloc/company_bloc.dart';
import 'package:topicos/company/bloc/company_state.dart';
import 'package:topicos/company/view/company_poll.dart';
import 'package:topicos/home/view/home_page.dart';

class CompanyView extends StatelessWidget {
  const CompanyView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                'Proveedor',
              ),
            ],
          ),
        ),
        centerTitle: false,
        backgroundColor: Colors.orangeAccent,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              child: Text(
                'Bienvenido a Nuestra Web',
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
            ),
            BlocBuilder<CompanyBloc, CompanyState>(
              buildWhen: (previous, current) {
                return previous.companyData != current.companyData;
              },
              builder: (context, state) {
                return const _DataCompany();
              },
            )
          ],
        ),
      ),
    );
  }
}

class _DataCompany extends StatelessWidget {
  const _DataCompany();

  @override
  Widget build(BuildContext context) {
    final companyData =
        context.select((CompanyBloc bloc) => bloc.state.companyData);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width / 2,
          height: MediaQuery.of(context).size.height,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  'Datos de la Empresa ',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: TextFormField(
                  initialValue: companyData.name,
                  decoration: const InputDecoration(labelText: 'Nombre'),
                  onChanged: (value) => (),
                  validator: (value) =>
                      value!.isEmpty ? 'Campo obligatorio' : null,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: TextFormField(
                  initialValue: companyData.rut,
                  decoration: const InputDecoration(labelText: 'Razón Social'),
                  onChanged: (value) => (),
                  validator: (value) =>
                      value!.isEmpty ? 'Campo obligatorio' : null,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: TextFormField(
                  initialValue: companyData.address,
                  decoration: const InputDecoration(labelText: 'Dirección'),
                  onChanged: (value) => (),
                  validator: (value) =>
                      value!.isEmpty ? 'Campo obligatorio' : null,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: TextFormField(
                  initialValue: companyData.phone,
                  decoration: const InputDecoration(labelText: 'Teléfono'),
                  onChanged: (value) => (),
                  validator: (value) =>
                      value!.isEmpty ? 'Campo obligatorio' : null,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: TextFormField(
                  initialValue: companyData.email,
                  decoration:
                      const InputDecoration(labelText: 'Email de Contacto'),
                  onChanged: (value) => (),
                  validator: (value) =>
                      value!.isEmpty ? 'Campo obligatorio' : null,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: TextFormField(
                  initialValue: companyData.phone,
                  decoration:
                      const InputDecoration(labelText: 'Persona de Contacto'),
                  onChanged: (value) => (),
                  validator: (value) =>
                      value!.isEmpty ? 'Campo obligatorio' : null,
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              const Divider(
                height: 2,
                color: Colors.orange,
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: Text(
                  'Puntaje Total',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ),
              CircleAvatar(
                backgroundColor: Colors.orange,
                radius: 35,
                child: Text(
                  companyData.score,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Column(
            children: [
              const Text(
                '¿Quiere realizar la encuesta?',
                style: TextStyle(fontSize: 20),
              ),
              const SizedBox(
                height: 30,
              ),
              OutlinedButton(
                onPressed: () => {
                  context.go(
                    CompanyPollPage.path,
                    //extra: context.read<CompanyBloc>()
                  )
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.orangeAccent,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  textStyle: const TextStyle(fontSize: 18),
                ),
                child: const Text('Comenzar'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
