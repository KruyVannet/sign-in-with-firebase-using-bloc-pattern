import 'package:bloc_demo_sign_in/bloc/authentication/authentication_event.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/authentication/authentication_bloc.dart';

class HomeScreen extends StatefulWidget {

  final User user;

  const HomeScreen({Key key, this.user}) : super(key: key);
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(actions: [IconButton(icon: Icon(Icons.clear), onPressed: (){
        BlocProvider.of<AuthenticationBloc>(context)
            .add(AuthenticationLoggedOut());
      })],),
      backgroundColor: Colors.teal,
      body: SafeArea(
        child: Column(
          children: [
            Flexible(
              flex: 1,
              child: Image.network(
                'https://www.gstatic.com/devrel-devsite/prod/va86e410c3836eceeddcebcf4b4d8ca612c34448e39d45400c1d2761bf99aed92/firebase/images/touchicon-180.png',
                height: 160,
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Center(child: Text("Your Logging in Is Succeed",style: TextStyle(fontSize: 20,color: Colors.orange),))
          ],
        ),
      ),
    );
  }
}
