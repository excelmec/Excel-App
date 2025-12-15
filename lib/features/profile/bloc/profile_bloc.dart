import 'dart:async';

import 'package:excelapp2025/core/api/routes/api_routes.dart';
import 'package:excelapp2025/core/api/services/api_service.dart';
import 'package:excelapp2025/core/api/services/auth_service.dart';
import 'package:excelapp2025/features/profile/data/models/profile_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc() : super(ProfileInitial()) {
    on<LoadProfileData>(_onLoadProfileData);
    on<LoginProfileRoutine>(_onLoginProfileRoutine);
  }

  void _onLoadProfileData(
    LoadProfileData event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileLoading());
    late String token;
    try {
      token = await AuthService.getToken();
    } catch (e) {
      emit(ProfileSignedOut());
      return;
    }
    try {
      final response = await ApiService.get(
        ApiRoutes.profile,
        headers: ApiService.authHeaders(token),
        baseUrl: ApiService.accountsBaseUrl,
      );
      print("Profile Data: $response");
      final profileModel = ProfileModel.fromJson(response);

      emit(ProfileLoaded(profileModel));
    } catch (e) {
      emit(ProfileError('Failed to load profile data $e'));
    }
  }

  void _onLoginProfileRoutine(
    LoginProfileRoutine event,
    Emitter<ProfileState> emit,
  ) async {
    emit(LoginStartedState());
    try {
      await AuthService.login();
      emit(ProfileSignedIn());
    } catch (e) {
      emit(ProfileError('Login routine failed'));
    }
  }
}
