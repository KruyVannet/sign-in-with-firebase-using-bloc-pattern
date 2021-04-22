import 'package:bloc_demo_sign_in/repos/email_pass_sign_in.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'login_event.dart';
import 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final UserRepository _userRepository;

  LoginBloc({UserRepository userRepository})
      : _userRepository = userRepository,
        super(
        LoginState.initial(),
      );

  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    if (event is LoginEmailChange) {
      yield* _mapLoginEmailChangeToState(event.email);
    } else if (event is LoginPasswordChange) {
      yield* _mapLoginPasswordChangeToState(event.password);
    } else if (event is LoginWithCredentialsPressed) {
      yield* _mapLoginWithCredentialsPressedToState(email: event.email,password: event.password);
    }
  }

  Stream <LoginState> _mapLoginEmailChangeToState (String email) async*{
    yield state.update(
      isEmailValid: true,
    );


  }
  Stream<LoginState> _mapLoginPasswordChangeToState(String password) async*{
    yield state.update(
        isPasswordValid: true
    );
  }
  Stream <LoginState> _mapLoginWithCredentialsPressedToState({String email, String password}) async* {
    yield LoginState.loading();
    try{
      await _userRepository.signInWithCredentials(email, password);
      print('================= Login Credentials is Success');
      yield LoginState.success();
    }catch (e){
      print('========= Login Credentials is fail: ${e.toString()}');

      yield LoginState.failure();
    }
  }
}
