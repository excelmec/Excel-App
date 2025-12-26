abstract class EventDetailEvent {}

class LoadEventDetailEvent extends EventDetailEvent {
  final int eventId;

  LoadEventDetailEvent(this.eventId);
}

class RegisterForEventEvent extends EventDetailEvent {
  final int eventId;
  final String registrationLink;

  RegisterForEventEvent({
    required this.eventId,
    required this.registrationLink,
  });
}
