# Firebase To-Do List (SwiftUI)

CSE 3218 Mobile Computing Lab Assignment.

> 👉 **Running it on the Mac? Start with [NEXT_STEPS.md](NEXT_STEPS.md).**

A simple iOS to-do list app built with **SwiftUI**, **Firebase Authentication** (email + password) and **Cloud Firestore**.

## Features

- Sign up, sign in and sign out with email and password (Firebase Auth)
- Every task has a **title** and a **description**
- Full CRUD:
  - **Create**: tap **+** and fill in the form
  - **Read**: the list updates live (`addSnapshotListener`)
  - **Update**: open a task and tap **Edit**, or tap the circle to mark it done
  - **Delete**: swipe left on a task, or tap **Delete Task** on the detail screen
- Each user only sees their own tasks (stored at `users/{userId}/tasks/{taskId}`)
- Filter tasks: All / Pending / Done

## Project structure

```
FirebaseTodoApp/
├── FirebaseTodoAppApp.swift      App entry point, FirebaseApp.configure()
├── Models/
│   └── TaskItem.swift            Task struct, Validatable protocol, TaskFilter enum
├── ViewModels/
│   ├── AuthViewModel.swift       Sign up / sign in / sign out
│   └── TaskViewModel.swift       Firestore CRUD + live listener
└── Views/
    ├── RootView.swift            Shows Login or the task list
    ├── LoginView.swift
    ├── SignUpView.swift
    ├── InputField.swift          Reusable text field (@Binding)
    ├── TaskListView.swift        Main list
    ├── TaskRowView.swift         One row in the list
    ├── TaskDetailView.swift      Task details, edit, delete
    └── TaskFormView.swift        Add / edit form (opened with .sheet)
```

## Setup (do this once on the Mac)

Requirements: macOS with **Xcode 15.3 or newer**, iOS 17+ simulator.

### 1. Create the Firebase project

1. Go to [console.firebase.google.com](https://console.firebase.google.com) and click **Add project**.
2. Click the **iOS** icon to register an iOS app.
   - **Bundle ID:** `com.jani.FirebaseTodoApp`
     (If you change it, also change it in Xcode → target → *Signing & Capabilities*. They must match.)
3. Download **`GoogleService-Info.plist`**.

### 2. Add `GoogleService-Info.plist`

1. Open `FirebaseTodoApp.xcodeproj` in Xcode.
2. Drag `GoogleService-Info.plist` into the yellow **FirebaseTodoApp** folder in the left sidebar.
3. In the pop-up, tick **Copy items if needed** and make sure the **FirebaseTodoApp** target is ticked.

> This file is in `.gitignore`, so it will not be pushed to GitHub.

### 3. Firebase packages (Swift Package Manager)

The project already lists the Firebase package (`https://github.com/firebase/firebase-ios-sdk`, version 11.x)
with the **FirebaseAuth** and **FirebaseFirestore** products. When you open the project, Xcode downloads them
automatically (this can take a few minutes the first time).

If Xcode shows a package error: **File → Packages → Reset Package Caches**, then **Resolve Package Versions**.

If you ever need to add them by hand: **File → Add Package Dependencies…**, paste
`https://github.com/firebase/firebase-ios-sdk`, and choose **FirebaseAuth** and **FirebaseFirestore**.

### 4. Turn on Email/Password sign-in

Firebase console → **Build → Authentication → Get started → Sign-in method → Email/Password → Enable**.

### 5. Create the Firestore database and rules

1. Firebase console → **Build → Firestore Database → Create database** (pick a location, start in *production mode*).
2. Open the **Rules** tab, paste the rules below (also in [`firestore.rules`](firestore.rules)) and click **Publish**:

```
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /users/{userId}/tasks/{taskId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
  }
}
```

### 6. Signing and Keychain Sharing

1. Click the blue project icon → target **FirebaseTodoApp** → **Signing & Capabilities**.
2. Choose your **Team** (a free personal Apple ID team is fine).
3. **Keychain Sharing** is already added (see `FirebaseTodoApp.entitlements`). Firebase Auth stores the
   signed-in user in the Keychain, and on some simulators sign-in fails with a *keychain error* without it.
   If it is missing, click **+ Capability → Keychain Sharing**.

### 7. Run

Choose an iPhone simulator and press **⌘R**. Create an account, then add some tasks.

## Common problems

| Problem | Fix |
|---|---|
| Crash at launch: *"could not locate configuration file GoogleService-Info.plist"* | Step 2. The file must be added to the **FirebaseTodoApp target**. |
| `No such module 'FirebaseAuth'` | Wait for packages to finish, or do *Reset Package Caches* (step 3). |
| Sign up says *"operation not allowed"* | Enable Email/Password (step 4). |
| Tasks do not show, *"Missing or insufficient permissions"* | Publish the Firestore rules (step 5). |
| Keychain error when signing in | Keychain Sharing + choose a Team (step 6). |
| App Check warnings in the console | This app does not use App Check, so you can ignore them. If your Firebase project **enforces** App Check, add the `FirebaseAppCheck` package and, before `FirebaseApp.configure()`, call `AppCheck.setAppCheckProviderFactory(AppCheckDebugProviderFactory())`. Then copy the debug token printed in the Xcode console into Firebase console → App Check → *Manage debug tokens*. |
| Template made with SwiftData | This project does **not** use SwiftData. If you start a new project yourself, choose *Storage: None*. |

## Lab topics used in this app

| Topic | Where |
|---|---|
| `let` / `var`, type annotations | Everywhere, e.g. `TaskItem.swift` (`let id: String`, `var title: String`) |
| String interpolation | `TaskListView` (`"\(counts.total) tasks"`), `TaskFormView` (character counter) |
| Comments | All files (`//` and `///`) |
| Comparison / logical operators | `AuthViewModel.validate` (`||`, `<`), `TaskItem.isValid` (`&&`, `<=`) |
| Ternary operator `? :` | `TaskItem.statusIcon`, `TaskRowView` colors, `TaskFormView` title |
| Nil-coalescing `??` | `TaskItem.init?(document:)`, `TaskFormView.init` |
| Ranges | `TaskFormView` → `.lineLimit(3...8)` |
| Tuples | `TaskViewModel.taskCounts() -> (total: Int, done: Int)` |
| Optionals, `if let`, `guard`, optional chaining | `TaskItem.init?(document:)`, `TaskViewModel`, `TaskDetailView`, `AuthViewModel` |
| `switch` on an enum | `TaskFilter.matches(_:)` in `TaskItem.swift` |
| `for-in` loop (with `where`) | `TaskViewModel.taskCounts()`, `deleteTasks(at:from:)` |
| Functions, argument labels, default values | `TaskItem.init(id:title:description:isDone:createdAt:)`, `InputField(isSecure: false)` |
| Struct vs class | `TaskItem` and all views are **structs**; `AuthViewModel` / `TaskViewModel` are **classes** |
| Stored, computed, lazy, static properties | `TaskItem` (stored, computed `isValid`/`shortDescription`, `static let collectionName`); `TaskViewModel` (`lazy var db`) |
| Protocols | Custom `Validatable` protocol; `Identifiable`, `ObservableObject`, `View`, `App`, `CaseIterable` |
| `Text`, `Image` (SF Symbols, `resizable`, `aspectRatio`, `frame`, `clipShape`), `Button` | `LoginView`, `SignUpView`, `TaskRowView` |
| `VStack` / `HStack`, modifiers (padding, font, color) | All views |
| `@State` | `LoginView`, `SignUpView`, `TaskListView`, `TaskFormView`, `TaskDetailView` |
| `@Binding` | `InputField` (`@Binding var text`), parent passes `$email` / `$password` |
| `NavigationStack`, `NavigationLink`, `.navigationTitle` | `TaskListView` (row → `TaskDetailView`), `LoginView` |
| `.navigationDestination(isPresented:)` | `LoginView` → opens `SignUpView` from code |
| `FirebaseApp.configure()` at launch | `FirebaseTodoAppApp.init()` |
| Firebase Auth (sign up / in / out) | `AuthViewModel` |
| MVVM: `ObservableObject`, `@Published` | `AuthViewModel`, `TaskViewModel` |
| `@StateObject` / `@EnvironmentObject` | `FirebaseTodoAppApp` and `TaskListView` create them; `RootView`, `LoginView`, `TaskDetailView` read them |
| Firestore add / read / update / delete + `addSnapshotListener` | `TaskViewModel` |
| `List` / `ForEach`, swipe to delete | `TaskListView` |
| `.sheet` forms | `TaskListView` (new task), `TaskDetailView` (edit task) |
