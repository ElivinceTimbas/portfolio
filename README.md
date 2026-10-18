# Elivince Timbas — Flutter Portfolio

A responsive, static Flutter web portfolio with light/dark themes, local fonts, and reduced-motion support.

## Run locally

```sh
flutter pub get
flutter run -d chrome
```

## Update content

- Edit `lib/data/portfolio_content.dart` for profile copy, skills, experience, and project summaries.
- Replace `web/resume.pdf` to update the public CV. The supplied original includes a phone number.
- Keep `web/index.html` introduction and metadata aligned with your profile, and update `web/manifest.json` when changing the site name.
- Font files and their SIL Open Font Licenses are bundled under `assets/fonts/`.

## Structure

`domain` contains plain Dart models and repository contracts; `data` supplies bundled content and saved theme preferences; `presentation` contains the Cubit, page, and widgets. `main.dart` wires dependencies with `get_it`. `go_router` provides the page route; navigation between sections stays on the same page.

The layout switches at 600 and 900 logical pixels. Theme choice follows system appearance until changed, then persists in browser storage when available. Project artwork is illustrative; the cards are summaries without external project destinations.

## Checks and publishing

Tests, analysis, and release builds are run only when explicitly requested. The widget test covers portfolio rendering and navigation; theme tests cover serialized persistence and failure recovery.

For static hosting, publish the output of `flutter build web --release`. No backend is needed. The HTML introduction remains available while Flutter loads or when JavaScript is disabled; Flutter web still has search-indexing limitations.
