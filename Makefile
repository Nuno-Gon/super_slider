quick_clean:
	- flutter clean
	- flutter pub get
	
build_runner:
	- flutter packages pub run build_runner build --delete-conflicting-outputs

launcher_icons:
	-flutter pub get
	-flutter pub run flutter_launcher_icons:main -f flutter_launcher_icons*
