import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit() : super(const ProfileInitial());

  /// A description for yourCustomFunction
  FutureOr<void> yourCustomFunction() {
    // TODO(adil): Add Logic
  }
}
