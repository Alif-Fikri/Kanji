# Play Store Listing Draft — Koyomi

## App name (max 30 char)
Koyomi: Kanji Widgets

(21/30 karakter.)

## Short description (max 80 char)
Japanese clock, daily kanji and quote widgets for your home screen.

(68/80 karakter.)

## Full description (max 4000 char)

Koyomi (暦) brings a Japanese aesthetic to your Android home screen. Three
home screen widgets — a clock, a daily kanji, and a daily quote — each
rendered in kanji, with the font, colour and background you choose.

🕐 KANJI CLOCK
Time and date written in kanji numerals (十四時三十分, 九月十八日). Choose
kanji or plain numbers, 12- or 24-hour format, show or hide the date and
weekday, and pick from four Japanese fonts.

字 DAILY KANJI
A new kanji every day — meaning, onyomi and kunyomi reading — picked from
a set of common JLPT N5 kanji. Not feeling today's pick? Shuffle for
another; it still changes on its own again tomorrow.

言 DAILY QUOTE
A Japanese proverb or idiom every day, with an English translation you can
show or hide. Same daily rotation and Shuffle button as Daily Kanji.

🎨 MAKE IT YOURS
Every widget is configured on its own — place as many as you like, each
with its own font, text colour, and background. Six ready-made templates
(Washi, Sumi Night, Sakura, Ai, Shu, Mist) apply a complete look in one
tap, or pick any of 32 colours by hand. Backgrounds can be turned off
entirely for a transparent widget that sits directly on your wallpaper.

📐 RESIZES LIKE ANY OTHER WIDGET
Drag a widget's edges on your home screen and its content scales to fit —
no fixed size, no cropped text.

✨ FEATURES
- Three widgets: Kanji Clock, Daily Kanji, Daily Quote
- Each widget configured independently — place several, all different
- Four Japanese fonts: Noto Sans JP, Kosugi, Kosugi Maru, Shippori Mincho
- 32-colour palette for text and background, or six one-tap templates
- Transparent background option
- Kanji or plain numerals, 12/24-hour, weekday, seconds — for the clock
- Daily kanji and quote rotate automatically; Shuffle for another pick
- Fully offline, no account, no data collected

Koyomi is free, with no ads and no in-app purchases.

Download Koyomi and bring a little Japan to your home screen.

---

## Release notes (Play Console — "What's new")

v1.0.0 (en-US)
First release of Koyomi!
- Kanji Clock, Daily Kanji and Daily Quote widgets
- Configure each placed widget independently
- Six one-tap style templates plus a 32-colour palette
- Transparent widget background option
- Widgets resize to fit whatever size you set on your home screen
- Shuffle button for today's kanji or quote
- Fully offline, no account, no ads

v1.0.0 (id-ID)
Rilis pertama Koyomi!
- Widget Kanji Clock, Daily Kanji, dan Daily Quote
- Tiap widget yang dipasang bisa diatur sendiri-sendiri
- Enam template tampilan sekali tap plus palet 32 warna
- Opsi background transparan
- Widget menyesuaikan ukuran mengikuti resize di home screen
- Tombol Shuffle untuk kanji/quote hari ini
- Sepenuhnya offline, tanpa akun, tanpa iklan

---

## Catatan pengisian Play Console

### App info
- Package name: `id.co.alchemist.kanjiwidget` — Android `applicationId` dan
  `namespace` sudah sama. **Tidak bisa diubah setelah rilis pertama.**
- Launcher label: `Koyomi`
- Version: cek `pubspec.yaml` (`version: 1.0.0+1`) — naikkan build number
  tiap upload ke Play Console
- Icon listing 512×512: `store_assets/play_store_icon_512.png`
- Feature graphic 1024×500: `store_assets/feature_graphic_1024x500.png`
  (PNG RGB tanpa alpha, sesuai syarat Play Console)
- Regenerate semuanya dengan: `python3 scripts/generate_store_assets.py`
  (butuh raw capture baru di `store_assets/screenshots/raw/` kalau UI
  berubah — lihat komentar di kepala script)

### Categorization
- App or game: **App**
- Category: **Personalization** (atau **Tools**, keduanya relevan untuk
  app widget home screen)
- Tags yang cocok: Widgets, Japanese, Kanji, Clock, Personalization

### Data safety form
- Data pribadi yang dikumpulkan: **tidak ada**. Semua pengaturan
  (`WidgetConfig` per widget) disimpan lokal via Hive, tidak ada
  server/backend, tidak ada analytics, tidak ada SDK iklan.
- "Does your app contain ads?" → **No**
- Tidak perlu declare third-party SDK data collection apa pun

### Content rating
- Perkiraan hasil: **Everyone / PEGI 3** — widget utilitas, tanpa
  kekerasan, konten dewasa, atau iklan
- Jawab "No" untuk semua kategori konten sensitif

### PENTING sebelum submit ke production

1. **Privacy Policy URL** — Play Console tetap mewajibkan link ini meski
   app tidak mengumpulkan data. Buat halaman singkat yang menyatakan itu
   (mis. GitHub Pages) dan tempel URL-nya di App content → Privacy policy.
2. **Keystore backup** — `~/AndroidKeystores/alchemist-release.jks`
   dipakai bersama oleh semua app Alchemist. Pastikan file dan
   `android/key.properties` (isi passwordnya) di-backup di tempat lain
   selain mesin ini. Kehilangan keystore berarti tidak bisa update app
   ini di Play selamanya.
3. **`pubspec.yaml` description** — masih placeholder default Flutter
   ("A new Flutter project."). Ganti sebelum submit.
4. **Battery optimization** — widget clock/daily update lewat
   `AlarmManager` per menit/tengah malam. Beberapa OEM (Xiaomi, Oppo,
   Vivo, Huawei) membunuh alarm background kecuali user whitelist app
   secara manual dari pengaturan baterai mereka. Belum ada UI di app ini
   yang meminta izin itu — pertimbangkan menambahkannya atau jelaskan di
   deskripsi/FAQ kalau widget berhenti update di HP tertentu.
5. **Belum pernah dites di device fisik** — App Bundle release ini sudah
   diverifikasi jalan di emulator (release build, signed, minified,
   ProGuard rules teruji tidak merusak `home_widget`/WorkManager), tapi
   font rendering, sentuhan, dan battery drain sesungguhnya baru bisa
   dipastikan di HP asli.

### Build untuk upload

```bash
flutter build appbundle --release
```

Output: `build/app/outputs/bundle/release/app-release.aab` — ini yang
diupload ke Play Console, bukan file `.apk`. Ukuran bundle ~40MB, tapi
Play mengirim split per-device sekitar 15–20MB (terverifikasi lewat
`flutter build apk --release --split-per-abi`: arm64 17.9MB).

### Screenshots

Play Console minta minimal 2 screenshot phone, maksimal 8.

Raw capture ada di `store_assets/screenshots/raw/` (home, gallery, quote,
placed — status bar sudah di-crop). Untuk capture ulang setelah UI
berubah: screenshot dari emulator/device, crop ~3% dari atas untuk buang
status bar, simpan dengan nama yang sama, lalu jalankan generator lagi.

Output: `store_assets/screenshots/android-phone/promo_*.png` — 1080×1920.

Urutan slide: widget di home screen (bukti nyata jalan), galeri +
template, isi Daily Quote, lalu widget live lagi sebagai penutup.
