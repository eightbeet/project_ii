package com.example.project_ii

import android.app.AppOpsManager
import android.os.Build
import android.net.Uri
import android.content.Context
import android.provider.Settings
import android.content.Intent
import android.os.Bundle
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val BACKGROUND_CHANNEL = "method_channel@blocker/background"

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, BACKGROUND_CHANNEL).setMethodCallHandler {
            call, result ->
            when (call.method) {
                "startBackgroundService" -> {
                   if(!hasUsageStatsPermission(this)) {
                     val intent = Intent(Settings.ACTION_USAGE_ACCESS_SETTINGS)
                     intent.setData(Uri.parse("package:" + getPackageName()));
                     startActivityForResult(intent, 0)
                   }
                   startService(Intent(this, ForegroundService::class.java))
                   result.success(null)
                }
                "stopBackgroundService" -> {
                    stopService(Intent(this, ForegroundService::class.java))
                    result.success(null)
                }

                // "askUsageStatsPermission" -> {
                //     val intent = Intent(Settings.ACTION_USAGE_ACCESS_SETTINGS)
                //     intent.setData(Uri.parse("package:" + getPackageName()));
                //     startActivityForResult(intent, 0)
                // }
                else -> {
                    result.notImplemented()
                }
            }
        }
    }
   
    private fun hasUsageStatsPermission(context: Context): Boolean {
      return if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
         val appOps = context.getSystemService(Context.APP_OPS_SERVICE) as AppOpsManager
         val mode = appOps.checkOpNoThrow(
             AppOpsManager.OPSTR_GET_USAGE_STATS,
             android.os.Process.myUid(),
             context.packageName
         )
         mode == AppOpsManager.MODE_ALLOWED
      } else {
          true 
      }
    }
}
