package com.android.focus.notifications;

import android.app.AlarmManager;
import android.app.PendingIntent;
import android.content.Context;
import android.content.Intent;
import android.content.res.Resources;
import android.os.Build;
import android.support.v4.app.NotificationCompat;

import com.android.focus.FocusApp;
import com.android.focus.LoadingActivity;
import com.android.focus.R;
import com.android.focus.model.Encuesta;
import com.android.focus.model.Panel;
import com.android.focus.utils.DateUtils;

import java.util.Calendar;
import java.util.Date;
import java.util.List;

import static android.content.Intent.CATEGORY_DEFAULT;
import static com.android.focus.notifications.NotificationListenerService.NOTIFICATION;
import static com.android.focus.notifications.NotificationListenerService.NOTIFICATION_ID;

public class NotificationManager {

    private static final String DISPLAY_NOTIFICATION = "android.media.action.DISPLAY_NOTIFICATION";

    public static void scheduleNotifications() {
        List<Encuesta> pendingSurveys = Panel.getPendingSurveys();

        Context context = FocusApp.getContext();

        for (Encuesta pendingSurvey : pendingSurveys) {
            int pendingSurveyId = pendingSurvey.getId();
            PendingIntent contentIntent = PendingIntent.getActivity(context, pendingSurveyId, new Intent(context, LoadingActivity.class), PendingIntent.FLAG_UPDATE_CURRENT);
            Intent notificationIntent = getNotificationIntent(pendingSurvey, context, contentIntent);
            PendingIntent broadcast = PendingIntent.getBroadcast(context, pendingSurveyId, notificationIntent, PendingIntent.FLAG_UPDATE_CURRENT);
            Date fireDate = getNotificationFireDate(pendingSurvey.getFechaFin());

            if (fireDate.after(DateUtils.getNow())) {
                scheduleNotification(broadcast, fireDate.getTime());
            }
        }
    }

    private static Intent getNotificationIntent(Encuesta pendingSurvey, Context context, PendingIntent contentIntent) {
        Resources resources = FocusApp.getAppResources();
        String message = resources.getString(R.string.notification_text, pendingSurvey.getNombre());

        Intent notificationIntent = new Intent(DISPLAY_NOTIFICATION);
        notificationIntent.addCategory(CATEGORY_DEFAULT);

        NotificationCompat.Builder builder = new NotificationCompat.Builder(context)
                .setAutoCancel(true)
                .setColor(resources.getColor(R.color.bluePrimary))
                .setContentTitle(resources.getString(R.string.notification_title))
                .setContentText(message)
                .setContentIntent(contentIntent)
                .setLocalOnly(true)
                .setShowWhen(false)
                .setSmallIcon(R.drawable.ic_notification)
                .setStyle(new NotificationCompat.BigTextStyle().bigText(message));

        notificationIntent.putExtra(NOTIFICATION, builder.build());
        notificationIntent.putExtra(NOTIFICATION_ID, pendingSurvey.getId());

        return notificationIntent;
    }

    private static Date getNotificationFireDate(Date endDate) {
        Calendar calendar = DateUtils.getCalendar(endDate);
        calendar.add(Calendar.DAY_OF_MONTH, -3);
        calendar.set(Calendar.HOUR_OF_DAY, 10);

        return calendar.getTime();
    }

    private static void scheduleNotification(PendingIntent broadcast, long fireTime) {
        AlarmManager alarmManager = getAlarmManager();

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.KITKAT) {
            alarmManager.setExact(AlarmManager.RTC_WAKEUP, fireTime, broadcast);
        } else {
            alarmManager.set(AlarmManager.RTC_WAKEUP, fireTime, broadcast);
        }
    }

    private static AlarmManager getAlarmManager() {
        return (AlarmManager) FocusApp.getContext().getSystemService(Context.ALARM_SERVICE);
    }
}
