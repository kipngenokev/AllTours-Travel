# All-Tours 🧭

A cross-platform tourism app (iOS · Android · Web) built with **Flutter** and
**Supabase**. Tourists sign up, then discover where to go — either by the
**season** (best places to visit right now / by season, hemisphere-aware), by
**continent**, or by searching a **specific place**. Every destination has a
photo gallery, a **preview film**, best-time-to-visit guidance and travel
**guidelines**.

The visual design follows an editorial-luxury direction (inspired by Tomollo
Fashions): warm ivory grounds, near-black ink, a deep evergreen-teal primary
with a terracotta accent, an elegant serif display (Playfair) paired with a
clean sans (Inter), big imagery and minimal arrow CTAs.

---

## Features implemented

- **Auth** — email/password sign up & sign in (Supabase Auth); auto-created
  profile row; auth gate routes between Login and Home.
- **Seasonal suggestions** — "Best to visit now" uses today's month; the
  *By Season* picker maps Spring/Summer/Autumn/Winter to months, correctly
  shifted for each destination's hemisphere.
- **Browse by continent** — pick any of the 7 continents.
- **Search** — find a specific place by name or country (debounced).
- **Place detail** — swipeable photo carousel, tap-to-play preview video,
  best-season chips, tags, description and bulleted travel guidelines.
- **Responsive** — single column on phones, multi-column grids on web/tablet.

---

## Project layout

```
lib/
  config/app_config.dart      # Supabase creds via --dart-define
  theme/app_theme.dart        # editorial design system (colors, fonts)
  models/place.dart           # Place + PlaceMedia models
  services/
    auth_service.dart         # Supabase auth (ChangeNotifier)
    place_service.dart        # queries: season / month / continent / search
  utils/season.dart           # season <-> month <-> hemisphere logic
  widgets/                    # place_card, video_preview, ui (links/headers)
  screens/                    # auth/, home, season, continent, search, detail
supabase/
  schema.sql                  # tables, RLS, triggers, RPC
  seed.sql                    # 14 destinations across all continents
```

---

## Setup

### 1. Create the Supabase backend
1. Create a project at <https://supabase.com>.
2. Open **SQL Editor** and run [`supabase/schema.sql`](supabase/schema.sql),
   then [`supabase/seed.sql`](supabase/seed.sql).
3. (Optional) In **Authentication -> Providers -> Email**, turn *Confirm email*
   off for faster local testing.
4. Copy your **Project URL** and **anon public key** from
   **Settings -> API**.

### 2. Run the app
```bash
# Web
flutter run -d chrome \
  --dart-define=SUPABASE_URL=https://YOUR.supabase.co \
  --dart-define=SUPABASE_ANON_KEY=YOUR_ANON_KEY

# Android / iOS (device or emulator attached)
flutter run \
  --dart-define=SUPABASE_URL=https://YOUR.supabase.co \
  --dart-define=SUPABASE_ANON_KEY=YOUR_ANON_KEY
```

Without the `--dart-define` values the app boots into a **setup screen** with
these instructions instead of crashing.

> Tip: create a `run.sh` (git-ignored) holding the command above so you don't
> retype the keys.

---

## Notes on media

Seed images use `picsum.photos` seeds so the app renders out of the box; the
preview videos use Google's public sample bucket. Swap `cover_image_url`,
`video_url` and `place_media.url` for your own Unsplash / Supabase-Storage
URLs for production-quality visuals.

## Roadmap (next)

- Favorites/bookmarks (table + RLS already in `schema.sql`).
- Map view (lat/long are stored on every place).
- User profile screen & avatar upload to Supabase Storage.
- Social login (Google/Apple).
