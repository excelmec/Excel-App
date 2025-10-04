part of 'welcome_bloc.dart';
sealed class WelcomeState {}
final class WelcomeInitial extends WelcomeState {}
final class WelcomeNavigateToHomeActionState extends WelcomeState {}