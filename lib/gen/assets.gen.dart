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

  /// File path: assets/icons/ai_icon.svg
  String get aiIcon => 'assets/icons/ai_icon.svg';

  /// File path: assets/icons/ai_word_icon.svg
  String get aiWordIcon => 'assets/icons/ai_word_icon.svg';

  /// File path: assets/icons/check.svg
  String get check => 'assets/icons/check.svg';

  /// File path: assets/icons/coin.svg
  String get coin => 'assets/icons/coin.svg';

  /// File path: assets/icons/flame.svg
  String get flame => 'assets/icons/flame.svg';

  /// File path: assets/icons/hand.svg
  String get hand => 'assets/icons/hand.svg';

  /// File path: assets/icons/handshake.svg
  String get handshake => 'assets/icons/handshake.svg';

  /// File path: assets/icons/logo.png
  AssetGenImage get logo => const AssetGenImage('assets/icons/logo.png');

  /// File path: assets/icons/quiz_icon.svg
  String get quizIcon => 'assets/icons/quiz_icon.svg';

  /// List of all assets
  List<dynamic> get values => [
    aiIcon,
    aiWordIcon,
    check,
    coin,
    flame,
    hand,
    handshake,
    logo,
    quizIcon,
  ];
}

class $AssetsImagesGen {
  const $AssetsImagesGen();

  /// File path: assets/images/onb-1.png
  AssetGenImage get onb1Png => const AssetGenImage('assets/images/onb-1.png');

  /// File path: assets/images/onb_1.png
  AssetGenImage get onb1Png_ => const AssetGenImage('assets/images/onb_1.png');

  /// File path: assets/images/onb-2.png
  AssetGenImage get onb2Png => const AssetGenImage('assets/images/onb-2.png');

  /// File path: assets/images/onb_2.png
  AssetGenImage get onb2Png_ => const AssetGenImage('assets/images/onb_2.png');

  /// File path: assets/images/onb-3.png
  AssetGenImage get onb3Png => const AssetGenImage('assets/images/onb-3.png');

  /// File path: assets/images/onb_3.png
  AssetGenImage get onb3Png_ => const AssetGenImage('assets/images/onb_3.png');

  /// File path: assets/images/onb-4.png
  AssetGenImage get onb4 => const AssetGenImage('assets/images/onb-4.png');

  /// File path: assets/images/onb-5.png
  AssetGenImage get onb5 => const AssetGenImage('assets/images/onb-5.png');

  /// List of all assets
  List<AssetGenImage> get values => [
    onb1Png,
    onb1Png_,
    onb2Png,
    onb2Png_,
    onb3Png,
    onb3Png_,
    onb4,
    onb5,
  ];
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

  /// File path: assets/sounds/fa-la-la.mp3
  String get faLaLa => 'assets/sounds/fa-la-la.mp3';

  /// File path: assets/sounds/success.mp3
  String get success => 'assets/sounds/success.mp3';

  /// List of all assets
  List<String> get values => [click, correct, error, faLaLa, success];
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
