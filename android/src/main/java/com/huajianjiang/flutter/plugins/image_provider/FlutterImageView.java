/*
 * Copyright (C) $year Huajian Jiang
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

package com.huajianjiang.flutter.plugins.image_provider;

import android.content.Context;
import android.view.View;
import android.widget.ImageView;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import com.bumptech.glide.Glide;

import java.util.Map;

import io.flutter.Log;
import io.flutter.plugin.common.StandardMessageCodec;
import io.flutter.plugin.platform.PlatformView;
import io.flutter.plugin.platform.PlatformViewFactory;

/**
 * <p>Author: Huajian Jiang
 * <br>Date: 2020/12/28
 * <br>Email: developer.huajianjiang@gmail.com
 */
public class FlutterImageView implements PlatformView {
    private static final String TAG = FlutterImageView.class.getSimpleName();
    @NonNull 
    private final ImageView imageView;
    
    public FlutterImageView(@NonNull Context context,
                            int id,
                            @Nullable Map<String, Object> creationParams) {
        Log.d(TAG, "FlutterImageView: " + id + ", " + creationParams);
        imageView = new ImageView(context);
        if (creationParams != null) {
            String uri = (String) creationParams.get("uri");
            Glide.with(context).load(uri).into(imageView);
        }
    }

    @Override
    public View getView() {
        Log.d(TAG, "getView");
        return imageView;
    }

    @Override
    public void onFlutterViewAttached(@NonNull View flutterView) {
        Log.d(TAG, "onFlutterViewAttached: " + flutterView);
    }

    @Override
    public void onFlutterViewDetached() {
        Log.d(TAG, "onFlutterViewDetached");
    }

    @Override
    public void dispose() {
        Log.d(TAG, "dispose");
    }

    public static class FlutterImageViewFactory extends PlatformViewFactory {
        
        public FlutterImageViewFactory() {
            super(StandardMessageCodec.INSTANCE);
        }

        @Override
        public PlatformView create(Context context, int viewId, Object args) {
            final Map<String, Object> creationParams = (Map<String, Object>) args;
            return new FlutterImageView(context, viewId, creationParams);
        }
    }
}
