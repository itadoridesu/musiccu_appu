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

```
cd musiccu_appu
```

3. Install dependencies:

```
flutter pub get
```

4. Run the app:

```
flutter run
```

> Make sure you have Flutter installed and your device/emulator ready.

---

## 🎨 Usage

* Navigate through your songs and playlists
* Tap a song to play or add to queue
* Use the queue screen to reorder, skip, or remove songs
* Long press or use playlist options to add/remove multiple songs
* Enjoy dark/light mode toggle and smooth UI animations

---

## 🗂 Folder Structure

Feature-First Structure

```
lib/
├── bindings/               # Dependency injections and bindings (GetX)
├── common/                 # Shared widgets and styles
│   ├── styles/             # Global styling (colors, text styles, themes)
│   └── widgets/            # Reusable UI components
│       ├── appbar/
│       ├── container/
│       ├── glassmorphism/
│       ├── icons/
│       ├── images/
│       ├── music/
│       ├── select/
│       ├── texts/
│       └── tiles/
├── data/                   # Data layer
│   ├── dummy_data/         # Sample or mock data
│   ├── repositories/       # Abstracted data sources
│   └── services/           # APIs or local services
├── features/               # Feature modules
│   ├── authentication/     # User login & registration
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

---

## 📸 Demo / Screenshots

### 📃 Songs List

* Songs Screen  
  ![Songs Screen](screenshots/songs-screen.jpg)

### 🎤 Now Playing / Song

* Song Playing  
  ![Song Playing](screenshots/song-playing.jpg)
* Song Playing Repeat1 Mode  
  ![Song Playing Repeat1 Mode](screenshots/song-playing-repeat1-mode.jpg)
* Lyrics Screen  
  ![Lyrics Screen](screenshots/lyrics-screen.jpg)
* Song Options  
  ![Song Options](screenshots/song-options.jpg)
* Song Imported  
  ![Song Imported](screenshots/song-imported.jpg)

### 🎶 Queue

* Queue Screen  
  ![Queue](screenshots/queue.jpg)
* Queue Song Positioning  
  ![Queue Song Positioning](screenshots/queue-song-positioning.jpg)
* Remove Song from Queue  
  ![Queue Remove Song](screenshots/queue-remove-song.jpg)
* Queue Shuffle On  
  ![Queue Shuffle On](screenshots/queue-shuffl-on.jpg)

### 🎵 Playlists

* Playlists Deleted Snackbar  
  ![Playlists Deleted Snackbar](screenshots/playlists-deleted-snackbar.jpg)
* Delete Playlists  
  ![Delete Playlists](screenshots/delete-playlists.jpg)
* Add Song to Playlist  
  ![Add Song to Playlist](screenshots/add-song-to-playlist.jpg)
* Many Songs to Many Playlists  
  ![Many Songs to Many Playlists](screenshots/many-songs-to-many-playlists.jpg)
* Select Playlists Options  
  ![Select Playlists Options](screenshots/select-playlists-options.jpg)
* Most Played Playlist  
  ![Most Played Playlist](screenshots/mostplayed-playlist.jpg)

### ⚙️ Settings

* Settings Screen  
  ![Settings](screenshots/settings.jpg)

---

## ✉️ Author

Adem Hamizi
Email: [adem.hamizi@lau.edu](mailto:adem.hamizi@lau.edu)
Phone: +213 796550612

**itadoridesu** – [GitHub Profile](https://github.com/itadoridesu)
