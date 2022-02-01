// ignore_for_file: public_member_api_docs

part of 'settings_bloc.dart';

abstract class SettingsEvent extends Equatable {
  const SettingsEvent();

  @override
  List<Object> get props => [];
}

class SettingsStarted extends SettingsEvent {
  const SettingsStarted();
}

class SettingsUpdated extends SettingsEvent {
  const SettingsUpdated(
    this.megaPuzzleSize,
    this.miniPuzzleSize,
    this.userImageUrl,
  );

  final int megaPuzzleSize;
  final int miniPuzzleSize;
  final String userImageUrl;

  @override
  List<Object> get props => [
        megaPuzzleSize,
        miniPuzzleSize,
        userImageUrl,
      ];
}
