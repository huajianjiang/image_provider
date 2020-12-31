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

package com.huajianjiang.flutter.plugins.image_provider_example;

import android.content.Context;

import androidx.annotation.NonNull;

import com.bumptech.glide.GlideBuilder;
import com.bumptech.glide.annotation.GlideModule;
import com.bumptech.glide.load.DecodeFormat;
import com.bumptech.glide.module.AppGlideModule;
import com.bumptech.glide.request.RequestOptions;

/**
 * <p>Author: Huajian Jiang
 * <br>Date: 2020/12/24
 * <br>Email: developer.huajianjiang@gmail.com
 */
@GlideModule
public class ImageProviderGlideModule extends AppGlideModule {

    @Override
    public void applyOptions(@NonNull Context context, @NonNull GlideBuilder builder) {
        RequestOptions options = new RequestOptions()
                .format(DecodeFormat.PREFER_ARGB_8888)
//                .placeholder(R.color.img_placeholder)
                .disallowHardwareConfig();
        builder.setDefaultRequestOptions(options);
//                .setDefaultTransitionOptions(Drawable.class, DrawableTransitionOptions.withCrossFade())
//                .setDefaultTransitionOptions(Bitmap.class, BitmapTransitionOptions.withCrossFade());
    }

    @Override
    public boolean isManifestParsingEnabled() {
        return false;
    }

}
