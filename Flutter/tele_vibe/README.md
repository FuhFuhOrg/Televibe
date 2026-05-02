# tele_vibe

A Flutter messenger prototype with a dark Telegram-inspired interface.

## Current features

- Sign in through a WebSocket connection to the main API.
- Automatically open prepared chat data when the API is unavailable.
- A prepared feed with 24 realistic conversations: 12 direct chats and 12 groups.
- Group chats include 5-50 members, avatars, photo messages, unread counters, pinned chats, and realistic preview text.
- The prepared flow supports opening chats, search, sending messages and images, editing and deleting messages, creating chats, and viewing chat details.
- Portfolio-ready local mock features: stories, chat folders, archive, calls, contacts, and media/files/links sections in chat info.
- Features that are not yet backed by a live API are presented as local pseudo flows, so the interface still looks complete in MVP demos.

## Run

Run the project as a standard Flutter application.

Useful commands:

```bash
flutter pub get
flutter run
```

For an Android debug build:

```bash
flutter build apk --debug
```
