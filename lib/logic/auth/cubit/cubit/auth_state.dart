part of 'auth_cubit.dart';


sealed class AuthState {}

final class AuthInitial extends AuthState {}

final class AuthLoading extends AuthState {}

final class AuthSuccess extends AuthState {
  final String message;
  AuthSuccess({this.message = "تمت العملية بنجاح"});
}

final class AuthFailure extends AuthState {
  final String errMessage;
  AuthFailure({required this.errMessage});
}
