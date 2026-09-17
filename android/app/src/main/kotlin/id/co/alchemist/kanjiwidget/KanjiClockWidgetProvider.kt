package id.co.alchemist.kanjiwidget

import android.appwidget.AppWidgetManager
import android.content.Context
import android.content.SharedPreferences
import android.graphics.BitmapFactory
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetLaunchIntent
import es.antonborri.home_widget.HomeWidgetProvider

class KanjiClockWidgetProvider : HomeWidgetProvider() {

    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray,
        widgetData: SharedPreferences,
    ) {
        appWidgetIds.forEach { widgetId ->
            val views = RemoteViews(context.packageName, R.layout.kanji_clock_widget).apply {
                val pendingIntent =
                    HomeWidgetLaunchIntent.getActivity(context, MainActivity::class.java)
                setOnClickPendingIntent(R.id.kanji_clock_widget_root, pendingIntent)

                val imagePath = widgetData.getString("kanji_clock_image", null)
                if (imagePath != null) {
                    setImageViewBitmap(
                        R.id.kanji_clock_widget_image,
                        BitmapFactory.decodeFile(imagePath),
                    )
                }
            }
            appWidgetManager.updateAppWidget(widgetId, views)
        }
    }

    override fun onEnabled(context: Context) {
        super.onEnabled(context)
        KanjiClockAlarmScheduler.scheduleNextMinute(context)
    }

    override fun onDisabled(context: Context) {
        super.onDisabled(context)
        KanjiClockAlarmScheduler.cancel(context)
    }
}
