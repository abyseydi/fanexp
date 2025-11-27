# Configure Java 8 pour Flutter
$env:JAVA_HOME = "C:\Java\jdk-8.0.472.8-hotspot"
$env:Path = "$env:JAVA_HOME\bin;$env:Path"

# Nettoyer le projet et récupérer les packages
flutter clean
flutter pub get

# Lancer l'app
flutter run
