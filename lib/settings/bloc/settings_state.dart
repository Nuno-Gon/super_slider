// ignore_for_file: public_member_api_docs

part of 'settings_bloc.dart';

class SettingsState extends Equatable {
  const SettingsState({
    this.megaPuzzleSize = 3,
    this.miniPuzzleSize = 3,
    this.userImageUrl = '',
    this.showNumbers = false,
    this.isSuperPuzzle = true,
  });

  final int megaPuzzleSize;
  final int miniPuzzleSize;
  final String userImageUrl;
  final bool showNumbers;
  final bool isSuperPuzzle;

  @override
  List<Object> get props => [
        megaPuzzleSize,
        miniPuzzleSize,
        userImageUrl,
        showNumbers,
        isSuperPuzzle,
      ];

  SettingsState copyWith({
    int? megaPuzzleSize,
    int? miniPuzzleSize,
    String? userImageUrl,
    bool? showNumbers,
    bool? isSuperPuzzle,
  }) {
    return SettingsState(
      megaPuzzleSize: megaPuzzleSize ?? this.megaPuzzleSize,
      miniPuzzleSize: miniPuzzleSize ?? this.miniPuzzleSize,
      userImageUrl: userImageUrl ?? this.userImageUrl,
      showNumbers: showNumbers ?? this.showNumbers,
      isSuperPuzzle: isSuperPuzzle ?? this.isSuperPuzzle,
    );
  }
}
