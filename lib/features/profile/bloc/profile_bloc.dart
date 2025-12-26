import 'dart:async';

import 'package:excelapp2025/core/api/routes/api_routes.dart';
import 'package:excelapp2025/core/api/services/api_service.dart';
import 'package:excelapp2025/core/api/services/auth_service.dart';
import 'package:excelapp2025/features/discover/data/models/event_model.dart';
import 'package:excelapp2025/features/profile/data/models/profile_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/repository/fetch_reg_events.dart';

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
      dynamic response = await ApiService.get(
        ApiRoutes.profile,
        headers: ApiService.authHeaders(token),
        baseUrl: ApiService.accountsBaseUrl,
      );

      response['institutionName'] =
          await ApiService.get(
            ApiRoutes.collegeList,
            headers: ApiService.authHeaders(token),
            baseUrl: ApiService.accountsBaseUrl,
          ).then((colleges) {
            final college = colleges.firstWhere(
              (college) => college['id'] == response['institutionId'],
              orElse: () => null,
            );
            return college != null ? college['name'] : 'Unknown';
          });

      if (response['institutionName'] == 'Unknown') {
        response['institutionName'] =
            await ApiService.get(
              ApiRoutes.schoolList,
              headers: ApiService.authHeaders(token),
              baseUrl: ApiService.accountsBaseUrl,
            ).then((colleges) {
              final college = colleges.firstWhere(
                (college) => college['id'] == response['institutionId'],
                orElse: () => null,
              );
              return college != null ? college['name'] : 'Unknown';
            });
      }

      final profileModel = ProfileModel.fromJson(response);

      List<EventModel> registeredEvents =
          await FetchRegisteredEvents.returnRegisteredEvents();

      profileModel.registeredEvents = registeredEvents;

      emit(ProfileLoaded(profileModel));
    } catch (e) {
      emit(
        ProfileError(
          'Failed to load profile. Please check your connection and try again.',
        ),
      );
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
      emit(ProfileError('Login failed. Please try again.'));
    }
  }

  Future<void> _onLogoutProfileRoutine(
    LogoutProfileRoutine event,
    Emitter<ProfileState> emit,
  ) async {
    emit(LogoutStartedState());
    try {
      await AuthService.logout();
      emit(ProfileSignedOut());
    } catch (e) {
      emit(ProfileError('Logout failed. Please try again.'));
    }
  }
}
