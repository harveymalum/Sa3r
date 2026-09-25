# سعّر | Sa3r — Online-connected MVP

تم ربط تطبيق Flutter مباشرة بالـBackend المنشور على Supabase Edge Functions.

API:
https://bpphsjvbvfalsclyuecm.supabase.co/functions/v1/sa3r-api

## تشغيل Flutter
```bash
cd mobile
flutter pub get
flutter run
```

أو:
```bash
flutter run --dart-define=SA3R_API_URL=https://bpphsjvbvfalsclyuecm.supabase.co/functions/v1/sa3r-api
```

## بناء APK
```bash
flutter build apk --release --dart-define=SA3R_API_URL=https://bpphsjvbvfalsclyuecm.supabase.co/functions/v1/sa3r-api
```

## GitHub Actions
يوجد workflow في `.github/workflows/build-apk.yml` لبناء APK تلقائياً عند رفع المشروع إلى GitHub.

ملاحظة: هذا المشروع MVP متصل بالـAPI وقاعدة البيانات التجريبية الحالية. الدفع، تسجيل الدخول الحقيقي، الدردشة، والتنبيهات تحتاج المرحلة التالية.
