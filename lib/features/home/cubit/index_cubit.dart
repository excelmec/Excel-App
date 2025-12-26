import 'package:flutter_bloc/flutter_bloc.dart';

part 'index_state.dart';

class IndexCubit extends Cubit<IndexState> {
  IndexCubit() : super(IndexState(quickAccessIndex: 0, navBarIndex: 0));
  void updateIndex(int index) =>
      emit(IndexState(quickAccessIndex: index, navBarIndex: state.navBarIndex));
  void updateNavIndex(int index) => emit(
    IndexState(quickAccessIndex: state.quickAccessIndex, navBarIndex: index),
  );
}
