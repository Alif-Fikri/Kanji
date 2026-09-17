package id.co.alchemist.kanjiwidget

import android.appwidget.AppWidgetManager
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.net.Uri
import es.antonborri.home_widget.HomeWidgetBackgroundIntent

class KanjiClockAlarmReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent) {
        val appWidgetManager = AppWidgetManager.getInstance(context)
        val widgetIds = appWidgetManager.getAppWidgetIds(
            android.content.ComponentName(context, KanjiClockWidgetProvider::class.java),
        )

        if (widgetIds.isNotEmpty()) {
            HomeWidgetBackgroundIntent.getBroadcast(
                context,
                Uri.parse("kanjiwidget://tick"),
            ).send()
            KanjiClockAlarmScheduler.scheduleNextMinute(context)
        }
    }
}
