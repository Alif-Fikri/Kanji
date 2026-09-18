# Flutter and Play Core reflectively reference these; R8 cannot see the links.
-dontwarn io.flutter.embedding.**
-keep class io.flutter.** { *; }

# home_widget schedules its background callback via a WorkManager Worker
# (HomeWidgetBackgroundWorker), which WorkManager instantiates by class name
# through reflection. R8 renaming or stripping it crashes the per-minute /
# per-midnight widget refresh with a silent WorkManager failure.
-keep class es.antonborri.home_widget.** { *; }
-dontwarn es.antonborri.home_widget.**

# WorkManager (used above) persists its queue with Room, which looks up its
# generated *_Impl classes by name at runtime; stripping them crashes
# startup with "Failed to create an instance of androidx.work.impl.WorkDatabase".
-keep class androidx.work.** { *; }
-keep class * extends androidx.room.RoomDatabase
-keep @androidx.room.Entity class * { *; }
-dontwarn androidx.work.**

# AppWidgetProvider / BroadcastReceiver subclasses declared in the manifest
# are already kept by AGP's merged-manifest rules, but the widget breaks
# completely if one slips through, so keep them explicitly too.
-keep class id.co.alchemist.kanjiwidget.** { *; }
