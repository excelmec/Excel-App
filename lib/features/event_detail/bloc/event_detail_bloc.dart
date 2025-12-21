import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:excelapp2025/features/event_detail/bloc/event_detail_event.dart';
import 'package:excelapp2025/features/event_detail/bloc/event_detail_state.dart';
import 'package:excelapp2025/features/event_detail/data/repository/event_detail_repo.dart';

class EventDetailBloc extends Bloc<EventDetailEvent, EventDetailState> {
  final EventDetailRepo eventDetailRepo;

  EventDetailBloc({required this.eventDetailRepo})
      : super(EventDetailInitial()) {
    on<LoadEventDetailEvent>(_onLoadEventDetail);
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
      emit(EventDetailError(e.toString()));
    }
  }
}

