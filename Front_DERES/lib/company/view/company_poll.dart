import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:topicos/admin/bloc/admin_state.dart';
import 'package:topicos/admin/model/question.dart';
import 'package:topicos/company/bloc/company_bloc.dart';
import 'package:topicos/company/bloc/company_event.dart';
import 'package:topicos/company/bloc/company_state.dart';
import 'package:topicos/company/view/company_page.dart';
import 'package:topicos/home/view/home_page.dart';

class CompanyPollPage extends Page<void> {
  const CompanyPollPage({
    super.key,
  });

  static const path = '/company-poll';

  @override
  Route<void> createRoute(BuildContext context) {
    return MaterialPageRoute(
      fullscreenDialog: true,
      settings: this,
      builder: (context) {
        return BlocListener<CompanyBloc, CompanyState>(
          listener: (context, state) {
            if (state.status == CompanyStatus.pollSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                backgroundColor: Colors.orange,
                content: Text(
                  'Encuesta realizada con exito',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
              ));
              return context.go(CompanyPage.path);
            }
          },
          child: const CompanyPollView(),
        );
      },
    );
  }
}

class CompanyPollView extends StatelessWidget {
  const CompanyPollView({super.key});

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
      body: const _ContentPoll(),
    );
  }
}

class _ContentPoll extends StatelessWidget {
  const _ContentPoll();

  @override
  Widget build(BuildContext context) {
    final poll = context.select((CompanyBloc bloc) => bloc.state.poll);
    return SingleChildScrollView(
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 10, top: 30, bottom: 20),
            child: Text(
              'Encuesta para Proveedores ',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
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
          const _ButtonSend(),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}

class _ButtonSend extends StatelessWidget {
  const _ButtonSend();

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: () =>
          (context.read<CompanyBloc>().add(const CompanyQuestionSubmitted())),
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: Colors.orangeAccent,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        textStyle: const TextStyle(fontSize: 18),
      ),
      child: const Text('Enviar Evaluacion'),
    );
  }
}

class _Governance extends StatelessWidget {
  const _Governance({required this.questions});

  final List<Question> questions;
  @override
  Widget build(BuildContext context) {
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
            );
          },
        ),
        const SizedBox(
          height: 20,
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
            );
          },
        ),
        const SizedBox(
          height: 20,
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
            );
          },
        ),
        const SizedBox(
          height: 20,
        ),
      ],
    );
  }
}

class _Checkbox extends StatelessWidget {
  const _Checkbox({
    required this.question,
  });

  final Question question;

  @override
  Widget build(BuildContext context) {
    final selectedQuestion =
        context.select((CompanyBloc bloc) => bloc.state.selectedQuestions);
    return CheckboxListTile(
        title: Text(question.questionText),
        value: selectedQuestion[question.id.toString()],
        onChanged: ((value) {
          context.read<CompanyBloc>().add(CompanyQuestionChanged(
              id: question.id, selectedQuestion: value ?? false));
        }));
  }
}
