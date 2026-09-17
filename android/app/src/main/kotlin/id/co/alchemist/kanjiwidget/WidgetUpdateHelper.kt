package id.co.alchemist.kanjiwidget

import android.appwidget.AppWidgetManager
import android.content.Context
import android.widget.RemoteViews

object WidgetUpdateHelper {
    private const val PREFS_NAME = "widget_update_helper"

    /**
     * Full updateAppWidget() tears down and re-inflates the whole RemoteViews,
     * which launchers render as a visible blink on every refresh. After the
     * first render for a given widgetId, switch to partiallyUpdateAppWidget()
     * so only the changed views (the bitmap) are applied.
     */
    fun apply(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetId: Int,
        views: RemoteViews,
    ) {
        val prefs = context.getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE)
        val key = "rendered_$appWidgetId"

        if (prefs.getBoolean(key, false)) {
            appWidgetManager.partiallyUpdateAppWidget(appWidgetId, views)
        } else {
            appWidgetManager.updateAppWidget(appWidgetId, views)
            prefs.edit().putBoolean(key, true).apply()
        }
    }

    fun clear(context: Context, appWidgetId: Int) {
        val prefs = context.getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE)
        prefs.edit().remove("rendered_$appWidgetId").apply()
    }
}
