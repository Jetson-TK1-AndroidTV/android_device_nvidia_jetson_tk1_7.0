/*
 * Copyright (C) 2014 The Android Open Source Project
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package com.google.android.leanbacklauncher.partnercustomizer;

import android.app.Activity;
import android.app.Notification;
import android.app.NotificationManager;
import android.app.PendingIntent;
import android.content.BroadcastReceiver;
import android.content.ComponentName;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.content.pm.ActivityInfo;
import android.content.pm.ApplicationInfo;
import android.content.pm.PackageInfo;
import android.content.pm.PackageManager;
import android.content.pm.ResolveInfo;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.net.Uri;
import android.os.AsyncTask;
import android.os.Bundle;
import android.os.Handler;
import android.provider.Settings;
import android.text.TextUtils;

import java.io.IOException;
import java.io.InputStream;
import java.net.HttpURLConnection;
import java.util.ArrayList;
import java.util.List;

/**
 * This class posts notifications that are used to populate the Partner Row of the Leanback Launcher
 * It also allows the system/launcher to find the correct partner customization
 * package.
 *
 * Packages using this broadcast receiver must also be a system app to be used for
 * partner customization.
 */
public class PartnerReceiver extends BroadcastReceiver {
    private static final String ACTION_PARTNER_CUSTOMIZATION =
            "com.google.android.leanbacklauncher.action.PARTNER_CUSTOMIZATION";

    private static final String EXTRA_ROW_WRAPPING_CUTOFF =
            "com.google.android.leanbacklauncher.extra.ROW_WRAPPING_CUTOFF";

    private static final String PARTNER_GROUP = "partner_row_entry";
    private static final String BLACKLIST_PACKAGE = "com.google.android.leanbacklauncher.replacespackage";

    private static final String LIVE_TV_PKG_NAME = "com.android.tv";

    private Context mContext;
    private NotificationManager mNotifMan;
    private PackageManager mPkgMan;

    // Cutoff value for when the Launcher displayes the Partner row as a single
    // row, or a two row grid. Can be used for correctly positioning the partner
    // app entries.
    private int mRowCutoff = 0;

    @Override
    public void onReceive(Context context, Intent intent) {
        if (mContext == null) {
            mContext = context;
            mNotifMan = (NotificationManager)
                    mContext.getSystemService(Context.NOTIFICATION_SERVICE);
            mPkgMan = mContext.getPackageManager();
        }

        String action = intent.getAction();
        if (Intent.ACTION_PACKAGE_ADDED.equals(action)||
                Intent.ACTION_PACKAGE_REMOVED.equals(action)) {
            postNotification(getPackageName(intent));
        } else if (ACTION_PARTNER_CUSTOMIZATION.equals(action)) {
            mRowCutoff = intent.getIntExtra(EXTRA_ROW_WRAPPING_CUTOFF, 0);
            postNotification(LIVE_TV_PKG_NAME);
        }
    }

    private void postNotification(String pkgName) {
        int sort;
        int resId;
        int backupResId;
        int titleId;
        int backupTitleId;

        switch (pkgName) {
            case LIVE_TV_PKG_NAME:
                sort = 1;
                resId = R.drawable.ic_tv_banner;
                backupResId = R.drawable.ic_try_tv_banner;
                titleId = R.string.live_tv;
                backupTitleId = R.string.try_live_tv;
                break;
            default:
                return;
        }

        postNotification(sort, resId, backupResId, titleId, backupTitleId, pkgName);
    }

    private void postNotification(int sort, int resId, int backupResId,
            int titleId, int backupTitleId, String pkgName) {
        int id = resId;
        Intent intent = mPkgMan.getLeanbackLaunchIntentForPackage(pkgName);

        if (intent == null) {
            titleId = backupTitleId;
            resId = backupResId;
            intent = getBackupIntent(pkgName);
        }

        Notification.Builder bob = new Notification.Builder(mContext);
        Bundle extras = new Bundle();
        extras.putString(BLACKLIST_PACKAGE, pkgName);

        bob.setContentTitle(mContext.getString(titleId))
                .setSmallIcon(R.drawable.ic_launcher)
                .setLargeIcon(BitmapFactory.decodeResource(mContext.getResources(), resId))
                .setContentIntent(PendingIntent.getActivity(mContext, 0, intent, 0))
                .setCategory(Notification.CATEGORY_RECOMMENDATION)
                .setGroup(PARTNER_GROUP)
                .setSortKey(sort+"")
                .setColor(mContext.getResources().getColor(R.color.partner_color))
                .setExtras(extras);

        mNotifMan.notify(id, bob.build());
    }

    private Intent getBackupIntent(String pkgName) {
        Intent intent = new Intent(Intent.ACTION_VIEW);
        intent.setData(Uri.parse("market://details?id=" + pkgName));

        return intent;
    }

    private String getPackageName(Intent intent) {
        Uri uri = intent.getData();
        String pkg = uri != null ? uri.getSchemeSpecificPart() : null;
        return pkg;
    }

}
