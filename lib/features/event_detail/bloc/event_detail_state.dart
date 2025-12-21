import 'package:excelapp2025/features/event_detail/data/models/event_detail_model.dart';

abstract class EventDetailState {}

class EventDetailInitial extends EventDetailState {}

class EventDetailLoading extends EventDetailState {}

class EventDetailLoaded extends EventDetailState {
  final EventDetailModel event;

  EventDetailLoaded(this.event);
}

class EventDetailError extends EventDetailState {
  final String message;

  EventDetailError(this.message);
}

