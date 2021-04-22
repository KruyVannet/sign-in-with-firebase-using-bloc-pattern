import 'package:bloc_demo_sign_in/bloc/authentication/authentication_bloc.dart';
import 'package:bloc_demo_sign_in/bloc/authentication/authentication_event.dart';
import 'package:bloc_demo_sign_in/bloc/login/login_bloc.dart';
import 'package:bloc_demo_sign_in/bloc/login/login_state.dart';
import 'package:bloc_demo_sign_in/bloc/login/login_event.dart';
import 'package:bloc_demo_sign_in/repos/email_pass_sign_in.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'sign_up_screen.dart';

import 'bloc/authentication/authentication_bloc.dart';
import 'bloc/login/login_bloc.dart';

class SignInScreen extends StatelessWidget {
  final UserRepository userRepository;

  const SignInScreen({Key key, this.userRepository}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: BlocProvider<LoginBloc>(
        create: (context) => LoginBloc(userRepository: userRepository),
        child: Container(
          child: SingleChildScrollView(
              child: LoginForm(
            userRepository: userRepository,
          )),
        ),
      ),
    );
  }
}

class LoginForm extends StatefulWidget {
  final UserRepository _userRepository;

  const LoginForm({Key key, UserRepository userRepository})
      : _userRepository = userRepository,
        super(key: key);

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool get isPopulated =>
      _emailController.text.isNotEmpty && _passwordController.text.isNotEmpty;

  bool isButtonEnabled(LoginState state) {
    return state.isFormValid && isPopulated && !state.isSubmitting;
  }

  LoginBloc _loginBloc;
  bool hidden=true;

  @override
  void initState() {
    super.initState();
    _loginBloc = BlocProvider.of<LoginBloc>(context);
    _emailController.addListener(_onEmailChange);
    _passwordController.addListener(_onPasswordChange);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state.isFailure) {
          Scaffold.of(context)
            ..removeCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('Login Failure'),
                    Icon(Icons.error),
                  ],
                ),
                backgroundColor: Color(0xffffae88),
              ),
            );
        }

        if (state.isSubmitting) {
          Scaffold.of(context)
            ..removeCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('Logging In...'),
                    CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    )
                  ],
                ),
                backgroundColor: Color(0xffffae88),
              ),
            );
        }

        if (state.isSuccess) {
          BlocProvider.of<AuthenticationBloc>(context).add(
            AuthenticationLoggedIn(),
          );
        }
      },
      child: BlocBuilder<LoginBloc, LoginState>(
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                Image.network(
                  'https://www.gstatic.com/devrel-devsite/prod/va86e410c3836eceeddcebcf4b4d8ca612c34448e39d45400c1d2761bf99aed92/firebase/images/touchicon-180.png',
                  height: 160,
                ),
                SizedBox(height: 20,),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.teal)),
                    hintText: 'Email',
                    labelText: 'Email',

                    prefixIcon: Icon(
                      Icons.email,
                      color: Colors.green,
                    ),
                    prefixText: ' ',
                    suffixStyle: TextStyle(color: Colors.green),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (_) {
                    return !state.isEmailValid ? 'Invalid Email' : null;
                  },
                ),
                SizedBox(height: 20,),
                TextFormField(
                  controller: _passwordController,
                      obscureText: hidden,
                      decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.teal)),
                          hintText: 'Password',
                          labelText: 'Password',
                          prefixIcon: Icon(
                            Icons.lock,
                            color: Colors.green,
                          ),
                          prefixText: ' ',
                          suffixIcon: InkWell(
                            child: Icon(
                              hidden ? Icons.visibility_off : Icons.visibility,
                              color: Colors.green,
                            ),
                            onTap: () {
                              setState(() {
                                hidden = !hidden;
                              });
                            },
                          ),
                          suffixStyle: TextStyle(color: Colors.green)),
                  validator: (_) {
                    return !state.isPasswordValid ? 'Invalid Password' : null;
                  },
                ),
                SizedBox(height: 20,),
                RaisedButton(
                  onPressed: () {
                    if (isButtonEnabled(state)) {
                      _onFormSubmitted();
                    }
                  },
                  color: Colors.blue,
                  child: Text(
                    'Login',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('You don\'t have account yet? ',style: TextStyle(color: Colors.white),),
                    InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) {
                                return RegisterScreen(
                                  userRepository: widget._userRepository,
                                );
                              },
                            ),
                          );
                        },
                        child: Text(
                          'Register',
                          style: TextStyle(
                            color: Colors.blue,
                          ),
                        ))
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onEmailChange() {
    _loginBloc.add(LoginEmailChange(email: _emailController.text));
  }

  void _onPasswordChange() {
    _loginBloc.add(LoginPasswordChange(password: _passwordController.text));
  }

  void _onFormSubmitted() {
    _loginBloc.add(LoginWithCredentialsPressed(
        email: _emailController.text, password: _passwordController.text));
  }
}
