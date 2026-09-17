package id.co.alchemist.kanjiwidget

import android.appwidget.AppWidgetManager
import android.os.Bundle

object WidgetSizeHelper {
    fun currentSizeDp(options: Bundle): Pair<Int, Int> {
        val minWidth = options.getInt(AppWidgetManager.OPTION_APPWIDGET_MIN_WIDTH, 0)
        val minHeight = options.getInt(AppWidgetManager.OPTION_APPWIDGET_MIN_HEIGHT, 0)
        val maxWidth = options.getInt(AppWidgetManager.OPTION_APPWIDGET_MAX_WIDTH, 0)
        val maxHeight = options.getInt(AppWidgetManager.OPTION_APPWIDGET_MAX_HEIGHT, 0)

        val width = if (minWidth > 0) minWidth else maxWidth
        val height = if (minHeight > 0) minHeight else maxHeight

        return Pair(
            if (width > 0) width else 180,
            if (height > 0) height else 90,
        )
    }
}
