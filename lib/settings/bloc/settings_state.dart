// ignore_for_file: public_member_api_docs

part of 'settings_bloc.dart';

class SettingsState extends Equatable {
  const SettingsState({
    this.megaPuzzleSize = 3,
    this.miniPuzzleSize = 3,
    this.userImageUrl = '',
  });

  final int megaPuzzleSize;
  final int miniPuzzleSize;
  final String userImageUrl;

  @override
  List<Object> get props => [
        megaPuzzleSize,
        miniPuzzleSize,
        userImageUrl,
      ];

  SettingsState copyWith({
    int? megaPuzzleSize,
    int? miniPuzzleSize,
    String? userImageUrl,
  }) {
    return SettingsState(
      megaPuzzleSize: megaPuzzleSize ?? this.megaPuzzleSize,
      miniPuzzleSize: miniPuzzleSize ?? this.miniPuzzleSize,
      userImageUrl: userImageUrl ?? this.userImageUrl,
    );
  }
}
