import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
part 'practice_state.dart';

class PracticeCubit extends Cubit<PracticeState> {
  PracticeCubit() : super(const PracticeInitial());
}
