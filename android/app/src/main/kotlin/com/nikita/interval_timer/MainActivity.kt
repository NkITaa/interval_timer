package com.nikita.interval_timer

import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.content.Context
import android.os.Build
import android.util.Log
import androidx.core.app.NotificationCompat
import com.ryanheise.audioservice.AudioServiceActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : AudioServiceActivity() {
    companion object {
        private const val TAG = "WorkoutNotification"
        private const val CHANNEL_WORKOUT = "com.nikita.interval_timer.channel.workout"
        private const val CHANNEL_AUDIO = "com.nikita.interval_timer.channel.audio"
        private const val NOTIFICATION_ID = 9999
        private const val METHOD_CHANNEL = "workout_notification"
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        createNotificationChannels()

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, METHOD_CHANNEL)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "update" -> {
                        try {
                            @Suppress("UNCHECKED_CAST")
                            val args = call.arguments as Map<String, Any>
                            showNotification(args)
                        } catch (e: Exception) {
                            Log.e(TAG, "Failed to show notification", e)
                        }
                        result.success(null)
                    }
                    "stop" -> {
                        cancelNotification()
                        result.success(null)
                    }
                    "requestPermission" -> {
                        requestNotificationPermission()
                        result.success(null)
                    }
                    else -> result.notImplemented()
                }
            }
    }

    private fun createNotificationChannels() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val manager = getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager

            // Pre-create audio channel with MIN importance before JustAudioBackground.init()
            // so the media notification is less prominent than our workout notification.
            // Note: on app updates where the channel already exists, this is a no-op —
            // Android does not allow increasing or decreasing importance after creation.
            if (manager.getNotificationChannel(CHANNEL_AUDIO) == null) {
                manager.createNotificationChannel(
                    NotificationChannel(
                        CHANNEL_AUDIO,
                        "Audio playback",
                        NotificationManager.IMPORTANCE_MIN
                    )
                )
            }

            // Workout status channel
            manager.createNotificationChannel(
                NotificationChannel(
                    CHANNEL_WORKOUT,
                    "Workout status",
                    NotificationManager.IMPORTANCE_LOW
                ).apply {
                    description = "Shows workout progress during active sessions"
                    setShowBadge(false)
                }
            )
        }
    }

    private fun showNotification(args: Map<String, Any>) {
        val title = args["title"] as String
        val content = args["content"] as String
        val color = (args["color"] as Number).toInt()
        val phaseRemainingSec = (args["phaseRemainingSec"] as Number).toInt()
        val isPaused = args["isPaused"] as? Boolean ?: false

        val launchIntent = packageManager.getLaunchIntentForPackage(packageName)
        val pendingIntent = if (launchIntent != null) {
            PendingIntent.getActivity(
                this, 0, launchIntent,
                PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
            )
        } else null

        val builder = NotificationCompat.Builder(this, CHANNEL_WORKOUT)
            .setSmallIcon(R.drawable.ic_notification)
            .setContentTitle(title)
            .setContentText(content)
            .setColor(color)
            .setOngoing(true)
            .setOnlyAlertOnce(true)
            .setSilent(true)
            .setContentIntent(pendingIntent)

        if (!isPaused) {
            val phaseEndMs = System.currentTimeMillis() + phaseRemainingSec * 1000L
            builder.setUsesChronometer(true)
                .setChronometerCountDown(true)
                .setWhen(phaseEndMs)
                .setShowWhen(true)
        } else {
            val minutes = phaseRemainingSec / 60
            val seconds = phaseRemainingSec % 60
            builder.setUsesChronometer(false)
                .setShowWhen(false)
                .setSubText("$minutes:${seconds.toString().padStart(2, '0')}")
        }

        val manager = getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
        manager.notify(NOTIFICATION_ID, builder.build())
    }

    private fun cancelNotification() {
        val manager = getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
        manager.cancel(NOTIFICATION_ID)
    }

    private fun requestNotificationPermission() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
            requestPermissions(arrayOf(android.Manifest.permission.POST_NOTIFICATIONS), 1001)
        }
    }
}
