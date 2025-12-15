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
    on<LogoutProfileRoutine>(_onLogoutProfileRoutine);
  }

  Future<void> _onLoadProfileData(
    LoadProfileData event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileLoading());
    try {
      String token = await AuthService.getToken();
      if (token == '') {
        emit(ProfileSignedOut());
        return;
      }
      final response = await ApiService.get(
        ApiRoutes.profile,
        headers: ApiService.authHeaders(token),
        baseUrl: ApiService.accountsBaseUrl,
      );
      final profileModel = ProfileModel.fromJson(response);
      emit(ProfileLoaded(profileModel));
    } catch (e) {
      emit(ProfileError('Failed to load profile data $e'));
    }
  }

  Future<void> _onLoginProfileRoutine(
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

  Future<void> _onLogoutProfileRoutine(
    LogoutProfileRoutine event,
    Emitter<ProfileState> emit,
  ) async {
    emit(LogoutStartedState());
    print('Logout routine started');
    try {
      await AuthService.logout();
      emit(ProfileSignedOut());
    } catch (e) {
      emit(ProfileError('Logout routine failed'));
    }
  }
}
