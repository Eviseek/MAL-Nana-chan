# MAL Nana-chan

An iOS client for [MyAnimeList](https://myanimelist.net) — browse seasonal anime, search
anime and manga, and manage your own list. Built with **UIKit**.

The app was originally written in 2023. I recently refactored it with
[Claude Code](https://claude.com/claude-code) — restructuring it into the layers below,
moving navigation out of the view models and cells into coordinators, putting each
capability behind a protocol, and adopting Swift 6. The process also turned up 23 real
bugs, five of them crashes.

[`REFACTOR_NOTES.md`](REFACTOR_NOTES.md) has the details: what changed, why each choice was
made, and every bug that was fixed.

Coming next: a test suite, and a redesign of the storyboard-driven UI.

## Features

- Home: current and upcoming season anime, plus a popularity ranking
- Explore: community recommendations and popular manga
- Search anime and manga, with paging
- Detail screens: synopsis, genres, related titles, studios, theme songs
- Sign in with MyAnimeList (OAuth 2.0 + PKCE) and edit your list — status, score,
  progress, priority

## Built with

- **UIKit** — storyboards, nibs, programmatic layout
- **MVVM + coordinators** — view models hold no reference to their views; navigation is
  owned by a coordinator
- **Swift 6** language mode, iOS 17+
- **Alamofire** for networking, **KeychainAccess** for token storage, plus SkeletonView,
  NVActivityIndicatorView and the YouTube player helper
- [MyAnimeList API v2](https://myanimelist.net/apiconfig/references/api/v2) for the data,
  with [Jikan](https://jikan.moe) filling in what it doesn't expose

Structure: `Screens/` `Models/` `Services/` `Library/` `Resources/` — 17 screens and 9
service protocols across ~115 Swift files.

## Running it

Needs Xcode 16 or newer (the project uses filesystem-synchronized folder groups).

```sh
cp Config/Secrets.example.xcconfig Config/Secrets.xcconfig
```

Then paste a client id from [MyAnimeList's API config](https://myanimelist.net/apiconfig)
into that file and run. Without it the app builds but stops at launch with a message
telling you which file to fill in.
