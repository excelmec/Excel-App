import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:excelapp2025/features/event_detail/bloc/event_detail_event.dart';
import 'package:excelapp2025/features/event_detail/bloc/event_detail_state.dart';
import 'package:excelapp2025/features/event_detail/data/repository/event_detail_repo.dart';
import 'package:excelapp2025/features/event_detail/data/repository/registration_repo.dart';


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
      // Determine the path based on event type
      final path = eventDetail.eventType.toLowerCase() == 'competition'
          ? 'competitions'
          : 'events';

      emit(
        RegistrationSuccess(
          event: eventDetail,
          registrationLink: 'https://excelmec.org/$path/${eventDetail.id}',
        ),
      );
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
