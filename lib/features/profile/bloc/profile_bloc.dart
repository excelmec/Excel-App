import 'package:excelapp2025/features/profile/data/models/profile_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc() : super(ProfileInitial()) {
    on<LoadProfileData>(_onLoadProfileData);
  }

  void _onLoadProfileData(LoadProfileData event, Emitter<ProfileState> emit) {
    emit(ProfileLoading());
    //TODO : Fetch profile data from API
    try {
      final profileModel = ProfileModel(
        id: 0,
        name: 'John Doe',
        email: 'johndoe@example.com',
        role: 'user',
        picture: 'https://www.gravatar.com/avatar/placeholder',
        institutionId: 0,
        institutionName: 'Example Institution',
        gender: 'male',
        mobileNumber: '+919876543210',
        categoryId: 0,
      );
      emit(ProfileLoaded(profileModel));
    } catch (e) {
      emit(ProfileError('Failed to load profile data'));
    }
  }
}
