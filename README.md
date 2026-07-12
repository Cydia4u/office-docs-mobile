# Office Docs Mobile

Flutter Android tablet app for Khmer document management by office.

## Features

- Khmer-language tablet UI (Material 3)
- Login and token-based authentication
- Dashboard overview
- **Office / Section / Group organisation** — every document is scoped to an office, a section (category) and a group
- **File upload** — supports PDF, DOC, DOCX, XLS, XLSX, Video and Audio files
- **Metadata form** — title, description, document number, document date, office, section, group and file type
- **Cascading filters** — document list and search screens filter by office → section → group
- Full-text search combined with office/section/group filters
- Document detail view with download button

## Tech stack

- Flutter / Dart
- REST API backend (`Cydia4u/office-docs-api`)
- `http` package — JSON requests + multipart file upload
- `file_picker` package — cross-platform file selection
- `shared_preferences` — auth token storage

## Supported file types

| Type  | Extensions            |
|-------|-----------------------|
| PDF   | .pdf                  |
| Word  | .doc, .docx           |
| Excel | .xls, .xlsx           |
| Video | .mp4, .avi, .mov, .mkv |
| Audio | .mp3, .wav, .aac, .m4a |

## Getting started

```bash
flutter pub get
flutter run
```

The app connects to `http://10.0.2.2:8000/api` by default (Android emulator localhost).
Change `ApiConstants.baseUrl` in `lib/core/constants/api_constants.dart` for a real device.

## API endpoints consumed

| Method | Path                                         | Purpose               |
|--------|----------------------------------------------|-----------------------|
| POST   | /api/login                                   | Authenticate          |
| POST   | /api/logout                                  | Sign out              |
| GET    | /api/offices                                 | List offices          |
| GET    | /api/document-categories?office_id=\{id\}    | List sections/categories |
| GET    | /api/document-groups?category_id=\{id\}      | List groups           |
| GET    | /api/documents?office_id=&category_id=&group_id=&search= | List / filter / search documents |
| POST   | /api/documents (multipart/form-data)         | Upload document       |
| GET    | /api/documents/\{id\}                        | Document detail       |

## Status

Feature-complete initial implementation.
