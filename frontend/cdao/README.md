# Frontend
The frontend is written in Dart/Flutter using a dart/js interop service worker to use the Lucid js package and Maestro as the provider. The app utilizes Maestro api to receive order updates ensuring that all transactions are verified and NFT databases are up to date. Through many database CRUD operations throughout the purchasing process the availability of the NFT is maintained.
# Run Front End
cd frontend/cdao
flutter run --dart-define-from-file=path/to/config.json -d chrome --web-renderer html
# Build Frontend
flutter build web --dart-define-from-file=path/to/config.json --web-renderer html