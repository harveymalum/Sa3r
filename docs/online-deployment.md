# Online deployment

## Cloud pieces
1. PostgreSQL managed database
2. Backend web service using Docker
3. HTTPS domain for API
4. Static hosting for Admin
5. Flutter builds configured with SA3R_API_URL

## Required secrets
DATABASE_URL
AI_API_KEY
PAYMENT_PROVIDER_KEY

## Flutter production build
flutter build apk --release --dart-define=SA3R_API_URL=https://YOUR-API-DOMAIN/api

For iOS:
flutter build ipa --release --dart-define=SA3R_API_URL=https://YOUR-API-DOMAIN/api

Do not put secret API keys in Flutter.
