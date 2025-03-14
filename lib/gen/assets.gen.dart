/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
///  FlutterGen
/// *****************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: directives_ordering,unnecessary_import,implicit_dynamic_list_literal,deprecated_member_use

import 'package:flutter/widgets.dart';

class $AssetsIconsGen {
  const $AssetsIconsGen();

  /// File path: assets/icons/check.svg
  String get check => 'assets/icons/check.svg';

  /// File path: assets/icons/coin.svg
  String get coin => 'assets/icons/coin.svg';

  /// File path: assets/icons/flame.svg
  String get flame => 'assets/icons/flame.svg';

  /// List of all assets
  List<String> get values => [check, coin, flame];
}

class $AssetsImagesGen {
  const $AssetsImagesGen();

  /// File path: assets/images/onb_1.png
  AssetGenImage get onb1 => const AssetGenImage('assets/images/onb_1.png');

  /// File path: assets/images/onb_2.png
  AssetGenImage get onb2 => const AssetGenImage('assets/images/onb_2.png');

  /// File path: assets/images/onb_3.png
  AssetGenImage get onb3 => const AssetGenImage('assets/images/onb_3.png');

  /// List of all assets
  List<AssetGenImage> get values => [onb1, onb2, onb3];
}

class $AssetsSecretsGen {
  const $AssetsSecretsGen();

  /// File path: assets/secrets/service_account.json
  String get serviceAccount => 'assets/secrets/service_account.json';

  /// List of all assets
  List<String> get values => [serviceAccount];
}

class $AssetsSoundsGen {
  const $AssetsSoundsGen();

  /// File path: assets/sounds/click.mp3
  String get click => 'assets/sounds/click.mp3';

  /// File path: assets/sounds/correct.wav
  String get correct => 'assets/sounds/correct.wav';

  /// File path: assets/sounds/error.wav
  String get error => 'assets/sounds/error.wav';

  /// List of all assets
  List<String> get values => [click, correct, error];
}

class Assets {
  const Assets._();

  static const String aEnv = '.env';
  static const $AssetsIconsGen icons = $AssetsIconsGen();
  static const $AssetsImagesGen images = $AssetsImagesGen();
  static const $AssetsSecretsGen secrets = $AssetsSecretsGen();
  static const $AssetsSoundsGen sounds = $AssetsSoundsGen();

  /// List of all assets
  static List<String> get values => [aEnv];
}

class AssetGenImage {
  const AssetGenImage(this._assetName, {this.size, this.flavors = const {}});

  final String _assetName;

  final Size? size;
  final Set<String> flavors;

  Image image({
    Key? key,
    AssetBundle? bundle,
    ImageFrameBuilder? frameBuilder,
    ImageErrorWidgetBuilder? errorBuilder,
    String? semanticLabel,
    bool excludeFromSemantics = false,
    double? scale,
    double? width,
    double? height,
    Color? color,
    Animation<double>? opacity,
    BlendMode? colorBlendMode,
    BoxFit? fit,
    AlignmentGeometry alignment = Alignment.center,
    ImageRepeat repeat = ImageRepeat.noRepeat,
    Rect? centerSlice,
    bool matchTextDirection = false,
    bool gaplessPlayback = true,
    bool isAntiAlias = false,
    String? package,
    FilterQuality filterQuality = FilterQuality.medium,
    int? cacheWidth,
    int? cacheHeight,
  }) {
    return Image.asset(
      _assetName,
      key: key,
      bundle: bundle,
      frameBuilder: frameBuilder,
      errorBuilder: errorBuilder,
      semanticLabel: semanticLabel,
      excludeFromSemantics: excludeFromSemantics,
      scale: scale,
      width: width,
      height: height,
      color: color,
      opacity: opacity,
      colorBlendMode: colorBlendMode,
      fit: fit,
      alignment: alignment,
      repeat: repeat,
      centerSlice: centerSlice,
      matchTextDirection: matchTextDirection,
      gaplessPlayback: gaplessPlayback,
      isAntiAlias: isAntiAlias,
      package: package,
      filterQuality: filterQuality,
      cacheWidth: cacheWidth,
      cacheHeight: cacheHeight,
    );
  }

  ImageProvider provider({AssetBundle? bundle, String? package}) {
    return AssetImage(_assetName, bundle: bundle, package: package);
  }

  String get path => _assetName;

  String get keyName => _assetName;
}
