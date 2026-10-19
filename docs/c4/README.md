# Vesta C4 diagrams

| Level | File | Content |
|---|---|---|
| 1 and 2 | `Vesta_C4_Niveau1_Contexte.pdf`, `Vesta_C4_Niveau2_Containers.pdf` | Context and containers |
| 3 | `level3-auth-profile.png` (source: `level3-auth-profile.mmd`) | Auth and Profile components of the Flutter app (VST-27) |
| 4 | `level4-classes.png` (source: `level4-classes.mmd`) | Data classes (see `docs/data-model.md`) |

Sources are Mermaid files. To redraw a PNG: `npx -p @mermaid-js/mermaid-cli mmdc -i level3-auth-profile.mmd -o level3-auth-profile.png -s 2 -b white`, or paste the `.mmd` file in https://mermaid.live and export the PNG.

## Level 3: Auth and Profile

How to read the diagram:

- The big dashed frame is the Flutter app. Screens are at the top, then controllers, then repositories. The Firebase services are outside the frame.
- Every box shows its type between brackets: `[Component: Flutter screen]`, `[Component: Riverpod controller]`, `[Component: Repository]`, `[External system]`. A small legend at the bottom explains the colors.
- Arrows show who calls whom. The rule is Screen -> Controller -> Repository -> Firebase. A screen never talks to Firebase directly.
- Component names are the names we use in the code. The React Native app uses the same names and layers (its controllers are hooks or contexts).
- Data names come from the data model (`docs/data-model.md`, VST-30): `users/{uid}` (public profile) and `users/{uid}/private/contact` (email and phone).
- One arrow crossing remains on purpose: both controllers use both repositories (`AuthController` and `ProfileController` call `AuthRepository` and `UserRepository`), so the arrows cannot all be drawn without a crossing while keeping the layers.

| Component | Type | Responsibility |
|---|---|---|
| `LoginScreen` | Flutter screen | Email and password form. |
| `SignUpScreen` | Flutter screen | Name, email and password form. |
| `ProfileScreen` | Flutter screen | Shows the profile, the language selector and the log out button. |
| `EditProfileScreen` | Flutter screen | Form to change name, photo and phone. |
| `AuthController` | Riverpod controller | Keeps the sign-in state, checks the input, runs sign up, log in and log out, and asks `UserRepository` to create the profile after sign up. |
| `ProfileController` | Riverpod controller | Loads and saves the profile, handles loading and error states, gets the current user id from `AuthRepository`. |
| `AuthRepository` | Repository | Wraps Firebase Auth: sign up, log in, log out, session. |
| `UserRepository` | Repository | Reads and writes `users/{uid}` and `users/{uid}/private/contact` in Firestore. |
