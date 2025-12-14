part of 'profile_bloc.dart';

sealed class ProfileState {}

class ProfileInitial extends ProfileState {}

class ProfileSignedOut extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final ProfileModel profileModel;
  ProfileLoaded(this.profileModel);
}

class ProfileError extends ProfileState {
  final String message;
  ProfileError(this.message);
}

class LoginStartedState extends ProfileState {}
