// ignore_for_file: public_member_api_docs

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'settings_event.dart';

part 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  SettingsBloc() : super(const SettingsState()) {
    on<SettingsStarted>(_onSettingsStarted);
    on<SettingsUpdated>(_onSettingsUpdated);
  }

  void _onSettingsStarted(SettingsStarted event, Emitter<SettingsState> emit) {
    emit(state);
  }

  void _onSettingsUpdated(SettingsUpdated event, Emitter<SettingsState> emit) {
    emit(
      event.settingsState,
    );
  }
}
