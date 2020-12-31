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

import android.app.Activity;
import android.graphics.Canvas;
import android.graphics.drawable.Drawable;
import android.view.Surface;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import com.bumptech.glide.Glide;
import com.bumptech.glide.RequestBuilder;
import com.bumptech.glide.request.target.CustomTarget;
import com.bumptech.glide.request.target.Target;
import com.bumptech.glide.request.transition.Transition;

import java.util.HashMap;
import java.util.Map;

import io.flutter.Log;
import io.flutter.plugin.common.EventChannel;
import io.flutter.view.TextureRegistry;

/**
 * <p>Author: Huajian Jiang
 * <br>Date: 2020/12/25
 * <br>Email: developer.huajianjiang@gmail.com
 */
public class ImageProvider {
    private static final String TAG = ImageProvider.class.getSimpleName();
    private final QueuingEventSink eventSink = new QueuingEventSink();
    private final TextureRegistry.SurfaceTextureEntry surfaceTextureEntry;
    private final EventChannel eventChannel;
    private final Surface surface;
    private Target<Drawable> target;

    public enum ResizeMode {
        CENTER_CROP,
        FIT_CENTER
    }

    public ImageProvider(EventChannel eventChannel,
                         TextureRegistry.SurfaceTextureEntry surfaceTextureEntry) {
        this.eventChannel = eventChannel;
        this.surfaceTextureEntry = surfaceTextureEntry;
        surface = new Surface(surfaceTextureEntry.surfaceTexture());
        eventChannel.setStreamHandler(new EventChannel.StreamHandler() {
            @Override
            public void onListen(Object arguments, EventChannel.EventSink events) {
                eventSink.setDelegate(events);
            }

            @Override
            public void onCancel(Object arguments) {
                eventSink.setDelegate(null);
            }
        });
    }

    public void load(Activity activity, String uri, int width, int height, ResizeMode resizeMode) {
        cancel(activity);
        RequestBuilder<Drawable> requestBuilder = Glide.with(activity).load(uri);
        if (width > 0 && height > 0) {
            requestBuilder = requestBuilder
                    .override(width, height);
            if (resizeMode == ResizeMode.CENTER_CROP) {
                requestBuilder = requestBuilder.optionalCenterCrop();
            } else if (resizeMode == ResizeMode.FIT_CENTER) {
                requestBuilder = requestBuilder.optionalFitCenter();
            }
        }
        target = requestBuilder.into(new CustomTarget<Drawable>() {
            
            private void drawContent(@NonNull Drawable content) {
                if (surface.isValid()) {
                    int resWidth = content.getIntrinsicWidth();
                    int resHeight = content.getIntrinsicHeight();
                    surfaceTextureEntry.surfaceTexture().setDefaultBufferSize(resWidth, resHeight);
                    content.setBounds(0, 0, resWidth, resHeight);
                    Canvas canvas = surface.lockCanvas(content.copyBounds());
                    content.draw(canvas);
                    surface.unlockCanvasAndPost(canvas);
                }
            }

            @Override
            public void onResourceReady(@NonNull Drawable resource,
                                        @Nullable Transition<? super Drawable> transition) {
                Log.d(TAG, "onResourceReady: " +
                        resource.getIntrinsicWidth()+ ", " +
                        resource.getIntrinsicHeight());
                drawContent(resource);
                Map<String, Object> event = new HashMap<>();
                event.put("event", "resourceReady");
                event.put("width", resource.getIntrinsicWidth());
                event.put("height", resource.getIntrinsicHeight());
                eventSink.success(event);
            }

            @Override
            public void onLoadStarted(@Nullable Drawable placeholder) {
                Log.d(TAG, "onLoadStarted: " + placeholder);
                if (placeholder != null) {
                    drawContent(placeholder);
                }
                Map<String, Object> event = new HashMap<>();
                event.put("event", "loadStarted");
                eventSink.success(event);
            }

            @Override
            public void onLoadCleared(@Nullable Drawable placeholder) {
            }
        });
    }

    private void cancel(Activity activity) {
        Glide.with(activity).clear(target);
    }

    public void dispose(Activity activity) {
        cancel(activity);
        eventChannel.setStreamHandler(null);
        surfaceTextureEntry.release();
        surface.release();
    }

}
