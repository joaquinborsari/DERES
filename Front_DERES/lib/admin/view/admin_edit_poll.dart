import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:topicos/admin/bloc/admin_bloc.dart';
import 'package:topicos/admin/bloc/admin_event.dart';
import 'package:topicos/admin/bloc/admin_state.dart';
import 'package:topicos/admin/model/question.dart';
import 'package:topicos/admin/view/admin_page.dart';
import 'package:topicos/home/view/home_page.dart';

class AdminPollPage extends Page<void> {
  const AdminPollPage({
    super.key,
  });

  static const path = '/admin-poll';

  @override
  Route<void> createRoute(BuildContext context) {
    return MaterialPageRoute(
      fullscreenDialog: true,
      settings: this,
      builder: (context) {
        return BlocListener<AdminBloc, AdminState>(
          listener: (context, state) {
            if (state.status == AdminStatus.pollSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                backgroundColor: Colors.orange,
                content: Text(
                  'Encuesta actualizada con exito',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
              ));
              return context.go(AdminPage.path);
            }
          },
          listenWhen: (previous, current) {
            return previous.status != current.status;
          },
          child: const AdminPollView(),
        );
      },
    );
  }
}

class AdminPollView extends StatelessWidget {
  const AdminPollView({super.key});

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
                'Encuesta',
              ),
            ],
          ),
        ),
        centerTitle: false,
        backgroundColor: Colors.orangeAccent,
      ),
      body: const SingleChildScrollView(
        child: Column(
          children: [
            _EditQuestions(),
            _ContentPoll(),
          ],
        ),
      ),
    );
  }
}

class _ContentPoll extends StatelessWidget {
  const _ContentPoll();

  @override
  Widget build(BuildContext context) {
    final poll = context.select((AdminBloc bloc) => bloc.state.poll);

    return Column(
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height - 20,
          child: ListView.builder(
              itemCount: poll.length,
              shrinkWrap: false,
              itemBuilder: (context, index) {
                switch (poll[index].questionType) {
                  case QuestionType.environmental:
                    return _Environmental(
                      questions: poll[index].questions,
                    );
                  case QuestionType.governance:
                    return _Governance(
                      questions: poll[index].questions,
                    );
                  case QuestionType.social:
                    return _Social(
                      questions: poll[index].questions,
                    );
                  default:
                }
                return null;
              }),
        ),
        const SizedBox(height: 40),
        const _ButtonSend(),
        const SizedBox(height: 40),
      ],
    );
  }
}

class _ButtonSend extends StatelessWidget {
  const _ButtonSend();

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: () {
        context.read<AdminBloc>().add(const AdminQuestionSubmitted());
      },
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: Colors.orangeAccent,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        textStyle: const TextStyle(fontSize: 18),
      ),
      child: const Text('Editar Evaluacion'),
    );
  }
}

class _Governance extends StatelessWidget {
  const _Governance({required this.questions});

  final List<Question> questions;
  @override
  Widget build(BuildContext context) {
    final ponderation =
        context.select((AdminBloc bloc) => bloc.state.calculatePonderation());
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 10, top: 30, bottom: 20),
          child: Text(
            'Evaluación Gobernanza',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ),
        ListView.builder(
          itemCount: questions.length,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return _Checkbox(
              question: questions[index],
              onChanged: () {},
            );
          },
        ),
        const SizedBox(
          height: 20,
        ),
        const Divider(
          color: Colors.orange,
        ),
        Align(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: const EdgeInsets.only(right: 20),
            child: Text(
              '${'Ponderación: ${ponderation![questions.first.type]}'} / 100',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
          ),
        ),
      ],
    );
  }
}

class _Social extends StatelessWidget {
  const _Social({
    required this.questions,
  });

  final List<Question> questions;
  @override
  Widget build(BuildContext context) {
    final ponderation =
        context.select((AdminBloc bloc) => bloc.state.calculatePonderation());
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 10, top: 30, bottom: 20),
          child: Text(
            'Evaluación Social',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ),
        ListView.builder(
          itemCount: questions.length,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return _Checkbox(
              question: questions[index],
              onChanged: () {},
            );
          },
        ),
        const SizedBox(
          height: 20,
        ),
        const Divider(
          color: Colors.orange,
        ),
        Align(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: const EdgeInsets.only(right: 20),
            child: Text(
              '${'Ponderación: ${ponderation![questions.first.type]}'} / 100',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
          ),
        ),
      ],
    );
  }
}

class _Environmental extends StatelessWidget {
  const _Environmental({
    required this.questions,
  });

  final List<Question> questions;
  @override
  Widget build(BuildContext context) {
    final ponderation =
        context.select((AdminBloc bloc) => bloc.state.calculatePonderation());
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 20, top: 30, bottom: 20),
          child: Text(
            'Evaluación Ambiental',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          itemCount: questions.length,
          itemBuilder: (context, index) {
            return _Checkbox(
              question: questions[index],
              onChanged: () {},
            );
          },
        ),
        const SizedBox(
          height: 20,
        ),
        const Divider(
          color: Colors.orange,
        ),
        Align(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: const EdgeInsets.only(right: 20),
            child: Text(
              '${'Ponderación: ${ponderation![questions.first.type]}'} / 100',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
          ),
        ),
      ],
    );
  }
}

class _Checkbox extends StatefulWidget {
  final Question question;
  final VoidCallback onChanged;

  const _Checkbox({
    Key? key,
    required this.question,
    required this.onChanged,
  }) : super(key: key);

  @override
  _CheckboxState createState() => _CheckboxState();
}

class _CheckboxState extends State<_Checkbox> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.question.ponderation);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(widget.question.questionText),
        ),
        SizedBox(
          width: 130,
          child: TextFormField(
            controller: _controller,
            decoration: const InputDecoration(
              labelText: 'Ponderación',
            ),
            onChanged: (value) => widget.onChanged(),
            validator: (value) => value!.isEmpty ? 'Campo obligatorio' : null,
            keyboardType: TextInputType.number,
          ),
        ),
        GestureDetector(
          onTap: () {
            context.read<AdminBloc>().add(AdminEditQuestion(
                questionId: widget.question.id,
                ponderation: _controller.text,
                questionType: widget.question.type));
          },
          child: const Icon(
            Icons.edit,
            size: 20,
          ),
        ),
      ],
    );
  }
}

class _EditQuestions extends StatelessWidget {
  const _EditQuestions();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 10, top: 30, bottom: 20),
              child: Text(
                'Agregar Preguntas',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: TextFormField(
                      decoration:
                          const InputDecoration(labelText: 'Nueva Pregunta'),
                      onChanged: (value) => (context
                          .read<AdminBloc>()
                          .add(AdminQuestionChanged(question: value))),
                      validator: (value) =>
                          value!.isEmpty ? 'Campo obligatorio' : null,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 50,
                ),
                const _DropDownQuestionType(),
                const SizedBox(
                  width: 30,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: GestureDetector(
                    onTap: () {
                      context.read<AdminBloc>().add(const AdminQuestionAdd());
                    },
                    child: const Icon(Icons.add),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 50,
            ),
          ],
        ),
      ),
    );
  }
}

class _DropDownQuestionType extends StatelessWidget {
  const _DropDownQuestionType();

  @override
  Widget build(BuildContext context) {
    final questionType =
        context.select((AdminBloc bloc) => bloc.state.questionType);
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: DropdownButton<QuestionType>(
        value: questionType,
        items: QuestionType.values.map((value) {
          return DropdownMenuItem<QuestionType>(
            value: value,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(value.name),
            ),
          );
        }).toList(),
        onChanged: (QuestionType? newValue) {
          context
              .read<AdminBloc>()
              .add(AdminQuestionTypeChanged(questionType: newValue!));
        },
      ),
    );
  }
}
