import 'package:bloc_demo_sign_in/repos/email_pass_sign_in.dart';
import 'package:bloc_demo_sign_in/utils/validator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'register_event.dart';
import 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final UserRepository _userRepository;

  RegisterBloc({UserRepository userRepository})
      : _userRepository = userRepository,
        super(RegisterState.initial());

  @override
  Stream<RegisterState> mapEventToState(RegisterEvent event) async* {
    if (event is RegisterEmailChanged) {
      yield* _mapRegisterEmailChangeToState(event.email);
    } else if (event is RegisterPasswordChanged) {
      yield* _mapRegisterPasswordChangeToState(event.password);
    } else if (event is RegisterSubmitted) {
      yield* _mapRegisterSubmittedToState(
          email: event.email, password: event.password);
    }
  }

  Stream<RegisterState> _mapRegisterEmailChangeToState(String email) async* {
    //yield state.update(isEmailValid: Validators.isValidEmail(email));
    yield state.update(isEmailValid: true);
  }

  Stream<RegisterState> _mapRegisterPasswordChangeToState(String password) async* {
    //yield state.update(isPasswordValid: Validators.isValidPassword(password));
    yield state.update(isPasswordValid: true);
  }


  Stream<RegisterState> _mapRegisterSubmittedToState(

      {String email, String password}) async* {
    yield RegisterState.loading();
    try {
      await _userRepository.signUp(email, password);
      print('=======================User has SignUp');
      yield RegisterState.success();
    } catch (error) {
      print("=======================SignUp has error in mapRegisterSubmittedToState :${error}");
      yield RegisterState.failure();
    }
  }
}