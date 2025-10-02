import 'package:excelapp2025/features/home/data/models/home_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState>{
  HomeBloc() : super(HomeInitial()) {
    on<LoadHomeData>(_onLoadHomeData);
  }

  void _onLoadHomeData(LoadHomeData event, Emitter<HomeState> emit) {
    // Handle loading home data logic here
  }
}