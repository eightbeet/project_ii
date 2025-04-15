package com.example.project_ii

import android.os.Handler
import android.os.Looper 
import androidx.annotation.*

import android.app.*
import android.app.usage.UsageStats
import android.app.usage.UsageEvents
import android.app.usage.UsageStatsManager
import android.content.Context 
import android.content.Intent
import android.content.SharedPreferences
import android.graphics.PixelFormat
import android.os.*
import android.provider.Settings
import android.util.Log
import android.view.*
import android.widget.TextView
import androidx.core.app.NotificationCompat
import androidx.annotation.RequiresApi

import java.util.concurrent.Executors
import java.util.concurrent.ScheduledExecutorService
import java.util.concurrent.TimeUnit


class ForegroundService : Service() {
    private val CHANNEL_ID = "ForegroundServiceChannel"
    private val CHECK_INTERVAL_MS = 500L

    private var windowManager: WindowManager? = null
    private var overlayView: View? = null
    private var scheduler: ScheduledExecutorService? = null

    private var mHomeWatcher = HomeWatcher(this)
    private var blockedAppPackages: List<String> = emptyList()

    override fun onBind(intent: Intent?): IBinder? {
        return null
    }

    override fun onCreate() {
        super.onCreate()
        windowManager = getSystemService(WINDOW_SERVICE) as WindowManager
        scheduler = Executors.newSingleThreadScheduledExecutor()
        loadLockedApps();
    }

    private fun loadLockedApps() {
        val prefs = getSharedPreferences("FlutterSharedPreferences", Context.MODE_PRIVATE)
        val savedList = prefs.getStringList("flutter.blockedApps")
        blockedAppPackages = savedList  ?: mutableListOf("com.test.app")
    }
   
    fun SharedPreferences.getStringList(key: String): List<String>? {
      val serialized = getString(key, null) ?: return null
      val regex = "^[a-zA-Z0-9_]+!".toRegex()
      val result = serialized.replaceFirst(regex, "")
      return result.removePrefix("[").removeSuffix("]").split(",").filter { it.isNotEmpty() }
    }

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        createNotification()
        startForeground(1, createNotification())
        mHomeWatcher.setOnHomePressedListener(object : HomeWatcher.OnHomePressedListener {
            override fun onHomePressed() {
                println("onHomePressed")
                if(overlayView != null ){
                     removeOverlay()
                }
            }
            override fun onHomeLongPressed() {
                println("onHomeLongPressed")
                if(overlayView != null ){
                     removeOverlay()
                }
            }
        })
        mHomeWatcher.startWatch()
        timerRun()
        return START_STICKY
    }
    private fun timerRun() {
      scheduler?.scheduleAtFixedRate({ 
           isAppInForeground(this)
      }, 0, CHECK_INTERVAL_MS, TimeUnit.MILLISECONDS)
    }

    override fun onDestroy() {
        super.onDestroy()
        scheduler?.shutdown()
        mHomeWatcher.stopWatch()
        removeOverlay()
    }

    private fun createNotification(): Notification {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val serviceChannel = NotificationChannel(
                CHANNEL_ID,
                "Foreground Service Channel",
                NotificationManager.IMPORTANCE_DEFAULT
            )
            val manager = getSystemService(NotificationManager::class.java)
            manager?.createNotificationChannel(serviceChannel)
        }

        val notificationIntent = Intent(this, MainActivity::class.java)
        val pendingIntent = PendingIntent.getActivity(this, 0, notificationIntent,
            PendingIntent.FLAG_IMMUTABLE)

        return NotificationCompat.Builder(this, CHANNEL_ID)
            .setContentTitle("App Block Service")
            .setContentText("Monitoring for Blocked Apps being launched...")
            .setSmallIcon(R.mipmap.ic_launcher) 
            .setContentIntent(pendingIntent)
            .build()
    }

    private fun showOverlay() {
				Handler(Looper.getMainLooper()).post{
        val params = WindowManager.LayoutParams(
            WindowManager.LayoutParams.MATCH_PARENT,
            WindowManager.LayoutParams.MATCH_PARENT,
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                WindowManager.LayoutParams.TYPE_APPLICATION_OVERLAY
            } else {
                WindowManager.LayoutParams.TYPE_PHONE 
            },
            WindowManager.LayoutParams.FLAG_NOT_FOCUSABLE or WindowManager.LayoutParams.FLAG_NOT_TOUCH_MODAL,
            PixelFormat.TRANSLUCENT
        )

        params.gravity = Gravity.CENTER

        val inflater = LayoutInflater.from(this)
        overlayView = inflater.inflate(R.layout.overlay_layout, null)

        val blockMessageTextView = overlayView?.findViewById<TextView>(R.id.block_message)
        blockMessageTextView?.text = "Um Locked this App."

        try {
            windowManager?.addView(overlayView, params)
        } catch (e: Exception) {
            Log.e("OverlayService", "Error adding overlay: ${e.message}")
            overlayView = null 
        }
			}
    }

    private fun removeOverlay() {
        if (overlayView != null) {
            try {
                windowManager?.removeView(overlayView)
            } catch (e: IllegalArgumentException) {
                Log.w("OverlayService", "Attempting to remove non-attached view: ${e.message}")
            } finally {
                overlayView = null
            }
        }
    }


   private fun hasUsageStatsPermission(context: Context): Boolean {
    val appOpsManager = context.getSystemService(Context.APP_OPS_SERVICE) as AppOpsManager
    val mode = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
        appOpsManager.unsafeCheckOpNoThrow(
            AppOpsManager.OPSTR_GET_USAGE_STATS,
            Process.myUid(),
            context.packageName
        )
    } else {
        appOpsManager.checkOpNoThrow(
            AppOpsManager.OPSTR_GET_USAGE_STATS,
            Process.myUid(),
            context.packageName
        )
    }
    return mode == AppOpsManager.MODE_ALLOWED
   }


   @RequiresApi(Build.VERSION_CODES.LOLLIPOP)
   private fun isAppInForeground(context: Context) { 
        val usageStatsManager = context.getSystemService(Context.USAGE_STATS_SERVICE) as UsageStatsManager
        val endTime = System.currentTimeMillis()
        val beginTime = endTime - CHECK_INTERVAL_MS * 2 

        val value = hasUsageStatsPermission(context)
        val event = UsageEvents.Event()

        try {
            val usageEvents = usageStatsManager.queryEvents(beginTime, endTime)
            run breaking@{
                while (usageEvents.hasNextEvent()) {
                     usageEvents.getNextEvent(event)
                     for(pkg in blockedAppPackages ) {
                        val packageName = pkg.trim('\"')
                        if (event.packageName == packageName && 
                            event.eventType == UsageEvents.Event.ACTIVITY_RESUMED) {
                              if (overlayView == null && Settings.canDrawOverlays(this)) {
                                  showOverlay()
                   }
                   return@breaking
                }
               }
            }
         }
        } catch (e: SecurityException) {
            Log.w("ForegroundService", "SecurityException: ${e.message}")
        }
    }
}
