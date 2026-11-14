# Next Steps (on the Mac)

The code is finished and Firebase is already set up. Follow these steps on the Mac, in order.

## What is already done ✅

- [x] SwiftUI app code (login, sign up, sign out, add / edit / delete / complete tasks, live updates)
- [x] Xcode project with the Firebase packages (FirebaseAuth, FirebaseFirestore) already added
- [x] Firebase project **FirebaseTodoApp** (project ID `fir-todoapp-cb4b5`)
- [x] Email/Password sign-in turned on
- [x] Firestore database created, with security rules published (each user only sees their own tasks)
- [x] iOS app registered in Firebase with bundle ID `com.jani.FirebaseTodoApp`

## What you need to do

### Step 1: Get the project on the Mac

Open **Terminal** and run:

```bash
cd ~/Desktop
git clone https://github.com/ami-JANI/To-Do-List-App-SwiftUI.git
cd To-Do-List-App-SwiftUI
open FirebaseTodoApp.xcodeproj
```

(If you already cloned it before, run `git pull` inside the folder instead.)

### Step 2: Wait for the Firebase packages

When Xcode opens, it downloads the Firebase packages by itself. Look at the progress at the top of the
Xcode window. The first time, this can take **5 to 10 minutes**. Don't build until it finishes.

If you see a package error: **File → Packages → Reset Package Caches**, then **File → Packages → Resolve Package Versions**.

### Step 3: Download `GoogleService-Info.plist`

1. On the Mac, open the browser and go to
   **https://console.firebase.google.com/project/fir-todoapp-cb4b5/settings/general**
   (sign in with the same Google account that owns the Firebase project).
2. Scroll down to **Your apps** → click the iOS app **Todo iOS** (`com.jani.FirebaseTodoApp`).
3. Click **GoogleService-Info.plist** to download it.

> Make sure the file name is exactly `GoogleService-Info.plist`.
> If the Mac saves it as `GoogleService-Info (1).plist`, rename it.

### Step 4: Put the plist in the project folder

The Xcode project already points to `FirebaseTodoApp/GoogleService-Info.plist`. It shows in **red** in
Xcode until the file is there. You only need to copy the file in:

1. In **Finder**, copy `GoogleService-Info.plist` from **Downloads** into the
   `To-Do-List-App-SwiftUI/FirebaseTodoApp/` folder (the same folder that has `FirebaseTodoAppApp.swift`).
2. In Xcode, the red `GoogleService-Info.plist` turns normal. **Don't** drag it into Xcode again,
   or you will get a duplicate.

### Step 5: Signing (Team)

1. In Xcode, click the blue **FirebaseTodoApp** project icon at the top of the left sidebar.
2. Select the **FirebaseTodoApp** target → **Signing & Capabilities** tab.
3. **Team**: pick your own Apple ID or the lab account (the project currently has the Team from the Mac it was last built on). If none is listed: **Add an Account…** and sign in
   with any Apple ID (a free one works).
4. Leave **Bundle Identifier** as `com.jani.FirebaseTodoApp`. It must match Firebase.
5. You should see **Keychain Sharing** listed there already. Leave it.

### Step 6: Run the app

1. At the top of Xcode, choose a simulator, for example **iPhone 15** or **iPhone 16**.
2. Press **⌘R** (or the ▶️ button).

### Step 7: Test everything (good to show in the lab)

1. Tap **Sign Up** → enter an email and a password (6+ characters) → **Sign Up**.
2. You land on **My Tasks**. Tap **+** → add a title and description → **Save**.
3. Tap the circle on a task to mark it **done**.
4. Tap a task → **Edit** → change it → **Save**.
5. Swipe left on a task → **Delete** (or use **Delete Task** on the detail screen).
6. Tap the sign-out icon (top left) → sign in again → your tasks are still there.
7. Check Firebase console:
   - **Authentication → Users**: your account is listed
   - **Firestore → Data**: `users → (your user id) → tasks → ...`

### Step 8: Submit

Submit this link:

**https://github.com/ami-JANI/To-Do-List-App-SwiftUI**

`GoogleService-Info.plist` is in `.gitignore`, so it will **not** be pushed to GitHub. That is normal.
If your teacher wants to run the app, they need to add their own plist (see `README.md`).

If you change any code on the Mac and want to push it:

```bash
git add .
git commit -m "Update app"
git push
```

## If something goes wrong

| Problem | Fix |
|---|---|
| App crashes at launch saying it can't find `GoogleService-Info.plist`, or the file is red in Xcode | Redo **Step 4**. The file must be inside the `FirebaseTodoApp/` folder with exactly that name. |
| `No such module 'FirebaseAuth'` or `'FirebaseFirestore'` | Packages are not finished yet. Wait, or do *Reset Package Caches* (**Step 2**). |
| Red error *"Signing requires a development team"* | **Step 5**: pick a Team. |
| Sign up/sign in shows a **keychain** error | **Step 5**: make sure a Team is chosen and Keychain Sharing is listed. Then **Product → Clean Build Folder** (⇧⌘K) and run again. |
| *"Missing or insufficient permissions"* | You are signed in with a different Firebase project's plist. Download the plist from project `fir-todoapp-cb4b5` (**Step 3**). |
| *"The password must be 6 characters long or more"* | Use a longer password. |
| Xcode is older than 15.3 and the project won't open or build | Ask for a Mac with a newer Xcode, or search the exact error online. |
| Any other red error | Copy the full error text and search it online, or ask your lab teacher. |
