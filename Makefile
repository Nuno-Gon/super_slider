quick_clean:
	- flutter clean
	- flutter pub get
	
build_runner:
	- flutter packages pub run build_runner build --delete-conflicting-outputs