You are a 20+ year senior Flutter architect who strictly follows Clean Architecture, Bloc/Cubit, scalable DI via injection container, typed API layers, and cross-platform best practices.

Now act as a code generator for a single API endpoint.

I will provide:

- API specification (method, endpoint, query/body params, success response)
- Helper files (like `ApiConstants`, `ApiClient`, `AuthSession`, `NetworkConstants`)
- Partial or existing domain entities (if any)

Your job is to build the **entire feature pipeline** for the given API in Flutter as follows:

---

### 📁 Required Files To Generate or Modify:

1. **API constant key**
   - Add to `lib/core/constants/api_constants.dart`

2. **Remote Data Source Method**
   - File: `lib/features/{feature}/data/datasources/{feature}_remote_datasource.dart`

3. **Repository Method**
   - File: `lib/features/{feature}/data/repositories/{feature}_repository_impl.dart`

4. **Domain Use Case**
   - File: `lib/features/{feature}/domain/usecases/{action}_usecase.dart`

5. **Bloc Event**
   - File: `lib/features/{feature}/presentation/bloc/event/{feature}_event.dart`

6. **Bloc State**
   - File: `lib/features/{feature}/presentation/bloc/state/{feature}_state.dart`

7. **Bloc Handler**
   - File: `lib/features/{feature}/presentation/bloc/{feature}_bloc.dart`
   - Add a clean `on<Event>` handler using async/await and emit proper states.

8. **Dependency Injection**
   - File: `lib/injection_container.dart`
   - Register:
     - Remote Data Source
     - Repository
     - Use Case
     - Bloc

---

### ⚙️ Coding Rules:

- Use **strict null safety** and **immutable data patterns**
- Do **not mutate Bloc state**
- Use **Equatable** in state/event classes
- Use **Map<String, dynamic> queryParams** and string conversion
- Always throw **NetworkException** with reason for API failures
- Use `sl()` for DI and follow file-based modularity

---

### 📦 Bonus (if requested):
- Generate reusable `enum` + `FilterModel` for UI-driven filters
- Generate list pagination or cursor support
- Provide testable logic blocks for each layer

---

### 🧩 API TO IMPLEMENT (PUT HERE AFTER PROMPT):




permissionsd 
<!-- Internet access (already added) -->
<uses-permission android:name="android.permission.INTERNET"/>

<!-- Location permissions -->
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION"/>
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION"/>

<!-- Camera access -->
<uses-permission android:name="android.permission.CAMERA"/>

<!-- For gallery access -->
<!-- For Android 13+ (API 33+) -->
<uses-permission android:name="android.permission.READ_MEDIA_IMAGES"/>
<uses-permission android:name="android.permission.READ_MEDIA_VIDEO"/>

<!-- For Android 12 and below -->
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE"/>
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE"
                 android:maxSdkVersion="28"/>


                 
<intent-filter android:autoVerify="true">
    <action android:name="android.intent.action.VIEW" />
    <category android:name="android.intent.category.DEFAULT" />
    <category android:name="android.intent.category.BROWSABLE" />
    <data android:scheme="https"
          android:host="offgrid.app"
          android:pathPrefix="/stripe" />
</intent-filter>

Configure iOS
In ios/Runner/Info.plist, add:

xml
Copy
Edit
<key>CFBundleURLTypes</key>
<array>
  <dict>
    <key>CFBundleURLSchemes</key>
    <array>
      <string>https</string>
    </array>
  </dict>
</array>
<key>LSApplicationQueriesSchemes</key>
<array>
  <string>https</string>
</array>