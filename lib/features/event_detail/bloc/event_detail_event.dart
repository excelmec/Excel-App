abstract class EventDetailEvent {}

class LoadEventDetailEvent extends EventDetailEvent {
  final int eventId;

  LoadEventDetailEvent(this.eventId);
}

