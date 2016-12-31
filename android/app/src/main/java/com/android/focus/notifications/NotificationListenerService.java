package com.android.focus.notifications;

import android.app.Notification;
import android.app.NotificationManager;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;

import com.android.focus.ToolbarActivity;

public class NotificationListenerService extends BroadcastReceiver {

    public static final String NOTIFICATION = "notification";
    public static final String NOTIFICATION_ID = "notification-id";

    @Override
    public void onReceive(Context context, Intent intent) {
        // If app is in foreground, don't display notification.
        if (!ToolbarActivity.isAppInBackground()) {
            return;
        }

        // Display notification.
        Notification notification = intent.getParcelableExtra(NOTIFICATION);
        NotificationManager notificationManager = (NotificationManager) context.getSystemService(Context.NOTIFICATION_SERVICE);

        if (notification != null) {
            notificationManager.notify(intent.getIntExtra(NOTIFICATION_ID, 0), notification);
        }
    }
}
