import 'package:bloc_demo_sign_in/repos/email_pass_sign_in.dart';
import 'package:bloc_demo_sign_in/sign_in_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/authentication/authentication_bloc.dart';
import 'bloc/authentication/authentication_state.dart';
import 'bloc/observer/observer.dart';
import 'home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Bloc.observer = SimpleBlocObserver();
  final UserRepository userRepository = UserRepository();

  runApp(
    BlocProvider(
      create: (context) => AuthenticationBloc(userRepository: userRepository),
      child: MyApp(
        userRepository: userRepository,
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  final UserRepository _userRepository;

  MyApp({UserRepository userRepository}) : _userRepository = userRepository;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: BlocBuilder<AuthenticationBloc,AuthenticationState>(

        builder: (context, state) {

          if (state is AuthenticationFailure) {
            print ("++++++++++++++++++++++++${state.toString()}");
            return  SignInScreen(userRepository: _userRepository,);


          }
          if (state is AuthenticationSuccess) {
            print ("++++++++++++++++++++++++${state.toString()}");
            return HomeScreen(user: state.firebaseUser,);
          }
          print ("++++++++++++++++++++++++${state.toString()}");
          return  SignInScreen(userRepository: _userRepository,);

        },
      ),
    );
  }
}
