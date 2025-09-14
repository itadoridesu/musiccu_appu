# 🎵 Musiccu

**Musiccu** is a feature-rich Flutter music player app that allows users to play, manage, and organize their music seamlessly. With support for playlists, queue management, background playback, and beautiful UI animations, Musiccu offers a smooth and interactive listening experience.

---

## 🌟 Features

* Play songs from local storage
* Queue management: add, delete, reorder songs
* Repeat and shuffle modes
* Most played & recently played tracking
* Playlist management: create, update, delete playlists
* Add multiple songs to multiple playlists at once
* Favorite songs and playlists
* UI enhancements:
  * Dark/light mode
  * Animations: scrolling text, image rotation, sliders
  * Bottom sheet for playlist actions
  * Snackbars for feedback
* Background audio playback with notifications
* Supports both Android and iOS

---

## 💻 Tech Stack

* **Language & Framework:** Dart, Flutter
* **Audio:** `just_audio`, `audio_service`, `audio_session`
* **State Management:** `get`
* **UI Components:** `carousel_slider`, `sliding_up_panel`, `flutter_slidable`, `shimmer`, `marquee`
* **Local Storage:** `hive`, `hive_flutter`
* **File & Media Handling:** `path_provider`, `file_picker`, `flutter_media_metadata`, `media_store_plus`, `dart_tags`
* **Fonts & Icons:** `google_fonts`, `font_awesome_flutter`, `flutter_svg`, `cupertino_icons`

---

## ⚙️ Installation

1. Clone the repository:

```bash
git clone https://github.com/itadoridesu/musiccu_appu.git
````

2. Navigate to the project directory:

```bash
cd musiccu_appu
```

3. Install dependencies:

```bash
flutter pub get
```

4. Run the app:

```bash
flutter run
```

> Make sure you have Flutter installed and your device/emulator ready.

---

## 🗂 Folder Structure

Feature-First Structure

```
lib/
├── bindings/               # Dependency injections and bindings (GetX)
├── common/                 # Shared widgets & styles
│   ├── styles/
│   └── widgets/
├── data/                   # Data layer
│   ├── dummy_data/
│   ├── repositories/
│   └── services/
├── features/               # Feature modules
│   ├── authentication/     # Login & Sign-up
│   │   ├── controllers/
│   │   ├── models/
│   │   └── screens/
│   ├── musiccu/            # Main music functionality
│   │   ├── controllers/
│   │   │   ├── audio/
│   │   │   ├── playlist/
│   │   │   └── ui_controllers/
│   │   ├── models/
│   │   │   ├── playlist_model/
│   │   │   └── song_model/
│   │   └── screens/
│   │       ├── now_playing/
│   │       │   └── widgets/
│   │       │       ├── no_lyrics_layout/
│   │       │       └── yes_lyrics_layout/
│   │       ├── playlists/
│   │       │   ├── inside_playlist/
│   │       │   │   └── widgets/
│   │       │   └── widgets/
│   │       ├── queue/
│   │       │   └── widgets/
│   │       └── songs/
│   │           └── widgets/
│   └── personalization/    # User customization features
│       ├── controllers/
│       ├── models/
│       └── screens/
│           ├── update_playlist.dart
│           └── update_song/
│               └── widgets/
├── routes/                 # App route definitions
└── utils/                  # Helper functions & constants
    ├── constants/
    ├── device/
    ├── exceptions/
    ├── formatters/
    ├── helpers/
    ├── http/
    ├── local_storage/
    ├── logging/
    ├── popups/
    ├── theme/
    │   └── custom_theme/
    └── validators/
```


## 📸 App Walkthrough (Screenshots)

### 1. Songs List
| Songs Screen |
| :---: |
| <img src="screenshots/songs-screen.jpg" width="200"/> |
| *List of songs from local storage* |

### 2. Now Playing
| Playing Song | Repeat1 Mode | Lyrics |
| :---: | :---: | :---: |
| <img src="screenshots/song-playing.jpg" width="200"/> | <img src="screenshots/song-playing-repeat1-mode.jpg" width="200"/> | <img src="screenshots/lyrics-screen.jpg" width="200"/> |
| *Song playback screen* | *Repeat1 mode active* | *Lyrics view* |

| Song Options | Song Imported |
| :---: | :---: |
| <img src="screenshots/song-options.jpg" width="200"/> | <img src="screenshots/song-imported.jpg" width="200"/> |
| *Options for current song* | *Song successfully imported* |

### 3. Queue
| Queue Screen | Song Positioning | Remove Song |
| :---: | :---: | :---: |
| <img src="screenshots/queue.jpg" width="200"/> | <img src="screenshots/queue-song-positioning.jpg" width="200"/> | <img src="screenshots/queue-remove-song.jpg" width="200"/> |
| *Current queue view* | *Reordering songs in queue* | *Removing song from queue* |

| Shuffle On |
| :---: |
| <img src="screenshots/queue-shuffl-on.jpg" width="200"/> |
| *Shuffle mode enabled* |

### 4. Playlists
| Most Played | Add Song | Delete Playlist |
| :---: | :---: | :---: |
| <img src="screenshots/mostplayed-playlist.jpg" width="200"/> | <img src="screenshots/add-song-to-playlist.jpg" width="200"/> | <img src="screenshots/delete-playlists.jpg" width="200"/> |
| *Most played playlist* | *Adding song to playlist* | *Deleting playlist* |

| Many Songs → Playlists | Select Playlist Options | Playlist Deleted Snackbar |
| :---: | :---: | :---: |
| <img src="screenshots/many-songs-to-many-playlists.jpg" width="200"/> | <img src="screenshots/select-playlists-options.jpg" width="200"/> | <img src="screenshots/playlists-deleted-snackbar.jpg" width="200"/> |
| *Add multiple songs to multiple playlists* | *Playlist options menu* | *Feedback after deletion* |

### 5. Settings
| Settings Screen |
| :---: |
| <img src="screenshots/settings.jpg" width="200"/> |
| *App settings and preferences* |

---

## ✉️ Author

Adem Hamizi
Email: [adem.hamizi@lau.edu](mailto:adem.hamizi@lau.edu)
Phone: +213 796550612

GitHub: [itadoridesu](https://github.com/itadoridesu)
