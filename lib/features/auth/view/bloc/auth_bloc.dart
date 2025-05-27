import 'package:cryptex/features/auth/repository/auth_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;

  AuthBloc({required this.authRepository}) : super(AuthInitial()) {
    on<SignUp>(_onSignUpRequested);
    on<LogIn>(_onLogInRequested);
  }

  Future<void> _onSignUpRequested(SignUp event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final response = await authRepository.signUp(
        email: event.email,
        password: event.password,
        name: event.name,
      );
      emit(AuthSuccess(response.data));
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }

  Future<void> _onLogInRequested(LogIn event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final response = await authRepository.logIn(
        email: event.email,
        password: event.password,
      );
      emit(AuthSuccess(response.data));
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }
}
