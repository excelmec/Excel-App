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

// Registration states
class RegistrationLoading extends EventDetailState {
  final EventDetailModel event;

  RegistrationLoading(this.event);
}

class RegistrationSuccess extends EventDetailState {
  final EventDetailModel event;
  final String registrationLink;

  RegistrationSuccess({required this.event, required this.registrationLink});
}

class RegistrationRequiresLogin extends EventDetailState {
  final EventDetailModel event;

  RegistrationRequiresLogin(this.event);
}

class RegistrationRequiresProfile extends EventDetailState {
  final EventDetailModel event;

  RegistrationRequiresProfile(this.event);
}

class RegistrationFailed extends EventDetailState {
  final EventDetailModel event;
  final String message;

  RegistrationFailed({required this.event, required this.message});
}
