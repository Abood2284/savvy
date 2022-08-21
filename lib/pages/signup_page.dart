import 'package:flutter/material.dart';
import 'package:web_chat_app/logger.dart';
import 'package:web_chat_app/widgets/text_field.dart';

class SignupPage extends StatelessWidget {
  const SignupPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const _Stepper();
  }
}

class _Stepper extends StatefulWidget {
  const _Stepper({Key? key}) : super(key: key);

  @override
  State<_Stepper> createState() => _StepperState();
}

class _StepperState extends State<_Stepper> {
  final log = getLogger('_Stepper');
  int _stepperIndex = 0;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  String _name = '';
  String _email = '';
  String _pass = '';

  final List<String> chipData = [];
  bool _isFlutterSelected = false;
  bool _isReactSelected = false;

  getDisposeController() {
    _nameController.dispose();
    _emailController.dispose();
    _passController.dispose();
  }

  @override
  void dispose() {
    getDisposeController();
    super.dispose();
  }

  controlsBuilder() {
    return (BuildContext context, ControlsDetails controlDetails) {
      final isLastStep = _stepperIndex == _getSteps().length - 1;

      return Container(
        margin: const EdgeInsets.only(top: 16),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Row(
          children: <Widget>[
            Expanded(
              child: ElevatedButton(
                onPressed: controlDetails.onStepContinue,
                child: Text(isLastStep ? 'Confirm' : 'Next'),
              ),
            ),
            const SizedBox(width: 16),
            if (_stepperIndex != 0)
              Expanded(
                child: ElevatedButton(
                  onPressed: controlDetails.onStepCancel,
                  child: const Text('Cancel'),
                ),
              ),
          ],
        ),
      );
    };
  }

  @override
  Widget build(BuildContext context) {
    return Stepper(
      type: StepperType.horizontal,
      currentStep: _stepperIndex,
      onStepTapped: (step) => setState(() {
        _stepperIndex = step;
      }),
      controlsBuilder: controlsBuilder(),
      onStepContinue: () {
        final isLastStep = _stepperIndex == _getSteps().length - 1;
        if (isLastStep) {
          log.d('Completed');

          // Send data to the server
        } else {
          setState(() {
            _stepperIndex += 1;
          });
        }
      },
      onStepCancel: _stepperIndex == 0
          ? null
          : () => setState(() {
                _stepperIndex -= 1;
              }),
      steps: _getSteps(),
    );
  }

  List<Step> _getSteps() {
    return <Step>[
      Step(
        state: _stepperIndex > 0 ? StepState.complete : StepState.indexed,
        isActive: _stepperIndex >= 0,
        title: const Text('Personal'),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TextFieldBuilder(
              labelText: 'Name',
              controller: _nameController,
              icon: Icons.person,
              onChanged: (value) {
                _name = value;
                log.d(_name);
              },
            ),
            const SizedBox(
              height: 22,
            ),
            TextFieldBuilder(
              labelText: 'Email',
              controller: _emailController,
              icon: Icons.mail_outline,
              onChanged: (value) {
                _email = value;
                log.d(_email);
              },
            ),
            const SizedBox(
              height: 22,
            ),
            TextFieldBuilder(
              labelText: 'Password',
              controller: _passController,
              icon: Icons.lock,
              onChanged: (value) {
                _pass = value;
                log.d(_pass);
              },
            ),
          ],
        ),
      ),
      Step(
        state: _stepperIndex > 1 ? StepState.complete : StepState.indexed,
        isActive: _stepperIndex >= 1,
        title: const Text('Intrests'),
        content: Column(
          children: [
            InputChip(
              label: const Text('Flutter'),
              selected: _isFlutterSelected,
              onSelected: (selected) {
                if (selected) {
                  chipData.add('Flutter');
                  log.d(chipData.length);
                  setState(() {
                    _isFlutterSelected = true;
                  });
                } else {
                  chipData.remove('Flutter');
                  setState(() {
                    _isFlutterSelected = false;
                  });
                }
                log.i(chipData.length);
              },
            ),
            InputChip(
              label: const Text('React'),
              selected: _isReactSelected,
              onSelected: (selected) {
                if (selected) {
                  chipData.add('React');
                  setState(() {
                    _isReactSelected = true;
                  });
                } else {
                  chipData.remove('React');
                  setState(() {
                    _isReactSelected = false;
                  });
                }
                log.i(chipData.length);
              },
            ),
          ],
        ),
      ),
      Step(
        state: _stepperIndex > 2 ? StepState.complete : StepState.indexed,
        isActive: _stepperIndex >= 2,
        title: const Text('Complete'),
        content: Column(
          children: [
            Text('Name: $_name'),
            Text('Email: $_email'),
            Text('Password: $_pass'),
            Text('Interests: ${chipData.length}'),
          ],
        ),
      ),
    ];
  }
}
