# YogiTunes Mobile App

## Development Flow

### 1. **Feature Branch Creation (Off Asana Tasks)**

When you start work on a new feature or bugfix from an Asana task, follow these steps:

1. **Start by creating a feature branch** from the `development` branch. This branch name should reference the Asana task for clarity.

    Example:

    ```bash
    git checkout development
    git pull origin development
    git checkout -b feature/asana-task-123
    ```

    This creates a new branch named `feature/asana-task-123` based on your Asana task (replace `123` with the actual Asana task ID or description).

2. **Work on your feature** and commit changes with descriptive commit messages. These commit messages will later be used in your release notes when you push the build to TestFlight.

    Example:

    ```bash
    git add .
    git commit -m "Implement user authentication (Asana Task #123)"
    ```

3. **Push your feature branch to the remote repository** to ensure it's backed up and can be reviewed later.

    ```bash
    git push origin feature/asana-task-123
    ```

### 2. **Feature Branch Merging Back into `development`**

Once you've completed the feature and it's ready for integration:

1. **Create a pull request** (PR) from `feature/asana-task-123` into the `development` branch for code review.

2. **After approval**, merge the feature branch into `development`. You can either merge manually after review or through your CI tool if it's configured to auto-merge.

    Example using the command line:

    ```bash
    git checkout development
    git pull origin development
    git merge feature/asana-task-123
    ```

3. **Delete the feature branch** after merging to keep your repository clean.
    ```bash
    git branch -d feature/asana-task-123
    git push origin --delete feature/asana-task-123
    ```

### 3. **Tagging for Release**

Once your feature branch is merged into `development`, and you're ready to prepare the next release:

1. **Tag the `development` branch** with the version and build number. This tag will be used by Fastlane for generating the release.

    Example:

    ```bash
    git tag -a v3.0.12-9 -m "Release 3.0.12 (Build 9)"
    git push origin v3.0.12-9
    ```

    - `v3.0.12-9` is the tag, where `3.0.12` is the version number and `9` is the build number.

### 4. **Run Fastlane to Push to TestFlight**

Once the changes are merged, tagged, and ready to release, you can run Fastlane to push the build to TestFlight. Fastlane will automatically pick up the commit messages from the development branch and send them to TestFlight as release notes.

Example:

```bash
fastlane beta
```

### 5. **Announcing the Release (via Slack)**

As part of the Fastlane script, a message will automatically be posted in your Slack channel with the version and build number, along with the release notes, which are based on the Git commit messages.

Your Slack message would look like:

```
New Beta version 3.0.12 (Build 9) is live on TestFlight 🚀
Release Notes:
- Implement user authentication (Asana Task #123)
- Fix login screen layout (Asana Task #124)
```

### GitFlow Overview in This Workflow:

-   **Development Branch (`development`)**: This is the main working branch for upcoming releases.
-   **Feature Branches (`feature/asana-task-123`)**: Created for each Asana task, they are merged back into `development` after completion.
-   **Release Tags (`v3.0.12-9`)**: Each release is tagged from the `development` branch once the features are complete and ready for release.
-   **Master/Production Branch (`main` or `master`)**: After the beta version is thoroughly tested, this branch is updated for the final release.

## License

```
Copyright © 2021 Ankit Sangwan

BlackHole is free software licensed under GPL v3.0.
You can redistribute and/or modify it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

BlackHole is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;
without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
See the GNU General Public License for more details.
```

[View License](https://github.com/Sangwan5688/BlackHole/blob/main/LICENSE)

## Building from Source

1. If you don't have Flutter SDK installed, please visit official [Flutter](https://flutter.dev/) site.
2. Fetch latest source code from master branch.

```
git clone https://github.com/Sangwan5688/BlackHole.git
```

3. Run the app with Android Studio or VS Code. Or the command line:

```
flutter pub get
flutter run
```
