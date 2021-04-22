import 'package:bloc_demo_sign_in/bloc/authentication/authentication_bloc.dart';
import 'package:bloc_demo_sign_in/bloc/authentication/authentication_event.dart';
import 'package:bloc_demo_sign_in/bloc/register/register_bloc.dart';
import 'package:bloc_demo_sign_in/bloc/register/register_event.dart';
import 'package:bloc_demo_sign_in/bloc/register/register_state.dart';
import 'package:bloc_demo_sign_in/repos/email_pass_sign_in.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class RegisterScreen extends StatelessWidget {
  final UserRepository _userRepository;

  const RegisterScreen({Key key, UserRepository userRepository})
      : _userRepository = userRepository,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: BlocProvider<RegisterBloc>(
          create: (context) => RegisterBloc(userRepository: _userRepository),
          child:Container(

            child: SingleChildScrollView(child: RegisterForm()),
          )
      ),
    );
  }
}


class RegisterForm extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<RegisterForm> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  bool get isPopulated =>
      _emailController.text.isNotEmpty &&
          _passwordController.text.isNotEmpty ;

  bool isButtonEnabled(RegisterState state) {
    return state.isFormValid && isPopulated && !state.isSubmitting;
  }

  RegisterBloc _registerBloc;
  bool hidden1=true;
  bool hidden=true;

  @override
  void initState() {
    super.initState();
    _registerBloc = BlocProvider.of<RegisterBloc>(context);
    _emailController.addListener(_onEmailChange);
    _passwordController.addListener(_onPasswordChange);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<RegisterBloc, RegisterState>(
      listener: (context, state) {
        if (state.isFailure) {
          Scaffold.of(context)
            ..removeCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('Register Failure'),
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
                    Text('Registering...'),
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
          Scaffold.of(context)
            ..removeCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Text('Sign Up Success'),
                backgroundColor: Colors.green,
              ),
            );
        }
      },
      child: BlocBuilder<RegisterBloc, RegisterState>(
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              child: Column(
                children: <Widget>[
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
                    validator: (value) {
                      if(value.isEmpty){
                        return 'Password Cannot empty';
                      }
                      else
                        return !state.isPasswordValid ? 'Incorrect Password' : null;
                    },
                  ),
                  SizedBox(height: 20,),
                  TextFormField(
                    controller: _confirmPasswordController,
                    obscureText: hidden,
                    decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.teal)),
                        hintText: 'Confirm Password',
                        labelText: 'Confirm Password',
                        prefixIcon: Icon(
                          Icons.lock,
                          color: Colors.green,
                        ),
                        prefixText: ' ',
                        suffixIcon: InkWell(
                          child: Icon(
                            hidden1 ? Icons.visibility_off : Icons.visibility,
                            color: Colors.green,
                          ),
                          onTap: () {
                            setState(() {
                              hidden1 = !hidden1;
                            });
                          },
                        ),
                        suffixStyle: TextStyle(color: Colors.green)),
                    validator: (value) {
                      if(value.isEmpty){
                        return 'Confirm Password cannot be empty';
                      }else if(value.isNotEmpty){
                        if(value!=_passwordController.text)
                        {
                          return "Confirm password doesn't match!";
                        }else{
                          print('null 1');
                          return null;
                        }
                      }else {
                        print('null 2');
                        return null;
                      }

                    },
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  RaisedButton(
                    onPressed: () {
                      if(_confirmPasswordController.text == _passwordController.text) {
                        print('Confirm password correct');
                        if (isButtonEnabled(state)) {
                          _onFormSubmitted();
                        }
                      }else{
                        print('Confirm password Incorrect');
                      }
                      _emailController.text="";
                      _passwordController.text="";
                      _confirmPasswordController.text="";
                    },
                    color: Colors.blue,
                    child: Text(
                      'Register',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _onEmailChange() {
    _registerBloc.add(RegisterEmailChanged(email: _emailController.text));
  }

  void _onPasswordChange() {
    _registerBloc
        .add(RegisterPasswordChanged(password: _passwordController.text));
  }

  void _onFormSubmitted() {
    _registerBloc.add(RegisterSubmitted(
        email: _emailController.text, password: _passwordController.text));
  }

}