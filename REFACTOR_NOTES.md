# Architecture notes

How the app is put together after the structural refactor, why each choice was
made, and what was fixed on the way. Written to be read top to bottom once.

## Folder structure

```
MAL Nana-chan/
├── App/          AppDelegate, SceneDelegate, AppCoordinator — launch and wiring
├── Screens/      one folder per screen: ViewController + ViewModel
├── Models/       MAL/, Jikan/ (API shapes) · App/ (view-facing) · Enums/
├── Services/     Networking/ + one folder per capability, each behind a protocol
├── Library/      Coordinators/ Constants/ Extensions/ Helpers/ Styling/ Views/
└── Resources/    storyboards, Assets.xcassets, Info.plist
```

The Xcode project now uses a **filesystem-synchronized root group** (Xcode 16+,
`objectVersion = 77`). The folder tree on disk *is* the project structure — files
are no longer listed one by one in `project.pbxproj`. Two consequences worth
knowing:

- Adding or moving a file needs no project-file edit, so the structure can't drift
  from what Xcode compiles.
- It requires Xcode 16 or newer to open. `Resources/Info.plist` is registered as a
  membership exception, because otherwise the synchronized group would also copy it
  into the bundle as a resource and the build would fail with two commands
  producing `Info.plist`.

## MVVM

Every screen is `XViewController` + `XViewModel`. The rule that matters: **the view
model has no reference to the view controller and does not import UIKit for view
work.**

Before, view models held their view controller and called methods on it
(`vc.setUpErrorView(…)`, `vc.reloadData()`, `vc.showLoggedView()`). That made them
untestable, created a retain cycle risk, and — because "loading", "error" and
"content" were separate method calls — allowed a screen to show a spinner over an
error label above a populated table.

Now a view model publishes one value:

```swift
enum ViewState<Content> {
    case loading
    case content(Content)
    case empty(String)
    case failure(String)
}
```

The view controller subscribes with `onStateChange` and renders with a single
`switch`. States are exclusive by construction, and a case a screen forgets to
handle is a compile error.

**Why closures rather than Combine or `@Observable`?** The deployment target is
iOS 16, so both were options. Closures need no new framework, read the same in
every file, and are trivial to fake in a test. If this app moves to SwiftUI later,
`@Observable` becomes the natural choice — the `ViewState` shape ports directly.

View models also expose *intent* closures (`onOpenMedia`, `onOpenListSheet`) rather
than performing navigation. The view controller forwards those to the coordinator.

Two screens deliberately have **no** view model: `RecommendationDetailViewController`
(no state, no network — everything it shows arrives in one value) and
`SettingsViewController` (empty placeholder). A view model that only forwards
properties is ceremony, and ceremony makes an architecture feel arbitrary.

## Coordinators

`MediaCoordinator` owns all navigation on the main stack. `AppCoordinator` builds
the window, the tab bar, and injects each tab's dependencies.

The old code navigated from inside view models *and* from inside table view cells:

```swift
if let controller = vc?.storyboard?
    .instantiateViewController(withIdentifier: "AnimeDetailViewController")
    as? AnimeDetailViewController {
    controller.id = id
    vc?.navigationController?.pushViewController(controller, animated: true)
}
```

Four problems, all structural: the view model needs its view controller to reach
`storyboard`; the destination is a string, so a typo compiles and the `as?` then
silently does nothing (a button that appears broken); every screen has to know how
every screen it can reach is *constructed*, dependencies included; and cells did it
too, so the routing for one screen was spread across three kinds of file.

`Main.storyboard` still defines the layout, but it no longer *starts* the app —
`UISceneStoryboardFile` and `INFOPLIST_KEY_UIMainStoryboardFile` were removed so
`SceneDelegate` → `AppCoordinator` owns the window. That is the only way
storyboard-instantiated screens can be handed their services, since a storyboard
can only call a no-argument initialiser.

**One coordinator, not one per screen.** Every destination shares one navigation
controller and one dependency set; a tree of tiny coordinators would add
indirection without adding a seam. If a section later grows its own flow, it can be
split out behind the `Coordinator` protocol.

## Services

Each capability is a protocol plus one implementation:

| Protocol | Does |
|---|---|
| `APIClienting` | sends `Endpoint`s, decodes, maps errors |
| `AnimeServicing` / `MangaServicing` | reads and list writes for each media type |
| `DiscoveryServicing` | the Jikan extras: recommendations, credits, theme songs |
| `UserProfileServicing` | `/users/@me` |
| `AuthenticationServicing` | OAuth sign-in / sign-out |
| `TokenStoring` | keychain token, expiry checking |
| `ReachabilityObserving` | multicast "connection restored" |
| `RecentSearchesStoring` | recent search terms |

`ServiceContainer.live()` builds the graph once in `AppDelegate`. Previously each
type reached for a singleton (`DataDownloader.dataDownloader`,
`TokenHandler.handler`, `NetworkManager.shared`) or made its own instance inline,
so nothing could be tested and lifetime was invisible.

Jikan is kept behind its own protocol on purpose: it is a third-party scraper with
independent uptime, and it must never receive MAL credentials.

### Requests are data now

`Endpoint` replaces the old `URLs: String` enum, whose cases were whole URLs with
`{id}` / `{query}` / `{season}` placeholders that call sites filled in with
`replacingOccurrences`. That gave no encoding (a search term with `&` or `+` broke
the query string), no type safety (a forgotten placeholder produced a literal
`{id}` and a 404), and authorisation decided by `url.contains("myanimelist")`. Each
endpoint now states which credential it needs, and every parameter is
percent-encoded with a character set that excludes the sub-delimiters
(`& + = ? #`) that would end a value early.

`APIError` replaces `AFError` at the service boundary, so screens neither import
Alamofire nor show the user text like *"Response status code was unacceptable: 401"*.

## Configuration and secrets

The MyAnimeList client id is no longer in source. The chain is:

```
Config/Secrets.xcconfig   (git-ignored)  MAL_CLIENT_ID = …
        ↓ #include?
Config/App.xcconfig       (committed, base config of both app configurations)
        ↓ $(MAL_CLIENT_ID)
Resources/Info.plist       MALClientID
        ↓ Bundle.main.requiredConfigurationValue(.malClientID)
AppConfiguration.MyAnimeList.clientID
```

MAL's OAuth flow uses PKCE and has no client secret, so the id is a public
identifier rather than a credential — nobody gains anything from reading it. It is
still worth keeping out of the repo: rotating it becomes a config change instead of
a code change, and nobody has to reason about which committed strings are safe.

`#include?` (with the question mark) does not error on a missing file, so a fresh
clone still configures and builds. It fails at first launch instead, with a message
naming the file to copy. Verified both ways: with the file present the app loads
live MAL data; with it moved aside the build still succeeds, `MALClientID` resolves
to an empty string, and launch stops with

> Missing configuration value 'MALClientID'. Copy Config/Secrets.example.xcconfig
> to Config/Secrets.xcconfig and fill in your MyAnimeList client id…

Setup for a new checkout:

```sh
cp Config/Secrets.example.xcconfig Config/Secrets.xcconfig
# then paste the id from https://myanimelist.net/apiconfig
```

## Shared view models for lists

`MediaPreview` is one anime-or-manga reduced to what a row shows, with
`Anime.preview` / `Manga.preview` doing the mapping. Nine list surfaces used to
repeat the same twenty lines inside `cellForRowAt` — unwrap the node, format the
score, build the season string, pick singular/plural, build a `URL`, set the image
— and each cell held an `Anime`, a `UIViewController` and sometimes a `UIStoryboard`
so it could navigate itself. Cells now assign pre-formatted strings and report taps
through closures.

This also let `SeeAllViewController`/`SeeAllViewModel` stop being generic over
`T: Codable`. The media kind is a value, not a type parameter.

Cell registration goes through `ReusableCell`, which derives the reuse identifier
from the class name. The hand-maintained identifier list had already drifted:
`Identifiers.mangaCVCell` read `"MangaSectionCollectionViewCell"` while the class
and nib were both `MangaCollectionViewCell`.

## Bugs found and fixed

Crashes:

1. **Anime detail, related manga** — the strip registered the anime cell's nib but
   dequeued the (stale, wrong) manga identifier, which raises
   `NSInternalInconsistencyException`. Any anime with related manga crashed.
2. **Explore recommendations** — row count was `1 + recommendations.count` while
   rows ≥ 1 read `recommendations[indexPath.row]`. The first recommendation was
   never shown, and at ten or more loaded, row 10 indexed element 10 of a
   ten-element array.
3. **Home retry** — `contentSize` was `+=`'d on every load without being reset, and
   sections were appended rather than replaced, so a second "try again" made
   `numberOfRows` exceed the data.
4. **Recommendation pairs** — `entry[0]` / `entry[1]` were indexed unchecked in four
   places; a malformed pair from Jikan would crash.
5. **Home trailer** — `data[0]` on a possibly empty array.

Silent wrong behaviour:

6. **Manga list progress** — `Float(read / total)` is integer division, so partial
   progress always displayed as 0.
7. **Manga volumes bar** — the volumes branch wrote into `chaptersProgressView`.
8. **Manga priority** — the sheet's picker updated a local value that the request
   body never included, so priority was never saved.
9. **Failed saves looked successful** — both sheets printed the error and dismissed
   regardless, so the user believed a failed change had been stored.
10. **Profile birthday** — parsed with `"yyyy-mm-dd"`; lowercase `mm` is *minutes*,
    so every birthday rendered as "Not specified."
11. **"Try again" on anime detail** — guarded on `anime?.title != nil`, i.e. it only
    retried once the data had already loaded. On the one state where the button is
    visible, it did nothing. The reachability handler had the same inverted test.
12. **Reconnect handling** — `NetworkManager` had a single `weak var delegate` that
    five view models assigned themselves to, so only the last screen loaded ever
    heard about a reconnect. Now a multicast observer list.
13. **Animelist paging** — `isFetching` was set inside the fetch but checked by the
    caller, and the rejecting path never called its completion, so the flag stuck at
    `true` and paging stopped for the session.
14. **Shared `DateFormatter`** — one instance whose `dateFormat` every call site
    reassigned, mutated from network completion handlers. Now one immutable
    formatter per format, behind a lock, pinned to POSIX locale and UTC.
15. **Loading spinner** — a singleton with one overlay property; a second
    `startAnimating` orphaned the first overlay with nothing holding a reference to
    remove it, leaving the screen blanked. `stopAnimating` also hid on a 1-second
    timer regardless of caller.
16. **Poster skeleton** — `AnimeCollectionViewCell.awakeFromNib` called
    `contentView.showSkeleton()` and nothing ever hid it, so every poster in the app
    was under a permanent shimmer.
17. **"My list" chip visibility** — read from a global in `awakeFromNib`, which runs
    once per cell *creation*, so cells recycled after sign-in kept the chip hidden.
18. **Manga detail** — set-up called `removeFromSuperview()` on the related-anime,
    related-manga and recommendations containers unconditionally. The data was being
    fetched and thrown away. Both detail screens now hide (reversibly) instead.
19. **OAuth handler ordering** — `authorizeURLHandler` was assigned *after*
    `authorize`, so the first sign-in of a launch didn't use the Safari sheet.
20. **Failed sign-in looked successful** — the completion fired on both paths and the
    screen popped either way.
21. **Explore recent searches** — the comment said "delete if longer than a week",
    the code cleared after one day; new terms were appended to the end and duplicates
    ignored, so the list read oldest-first.
22. **Anime episode duration** — MAL sends `0` for unknown; the screen printed "0".
23. Silent failures: the anime search branch discarded its error entirely
    (`_: AFError?`); `MangaDetailViewModel` had `//TODO: show error`;
    `MoreInformationViewController.showErrorView` had an empty body. All three left a
    spinner on a blank screen.

Also removed: a **leaked JWT access token** sitting in a comment block in
`AuthenticationHandler.swift`, a stray `Authentication().authenticate()` firing an
unused request on every Home load, the dead `MyInterceptor` stub, unused models
(`Item`, `Token`, `PersonBase`, `RelatedAnimeEdge`, …), and the dead
`SeeAllViewController` storyboard scene (whose `tableView` outlet no longer matched
the class — a trap for whoever tried to use it).

## Deliberate behaviour changes

Two, both flagged rather than slipped in:

- **Home's third row** was a hardcoded "Winter 2020 anime" section (test
  scaffolding: `let selectedSeason: Season = .winter; let selectedYear = 2020`). It
  is now "Popular anime", using the ranking endpoint that already existed in the old
  URL list but was never called.
- **Theme songs work again.** They were sourced from Jikan's `/anime/{id}/themes`,
  which answers 504, and the screen showed a hardcoded "temporarily unavailable".
  `/anime/{id}/full` returns 200 and already carries `theme.openings` /
  `theme.endings`, so the screen reads from there.

Home also no longer fails as a whole when one request fails: each section has its
own result slot, and the screen shows whatever loaded. A Jikan outage can't blank the
MAL sections any more.

## Verification

- `xcodebuild clean build-for-testing` succeeds for the app and both test targets,
  with **no Swift warnings**.
- Every `<outlet>` and `<action>` in `Main.storyboard` and all 13 `.xib`s was checked
  against the owning class — a connection to a property that no longer exists fails
  KVC and crashes at load, which the compiler cannot catch. All resolve.
- Every `SceneIdentifier` resolves to a scene whose `customClass` matches the type
  the coordinator casts to.
- The app launches on an iPhone 16 simulator and Home renders live MAL data.

Not verified: interactive navigation past Home. Driving the UI needs Python 3.10+
for the simulator tooling and this machine has 3.9, so the coordinator's push paths
were checked statically (identifier, class, and outlet resolution) rather than by
tapping through. **No tests were written** — per your standing preference, ask if you
want them; the service protocols now make the view models straightforward to test.
