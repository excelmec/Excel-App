import 'package:excelapp2025/features/profile/data/models/profile_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc() : super(ProfileInitial()) {
    on<LoadProfileData>(_onLoadProfileData);
  }

  void _onLoadProfileData(LoadProfileData event, Emitter<ProfileState> emit) {}
}
