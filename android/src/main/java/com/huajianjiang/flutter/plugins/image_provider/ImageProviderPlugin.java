package com.huajianjiang.flutter.plugins.image_provider;

import android.app.Activity;
import android.content.Context;
import android.util.Log;
import android.util.LongSparseArray;

import androidx.annotation.NonNull;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.EventChannel;
import io.flutter.view.TextureRegistry;

/** ImageProviderPlugin */
public class ImageProviderPlugin implements FlutterPlugin, Messages.ImageProviderApi, ActivityAware {
  private static final String TAG = ImageProviderPlugin.class.getSimpleName();
  private final LongSparseArray<ImageProvider> imageProviders = new LongSparseArray<>();
  private FlutterState flutterState;

  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding binding) {
    flutterState = new FlutterState(binding.getApplicationContext(),
            binding.getBinaryMessenger(),
            binding.getTextureRegistry());
    flutterState.startListening(this, binding.getBinaryMessenger());

    binding.getPlatformViewRegistry().registerViewFactory("ImageView",
            new FlutterImageView.FlutterImageViewFactory());
  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    if (flutterState == null) {
      Log.wtf(TAG, "Detached from the engine before registering to it.");
      return;
    }
    flutterState.stopListening(binding.getBinaryMessenger());
    flutterState = null;
  }

  @Override
  public Messages.TextureMessage create() {
    TextureRegistry.SurfaceTextureEntry handle =
            flutterState.textureRegistry.createSurfaceTexture();
    EventChannel eventChannel = new EventChannel(flutterState.binaryMessenger,
            "huajianiang.com/imageProvider/imageEvents" + handle.id());
    ImageProvider imageProvider = new ImageProvider(eventChannel, handle);
    imageProviders.put(handle.id(), imageProvider);
    Messages.TextureMessage replyMsg = new Messages.TextureMessage();
    replyMsg.setTextureId(handle.id());
    return replyMsg;
  }

  @Override
  public void dispose(Messages.TextureMessage arg) {
    ImageProvider imageProvider = imageProviders.get(arg.getTextureId());
    if (imageProvider == null) {
      Log.wtf(TAG, "Dispose from the engine before create to it.");
      return;
    }
    imageProvider.dispose(flutterState.activity);
    imageProviders.remove(arg.getTextureId());
  }

  @Override
  public void load(Messages.LoadMeaasge arg) {
    ImageProvider imageProvider = imageProviders.get(arg.getTextureId());
    if (imageProvider == null) {
      Log.wtf(TAG, "Load from the engine before create to it.");
      return;
    }
    imageProvider.load(flutterState.activity, arg.getUri(),
            arg.getWidth().intValue(),
            arg.getHeight().intValue(),
            ImageProvider.ResizeMode.values()[arg.getResizeMode().intValue()]);
  }

  @Override
  public void onAttachedToActivity(@NonNull ActivityPluginBinding binding) {
    flutterState.activity = binding.getActivity();
  }

  @Override
  public void onDetachedFromActivityForConfigChanges() {
    onDetachedFromActivity();
  }

  @Override
  public void onReattachedToActivityForConfigChanges(@NonNull ActivityPluginBinding binding) {
    onAttachedToActivity(binding);
  }

  @Override
  public void onDetachedFromActivity() {
    flutterState.activity = null;
  }

  private static final class FlutterState {
    private final Context applicationContext;
    private final BinaryMessenger binaryMessenger;
    private final TextureRegistry textureRegistry;
    private Activity activity;

    FlutterState(
            Context applicationContext,
            BinaryMessenger messenger,
            TextureRegistry textureRegistry) {
      this.applicationContext = applicationContext;
      this.binaryMessenger = messenger;
      this.textureRegistry = textureRegistry;
    }

    void startListening(ImageProviderPlugin methodCallHandler, BinaryMessenger messenger) {
      Messages.ImageProviderApi.setup(messenger, methodCallHandler);
    }

    void stopListening(BinaryMessenger messenger) {
      Messages.ImageProviderApi.setup(messenger, null);
    }
  }

}
