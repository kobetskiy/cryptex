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
    on<LogOut>(_onLogOutRequested);
  }

  Future<void> _onSignUpRequested(SignUp event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final userId = await authRepository.signUp(
        email: event.email,
        password: event.password,
        name: event.name,
      );
      emit(AuthSuccess(userId: userId));
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }

  Future<void> _onLogInRequested(LogIn event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final userId = await authRepository.logIn(
        email: event.email,
        password: event.password,
      );
      emit(AuthSuccess(userId: userId));
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }

  Future<void> _onLogOutRequested(LogOut event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await authRepository.logOut();
      emit(AuthLoggedOut());
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }
}