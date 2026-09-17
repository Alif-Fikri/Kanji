package id.co.alchemist.kanjiwidget

import android.appwidget.AppWidgetManager
import android.content.Context
import android.content.SharedPreferences
import android.graphics.BitmapFactory
import android.net.Uri
import android.os.Bundle
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetBackgroundIntent
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
                val pendingIntent = HomeWidgetLaunchIntent.getActivity(
                    context,
                    MainActivity::class.java,
                    Uri.parse("kanjiwidget://edit?widgetId=$widgetId&kind=clock"),
                )
                setOnClickPendingIntent(R.id.kanji_clock_widget_root, pendingIntent)

                val imagePath = widgetData.getString("clock_image_$widgetId", null)
                    ?: widgetData.getString("clock_image", null)
                if (imagePath != null) {
                    setImageViewBitmap(
                        R.id.kanji_clock_widget_image,
                        BitmapFactory.decodeFile(imagePath),
                    )
                }
            }
            WidgetUpdateHelper.apply(context, appWidgetManager, widgetId, views)
        }
    }

    override fun onAppWidgetOptionsChanged(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetId: Int,
        newOptions: Bundle,
    ) {
        super.onAppWidgetOptionsChanged(context, appWidgetManager, appWidgetId, newOptions)
        val (widthDp, heightDp) = WidgetSizeHelper.currentSizeDp(newOptions)
        HomeWidgetBackgroundIntent.getBroadcast(
            context,
            Uri.parse(
                "kanjiwidget://resized?widgetId=$appWidgetId&kind=clock" +
                    "&widthDp=$widthDp&heightDp=$heightDp",
            ),
        ).send()
    }

    override fun onDeleted(context: Context, appWidgetIds: IntArray) {
        super.onDeleted(context, appWidgetIds)
        appWidgetIds.forEach { WidgetUpdateHelper.clear(context, it) }
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
