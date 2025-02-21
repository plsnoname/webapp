package com.example.fatcherappv2;

import io.flutter.app.FlutterApplication;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.embedding.engine.FlutterEngineCache;

public class MainApplication extends FlutterApplication {
    @Override
    public void onCreate() {
        super.onCreate();
        // Initialize FlutterEngine
        FlutterEngine flutterEngine = new FlutterEngine(this);
        // Cache the FlutterEngine to be used by FlutterActivity
        FlutterEngineCache.getInstance().put("my_engine_id", flutterEngine);
    }
}
