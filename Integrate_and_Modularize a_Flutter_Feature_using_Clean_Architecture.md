📥 Input Expected:
You will be given:

✅ API Details (endpoint, query/body params, success & error responses)

✅ UI Code (initial screen layout or widget tree)

✅ Bloc/Event/State files (or partial)

✅ DI File (lib/injection_container.dart)

✅ Instructions on how the screen should behave (e.g. fetch on mount, scroll, show error, etc.)

🧠 Your Task (LLM’s job):
🔁 1. Analyze and Understand:
Parse the given API details (GET/POST + query/body + demo response)

Map them into Flutter’s Clean Architecture layers:

Data Source

Repository

Use Case

Bloc (Event → UseCase → State)

⚙️ 2. Pipeline & Architecture (Strictly Follow This):
🔹 Bloc Layer
Add MarketplaceEvent, MarketplaceState, and MarketplaceBloc entries

Manage:

Loading (MarketplaceLoading)

Success ([Feature]SuccessState)

Failure (MarketplaceFailure / MarketplaceError)

🔹 DI (Dependency Injection)
Update lib/injection_container.dart to register:

Remote data source

Repository

Use case

Bloc

🔹 UI Integration
Break large screen files into modular, platform-adaptive widgets:

/widgets/shared/ for shared UI

/widgets/android/ and /ios/ for platform-specific wrappers

Maintain exact UI structure — do not change visual layout

Use:

Platform.isIOS ? Cupertino widgets

else Material widgets

🔹 UX/State Handling
Show loading indicator on MarketplaceLoading

Show product cards or scroll views on success

Show Snackbar (Android) / CupertinoAlert (iOS) on error

Handle edge states like:

Location permission denied

No data found

Invalid/missing lat/lng

🧪 Output Expected:
Return:

Updated versions of:

bloc, event, state files

New files under widgets/, usecases/, repositories/, datasource/

Updated injection_container.dart

Ensure all components are split cleanly and imported into the main screen file

Final Screen.dart must:

Wire BlocProvider

Trigger initial fetch via add(...)

Show UI based on state








📝 Example Instruction for LLM:
✅ You are given:

API: GET /products?lat=...&lng=...

State file: contains MarketplaceLoading, ProductsLoaded, MarketplaceError

Event file: contains FetchProductsRequested

Bloc file: already scaffolded

UI code for MarketplaceScreen

🔁 Integrate this API end-to-end using Clean Architecture.

Fetch on screen mount

Show loading

Show 2-column product grid

Show snackbar if empty or failed

Break components into widgets/ directory

Use platform-adaptive layout