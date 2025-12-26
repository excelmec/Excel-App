import 'package:flutter_bloc/flutter_bloc.dart';

part 'welcome_event.dart';
part 'welcome_state.dart';

class WelcomeBloc extends Bloc<WelcomeEvent, WelcomeState> {
  WelcomeBloc() : super(WelcomeInitial()) {
    on<GetStartedButtonClickedEvent>(handleGetStartedButtonClickedEvent);
  }

  void handleGetStartedButtonClickedEvent(
    GetStartedButtonClickedEvent event,
    Emitter<WelcomeState> emit,
  ) {
    emit(WelcomeNavigateToHomeActionState());
  }
}
