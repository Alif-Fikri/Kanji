package id.co.alchemist.kanjiwidget

import android.appwidget.AppWidgetManager
import android.content.BroadcastReceiver
import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.net.Uri
import es.antonborri.home_widget.HomeWidgetBackgroundIntent

class DailyKanjiAlarmReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent) {
        val appWidgetManager = AppWidgetManager.getInstance(context)
        val widgetIds = appWidgetManager.getAppWidgetIds(
            ComponentName(context, DailyKanjiWidgetProvider::class.java),
        )

        if (widgetIds.isNotEmpty()) {
            HomeWidgetBackgroundIntent.getBroadcast(
                context,
                Uri.parse("kanjiwidget://daily-tick"),
            ).send()
            DailyKanjiAlarmScheduler.scheduleNextMidnight(context)
        }
    }
}
