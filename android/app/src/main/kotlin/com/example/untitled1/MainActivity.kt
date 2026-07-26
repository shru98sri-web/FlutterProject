package com.example.untitled1

import android.os.Handler
import android.os.Looper
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {

    // १. चॅनेल्सचे आयडी डिफाईन केले
    private val METHOD_CHANNEL = "com.example.app/states"
    private val STREAM_CHANNEL = "com.example.app/stream"

    private var eventSink: EventChannel.EventSink? = null
    private val handler = Handler(Looper.getMainLooper())
    private var counter = 0

    // २. टायमर चालवणारे लॉजिक
    private val runnable = object : Runnable {
        override fun run() {
            counter++
            eventSink?.success(counter) // Flutter ला डेटा पाठवला
            handler.postDelayed(this, 1000)
        }
    }

    // ३. दोन्ही चॅनेल्स एकाच फंक्शनमध्ये एकत्र सेट केले
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        val messenger = flutterEngine.dartExecutor.binaryMessenger

        // --- METHOD CHANNEL (राज्यांची माहिती पाठवण्यासाठी) ---
        MethodChannel(messenger, METHOD_CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "getStatesData") {
                val statesList = ArrayList<HashMap<String, String>>()
                statesList.add(hashMapOf("name" to "Maharashtra", "capital" to "Mumbai"))
                statesList.add(hashMapOf("name" to "Goa", "capital" to "Panaji"))
                statesList.add(hashMapOf("name" to "Gujarat", "capital" to "Gandhinagar"))

                result.success(statesList)
            } else {
                result.notImplemented()
            }
        }

        // --- EVENT CHANNEL (लाईव्ह काउंटर स्ट्रीम करण्यासाठी) ---
        EventChannel(messenger, STREAM_CHANNEL).setStreamHandler(
            object : EventChannel.StreamHandler {
                override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
                    eventSink = events
                    counter = 0
                    handler.post(runnable) // स्ट्रीम सुरू झाली
                }

                override fun onCancel(arguments: Any?) {
                    handler.removeCallbacks(runnable) // टायमर थांबवला

                    // Android च्या लॉगमध्ये शेवटचा एकूण काऊंट प्रिंट होईल
                    println("Stream Ended. Final Native Count was: $counter")

                    eventSink = null
                }
            }
        )
    }
}