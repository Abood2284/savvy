/*
! NO LONGER USED -> DEPRECATED BY @Abood2284 on 2 Nov 2022
! DELETEING PERMISSION GRANTED
! KEPT FOR CODE REFERENCE ONLY
*/

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase;
import 'package:flutter/material.dart';
import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart';
import 'package:web_chat_app/constants.dart';
import 'package:web_chat_app/logger.dart';
import 'package:web_chat_app/models/models.dart';
import 'package:web_chat_app/models/user_model.dart';
import 'package:web_chat_app/screens/screens.dart';
import 'package:web_chat_app/widgets/text_field.dart';

import '../auth.dart';
import '../theme.dart';

class SignupPage extends StatelessWidget {
  const SignupPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Padding(
          padding: EdgeInsets.only(left: 16),
          child: Text(
            'Create Account',
            style: TextStyle(
              fontSize: 28,
              color: AppTheme.accentColor,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 16),
          child: Text(
            'Sign up to get started!',
            style: TextStyle(
              color: AppColors.textFaded,
              fontSize: 20,
            ),
          ),
        ),
        SizedBox(height: 16),
        Expanded(
          child: Card(color: AppColors.cardDark, child: _Stepper()),
        ),
      ],
    );
  }
}

class _Stepper extends StatefulWidget {
  const _Stepper({Key? key}) : super(key: key);

  @override
  State<_Stepper> createState() => _StepperState();
}

class _StepperState extends State<_Stepper> {
  final log = getLogger('_Stepper');
  final Auth _auth = Auth();
  final _formKey = GlobalKey<FormState>();
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  final ValueNotifier<bool> _isLoading = ValueNotifier(false);

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  final List<String> chipData = [];

  int _stepperIndex = 0;

  String _name = '';
  String _email = '';
  String _pass = '';

  bool _isFlutterSelected = false;
  bool _isReactSelected = false;
  // Used to validate the password field.
  bool isPasswordValid(String password) => password.length >= 6;
  // Used to validate the email field.
  bool isEmailValid(String email) {
    return REGEXP_EMAIL_VALIDATION.hasMatch(email);
  }

  // * ISSUE: #1
  void onSignupButtonPressed() async {
    _isLoading.value = true;
    if (_formKey.currentState!.validate()) {
      firebase.UserCredential currentUser = await _auth
          .signUpWithEmailAndPassword(email: _email, password: _pass);
      addUserMeta(currentUser).then((_) {
        _isLoading.value = false;
      });

      try {
        StreamChatCore.of(context).client.connectUser(
              User(
                id: currentUser.user!.uid,
                extraData: {
                  'name': _name,
                  'image': currentUser.user!.photoURL,
                },
              ),
              currentUser.user!.uid,
            );
      } on Exception catch (e) {
        log.e('Could not connect the user', e);
        _isLoading.value = false;
      }

      if (!mounted) return;
      Navigator.of(context).pushNamedAndRemoveUntil(
          HomeScreen.routeName, (route) => false,
          arguments: currentUser);
    }
  }

  List<Map> _listOfCommunityDataToMapConverter(List<CommunityModel>? list) {
    List<Map> maps = [];
    for (var element in list ?? []) {
      maps.add(element.toMap());
    }
    return maps;
  }

  List<CommunityModel> createCommunityDataObject() {
    List<CommunityModel> communityData = [];
    if (_isFlutterSelected) {
      CommunityModel flutter = CommunityModel(
        id: 'flutter',
        name: 'Flutter',
        members: const [],
        profilePicture:
            'https://pixabay.com/get/ga243a4148df10b0a37c9727431e916183f8e2dc11135d1004868c9172b111504c2b5360e16287035844bf47d38aa7b9ba31da329b13d8cb33e2e6ca41e01eb5c_1920.jpg',
        latestMessage: 'Welcome to Flutter Community',
      );
      communityData.add(flutter);
    }
    if (_isReactSelected) {
      CommunityModel react = CommunityModel(
        id: 'react',
        name: 'React',
        members: const [],
        profilePicture:
            'https://pixabay.com/get/ga243a4148df10b0a37c9727431e916183f8e2dc11135d1004868c9172b111504c2b5360e16287035844bf47d38aa7b9ba31da329b13d8cb33e2e6ca41e01eb5c_1920.jpg',
        latestMessage: 'Welcome to React Community',
      );
      communityData.add(react);
    }
    return communityData;
  }

  Future<void> addUserMeta(firebase.UserCredential user) async {
    List<CommunityModel> communityData = createCommunityDataObject();
    final userModelObject =
        UserModel(uid: user.user!.uid, name: _name, communityID: communityData);
    final mapOfCommunityData =
        _listOfCommunityDataToMapConverter(userModelObject.communityID);

    CollectionReference userCollection = firestore.collection('users');
    userCollection
        .doc(user.user!.uid)
        .set({
          'name': userModelObject.name,
          'email': _email,
          'communityID': mapOfCommunityData
        })
        .then((value) => log.d('User Added'))
        .catchError((error) {
          log.e('Error: $error');
        });
  }

  controlsBuilder() {
    return (BuildContext context, ControlsDetails controlDetails) {
      final isLastStep = _stepperIndex == _getSteps().length - 1;

      return Container(
        margin: const EdgeInsets.only(top: 16),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: ValueListenableBuilder(
          valueListenable: _isLoading,
          builder: (BuildContext context, bool isLoadingTrue, Widget? child) {
            return isLoadingTrue
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : Row(
                    children: <Widget>[
                      Expanded(
                        child: ElevatedButton(
                          onPressed: controlDetails.onStepContinue,
                          child: Text(isLastStep ? 'Signup' : 'Next'),
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
                  );
          },
        ),
      );
    };
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stepper(
      elevation: 0,
      type: StepperType.horizontal,
      currentStep: _stepperIndex,
      onStepTapped: (step) => setState(() {
        _stepperIndex = step;
      }),
      controlsBuilder: controlsBuilder(),
      onStepContinue: () {
        final isLastStep = _stepperIndex == _getSteps().length - 1;
        if (isLastStep) {
          onSignupButtonPressed();
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
        content: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextFieldBuilder(
                labelText: 'Name',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
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
                validator: (value) {
                  if (!isEmailValid(value!)) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
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
                validator: (value) {
                  if (!isPasswordValid(value!)) {
                    return 'Please enter a valid password';
                  }
                  return null;
                },
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
