package com.outrepd.outrepd

import android.appwidget.AppWidgetManager
import android.content.Context
import android.content.SharedPreferences
import android.widget.RemoteViews
import java.text.SimpleDateFormat
import java.util.Date
import java.util.Locale
import es.antonborri.home_widget.HomeWidgetLaunchIntent
import es.antonborri.home_widget.HomeWidgetProvider

/**
 * The home-screen widgets. Neither works anything out: the app saves the
 * words and numbers already written (lib/home_widgets.dart), in the reader's
 * language, and these only put them on the card. A tap opens the app.
 */
private fun fillGoal(views: RemoteViews, data: SharedPreferences) {
    // Past midnight the count is for a day that is over: a fresh ring until
    // the app writes today's.
    val today = SimpleDateFormat("yyyy-MM-dd", Locale.US).format(Date())
    val current = data.getString("goal_day", "") == today
    views.setProgressBar(
        R.id.goal_ring,
        100,
        if (current) data.getString("goal_percent", "0")?.toIntOrNull() ?: 0 else 0,
        false,
    )
    views.setTextViewText(
        R.id.goal_count, if (current) data.getString("goal_count", "0") else "0",
    )
    views.setTextViewText(
        R.id.goal_of,
        data.getString(if (current) "goal_of" else "goal_of_fresh", ""),
    )
    views.setTextViewText(R.id.streak, data.getString("streak", ""))
}

class OutrepdSmallWidget : HomeWidgetProvider() {
    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray,
        widgetData: SharedPreferences,
    ) {
        for (id in appWidgetIds) {
            val views = RemoteViews(context.packageName, R.layout.outrepd_widget_small)
            fillGoal(views, widgetData)
            views.setOnClickPendingIntent(
                R.id.widget_root,
                HomeWidgetLaunchIntent.getActivity(context, MainActivity::class.java),
            )
            appWidgetManager.updateAppWidget(id, views)
        }
    }
}

class OutrepdMediumWidget : HomeWidgetProvider() {
    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray,
        widgetData: SharedPreferences,
    ) {
        for (id in appWidgetIds) {
            val views = RemoteViews(context.packageName, R.layout.outrepd_widget_medium)
            fillGoal(views, widgetData)
            views.setTextViewText(R.id.rank, widgetData.getString("rank", ""))
            views.setTextViewText(R.id.lp, widgetData.getString("lp", ""))
            views.setProgressBar(
                R.id.lp_bar,
                100,
                widgetData.getString("lp_percent", "0")?.toIntOrNull() ?: 0,
                false,
            )
            views.setOnClickPendingIntent(
                R.id.widget_root,
                HomeWidgetLaunchIntent.getActivity(context, MainActivity::class.java),
            )
            appWidgetManager.updateAppWidget(id, views)
        }
    }
}
