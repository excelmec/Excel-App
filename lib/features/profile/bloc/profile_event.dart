part of 'profile_bloc.dart';

sealed class ProfileEvent {}

class LoadProfileData extends ProfileEvent {}

class LoginProfileRoutine extends ProfileEvent {}

class LogoutProfileRoutine extends ProfileEvent {}
