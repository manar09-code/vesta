# Vesta C4 diagrams

| Level | File | Content |
|---|---|---|
| 1 and 2 | `Vesta_C4_Niveau1_Contexte.pdf`, `Vesta_C4_Niveau2_Containers.pdf` | Context and containers |
| 3 | `level3-auth-profile.png` (source: `level3-auth-profile.mmd`) | Auth and Profile components of the Flutter app (VST-27) |
| 4 | `level4-classes.png` (source: `level4-classes.mmd`) | Data classes (see `docs/data-model.md`) |

Sources are Mermaid files. To redraw a PNG: `npx -p @mermaid-js/mermaid-cli mmdc -i level3-auth-profile.mmd -o level3-auth-profile.png -s 2 -b white`, or paste the `.mmd` file in https://mermaid.live and export the PNG.

## Level 3: Auth and Profile

How to read the diagram:

- The big dashed frame is the Flutter app. It has three layers, from top to bottom: screens, controllers, repositories.
- Arrows show who calls whom. The rule is Screen -> Controller -> Repository -> Firebase. A screen never talks to Firebase directly.
- The beige boxes are external systems we do not build: Firebase Auth and Firestore.
- Component names are the names we use in the code. The React Native app uses the same names (same modules, same layers).
- Data names come from `docs/data-model.md`: `users/{uid}` (public profile) and `users/{uid}/private/contact` (email and phone).

| Component | Responsibility |
|---|---|
| `LoginScreen` | Email and password form. |
| `SignUpScreen` | Name, email and password form. |
| `ProfileScreen` | Shows the profile, the language selector and the log out button. |
| `EditProfileScreen` | Form to change name, photo and phone. |
| `AuthController` | Keeps the sign-in state, checks the input, runs sign up, log in and log out. |
| `ProfileController` | Loads and saves the profile, handles loading and error states. |
| `AuthRepository` | Wraps Firebase Auth: sign up, log in, log out, session. |
| `UserRepository` | Reads and writes `users/{uid}` and `users/{uid}/private/contact` in Firestore. |
