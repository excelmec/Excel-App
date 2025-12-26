import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:excelapp2025/core/api/services/auth_service.dart';
import 'package:excelapp2025/core/api/services/api_service.dart';
import 'package:excelapp2025/features/event_detail/bloc/event_detail_event.dart';
import 'package:excelapp2025/features/event_detail/bloc/event_detail_state.dart';
import 'package:excelapp2025/features/event_detail/data/repository/event_detail_repo.dart';
import 'package:excelapp2025/features/event_detail/data/repository/registration_repo.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EventDetailBloc extends Bloc<EventDetailEvent, EventDetailState> {
  final EventDetailRepo eventDetailRepo;
  final RegistrationRepo registrationRepo;

  EventDetailBloc({
    required this.eventDetailRepo,
    RegistrationRepo? registrationRepo,
  }) : registrationRepo = registrationRepo ?? RegistrationRepo(),
       super(EventDetailInitial()) {
    on<LoadEventDetailEvent>(_onLoadEventDetail);
    on<RegisterForEventEvent>(_onRegisterForEvent);
  }

  Future<void> _onLoadEventDetail(
    LoadEventDetailEvent event,
    Emitter<EventDetailState> emit,
  ) async {
    emit(EventDetailLoading());
    try {
      final eventDetail = await eventDetailRepo.fetchEventDetail(event.eventId);
      emit(EventDetailLoaded(eventDetail));
    } catch (e) {
      emit(
        EventDetailError(
          'Failed to load event details. Please check your connection and try again.',
        ),
      );
    }
  }

  Future<void> _onRegisterForEvent(
    RegisterForEventEvent event,
    Emitter<EventDetailState> emit,
  ) async {
    // Get current event from state
    final currentState = state;
    if (currentState is! EventDetailLoaded) return;

    final eventDetail = currentState.event;

    emit(RegistrationLoading(eventDetail));

    try {
      // If it's a team event, directly open the team registration URL
      if (eventDetail.isTeam) {
        emit(
          RegistrationSuccess(
            event: eventDetail,
            registrationLink:
                'https://excelmec.org/competitions/${eventDetail.id}',
          ),
        );
        return;
      }

      // Step 1: Check if user is logged in
      final prefs = await SharedPreferences.getInstance();
      final isLoggedIn = prefs.getBool('isLogged') ?? false;

      if (!isLoggedIn) {
        emit(RegistrationRequiresLogin(eventDetail));
        return;
      }

      // Step 2: Get JWT token
      final jwtToken = await AuthService.getToken();

      if (jwtToken.isEmpty) {
        emit(RegistrationRequiresLogin(eventDetail));
        return;
      }

      // Step 3: Call registration API
      try {
        final response = await registrationRepo.registerForEvent(
          eventId: eventDetail.id,
          jwtToken: jwtToken,
          teamId: eventDetail.isTeam ? 0 : null,
          ambassadorId: 0,
        );

        // Step 4: Verify success
        final isSuccess =
            response['success'] == true || response['statusCode'] != null;

        // Step 5: Check response for "update profile" message
        final responseString = response.toString().toLowerCase();
        final responseMessage =
            response['message']?.toString().toLowerCase() ?? '';

        // Check if backend says to update profile
        if (responseMessage.contains('update profile') ||
            responseMessage.contains('profile') ||
            responseString.contains('update profile') ||
            responseString.contains('profile')) {
          emit(RegistrationRequiresProfile(eventDetail));
          return;
        }

        // Step 6: If registration successful, emit success
        if (!isSuccess) {
          emit(
            RegistrationFailed(
              event: eventDetail,
              message: 'Registration not successful',
            ),
          );
          return;
        }

        emit(
          RegistrationSuccess(
            event: eventDetail,
            registrationLink: event.registrationLink,
          ),
        );
      } catch (e) {
        if (e is HttpException) {
          final errorMessage = e.message.toLowerCase();

          // Check if error says to update profile
          if (errorMessage.contains('update profile') ||
              errorMessage.contains('profile') ||
              errorMessage.contains('complete profile')) {
            emit(RegistrationRequiresProfile(eventDetail));
            return;
          }

          emit(
            RegistrationFailed(
              event: eventDetail,
              message: 'Registration failed. Please try again.',
            ),
          );
        } else {
          emit(
            RegistrationFailed(
              event: eventDetail,
              message: 'Registration failed. Please try again.',
            ),
          );
        }
      }
    } catch (e) {
      emit(
        RegistrationFailed(
          event: eventDetail,
          message:
              'Registration failed. Please check your connection and try again.',
        ),
      );
    }
  }
}
