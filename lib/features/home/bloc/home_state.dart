part of 'home_bloc.dart';

sealed class HomeState {}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final HomeModel homeModel;
  HomeLoaded(this.homeModel);
}

class HomeError extends HomeState {
  final String message;
  HomeError(this.message);
}