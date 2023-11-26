import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:topicos/admin/view/admin_edit_poll.dart';
import 'package:topicos/home/view/home_page.dart';

class AdminView extends StatelessWidget {
  const AdminView({super.key});

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
                'Administrador',
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
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width / 2,
                  height: MediaQuery.of(context).size.height,
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    border: Border.all(color: Colors.white, width: 3),
                    image: const DecorationImage(
                        image: AssetImage('lib/assets/company_page.png'),
                        fit: BoxFit.fitHeight,
                        scale: 2),
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      const Text(
                        'Bienvenido a Nuestra Web',
                        style: TextStyle(
                            fontSize: 30, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      const Text(
                        'Aquí puede editar la encuesta para los proveedores',
                        style: TextStyle(fontSize: 15),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      OutlinedButton(
                        onPressed: () => {
                          context.go(
                            AdminPollPage.path,
                          )
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.orangeAccent,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 15),
                          textStyle: const TextStyle(fontSize: 18),
                        ),
                        child: const Text('Editar Encuesta'),
                      ),
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
