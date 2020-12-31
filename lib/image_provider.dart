
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:image_provider/src/messages.dart';

class _ImageProvider {
  ImageProviderApi _api = ImageProviderApi();

  Widget buildView(int textureId) {
    return Texture(textureId: textureId);
  }

  Future<int> create() async {
    TextureMessage response = await _api.create();
    return response.textureId;
  }

  Future<void> dispose(int textureId) {
    return _api.dispose(TextureMessage()..textureId = textureId);
  }

  Future<void> load(int textureId, String uri,
      {int width = 0, int height = 0, int resizeMode = 0}) {
    return _api.load(LoadMeaasge()
      ..textureId = textureId
      ..uri = uri
      ..width = width
      ..height = height
      ..resizeMode = resizeMode);
  }

  Stream<ImageEvent> imageEventsFor(int textureId) {
    return _eventChannelFor(textureId)
        .receiveBroadcastStream()
        .map((dynamic event) {
      final Map<dynamic, dynamic> map = event;
      switch (map['event']) {
        case 'loadStarted':
          return ImageEvent(
            eventType: ImageEventType.loadStarted
          );
        case 'resourceReady':
          return ImageEvent(
            eventType: ImageEventType.resourceReady,
            imageSize: Size(map['width']?.toDouble() ?? 0.0,
                map['height']?.toDouble() ?? 0.0),
          );
        default:
          return ImageEvent(eventType: ImageEventType.unknown);
      }
    });
  }

  EventChannel _eventChannelFor(int textureId) {
    return EventChannel('huajianiang.com/imageProvider/imageEvents$textureId');
  }

}

class ImageEvent {
  final ImageEventType eventType;
  final Size imageSize;

  ImageEvent({@required this.eventType, this.imageSize});
}

enum ImageEventType {
  loadStarted,

  resourceReady,

  unknown
}

enum ResizeMode {
  centerCrop,
  fitCenter
}

class Image extends StatefulWidget {
  final String uri;
  final double width;
  final double height;
  final ResizeMode resizeMode;

  Image(this.uri, {
        Key key,
        this.width = 0,
        this.height = 0,
        this.resizeMode = ResizeMode.centerCrop
      }): assert(width >= 0 && height >= 0), super(key: key);

  @override
  _ImageState createState() => _ImageState();

}

class _ImageState extends State<Image> {
  _ImageProvider _imageProvider;
  int _textureId;
  Size _imageSize;
  StreamSubscription<ImageEvent> _subscription;

  @override
  void initState() {
    super.initState();
    _imageProvider = _ImageProvider();
    _initialize();
  }

  Future<void> _initialize() async {
    _textureId = await _imageProvider.create();
    print('onTextureCreated: $_textureId');
    if (!mounted) {
      _imageProvider.dispose(_textureId);
      return;
    }
    setState(() {});

    _subscription = _imageProvider.imageEventsFor(_textureId).listen((event) {
      if (event.eventType == ImageEventType.resourceReady) {
        if (!mounted) {
          _imageProvider.dispose(_textureId);
          return;
        }
        setState(() {
          _imageSize = event.imageSize;
        });
      }
    });

    _loadImage();
  }

  @override
  void didUpdateWidget(Image oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.uri != oldWidget.uri) {
      _loadImage();
    }
  }

  _loadImage() {
    if(_textureId == null) return;
    if (!mounted) {
      _imageProvider.dispose(_textureId);
      return;
    }
    // 滚动上下文中如果滚动太快就延迟加载操作
    if (Scrollable.recommendDeferredLoadingForContext(context)) {
      SchedulerBinding.instance.scheduleFrameCallback((_) {
        scheduleMicrotask(() => _loadImage());
      });
      return;
    }
    final ratio = WidgetsBinding.instance.window.devicePixelRatio;
    print('DevicePixelRatio: $ratio, ${(ratio * 100).truncate()}');
    _imageProvider.load(_textureId, widget.uri,
        width: (ratio * widget.width).truncate(),
        height: (ratio * widget.height).truncate(),
        resizeMode: widget.resizeMode.index);
  }

  @override
  Widget build(BuildContext context) {
    if (_textureId == null || _imageSize == null) {
      return Container();
    }

    Widget buildContent(Size widgetSize, Size imageSize) {
      return Container(
          width: widgetSize.width,
          height: widgetSize.height,
          alignment: Alignment.center,
          child: SizedBox(
              width: imageSize.width,
              height: imageSize.height,
              child: _imageProvider.buildView(_textureId)));
    }

    if (widget.width > 0 && widget.height > 0) {
      Size resized = _resizeTexture(
          BoxConstraints.tightFor(width: widget.width, height: widget.height));
      print('resized: $resized');
      return buildContent(Size(widget.width, widget.height), resized);
    }

    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      Size resized = _resizeTexture(constraints);
      return buildContent(Size(constraints.maxWidth,
          constraints.maxHeight), resized);
    });
  }

  Size _resizeTexture(BoxConstraints constraints) {
    assert(constraints.hasBoundedWidth &&
        constraints.hasBoundedHeight);

    final ratio = MediaQuery.of(context).devicePixelRatio;
    final double imageViewWidth = ratio * constraints.maxWidth;
    final double imageViewHeight = ratio * constraints.maxHeight;
    final double imageWidth = _imageSize.width;
    final double imageHeight = _imageSize.height;

    print('_resizeTexture: $imageViewWidth, $imageViewHeight,'
        ' $imageWidth, $imageHeight');

    if (widget.resizeMode == ResizeMode.centerCrop ||
        (imageViewWidth == imageWidth && imageViewHeight == imageHeight)) {
      return Size(imageViewWidth / ratio, imageViewHeight / ratio);
    }

    if(widget.resizeMode == ResizeMode.fitCenter) {
      final double imageAspectRatio = imageWidth / imageHeight;

      double resultWidth;
      double resultHeight;

      if(imageWidth < imageViewWidth) {
         resultWidth = imageViewHeight * imageAspectRatio;
         resultHeight = imageViewHeight;
      } else {
        resultHeight = imageViewWidth / imageAspectRatio;
        resultWidth = imageViewWidth;
      }
      resultWidth /= ratio;
      resultHeight /= ratio;
      print('Result size: $resultWidth , $resultHeight');
      return Size(resultWidth, resultHeight);
    } else {
      throw 'Unknown ResizeMode: ${widget.resizeMode}';
    }
  }

  @override
  void dispose() {
    _subscription?.cancel();
    if(_textureId != null) {
      _imageProvider.dispose(_textureId);
    }
    super.dispose();
  }

}
