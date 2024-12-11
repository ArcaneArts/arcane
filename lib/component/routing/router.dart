import 'package:arcane/arcane.dart';
import 'package:flutter/foundation.dart';
import 'package:universal_html/html.dart' as html;

mixin ArcaneRoute on Widget {
  String get path;

  void $applyRoute() {
    if (kIsWeb) {
      pageMeta?.apply();
    }
    onApplyRoute();
  }

  void onApplyRoute() {}

  ArcanePageMeta? get pageMeta => null;
}

class ArcanePageMeta {
  final String? title;
  final String? description;
  final List<String>? keywords;
  final String? author;
  final String? charset;
  final String? image;
  final RobotsName? robotsName;
  final String? robotsContent;
  final String? facebookAppID;
  final String? url;
  final String? type;
  final TwitterCard? twitterCard;
  final Color? themeColor;

  ArcanePageMeta({
    this.title,
    this.description,
    this.keywords,
    this.author,
    this.charset,
    this.image,
    this.robotsName,
    this.robotsContent,
    this.facebookAppID,
    this.url,
    this.type,
    this.twitterCard,
    this.themeColor,
  });

  void apply() {
    if (kIsWeb) {
      $apply(MetaSEO());
    }
  }

  void $apply(MetaSEO seo) {
    if (!kIsWeb) {
      return;
    }

    if (title != null) {
      seo.ogTitle(ogTitle: title!);
      html.document.title = title!;
      seo.twitterTitle(twitterTitle: title!);
    }
    if (description != null) {
      seo.description(description: description!);
      seo.ogDescription(ogDescription: description!);
      seo.twitterDescription(twitterDescription: description!);
    }
    if (keywords != null) {
      seo.keywords(keywords: keywords!.join(", "));
    }
    if (author != null) {
      seo.author(author: author!);
    }
    if (charset != null) {
      seo.charset(charset: charset!);
    }
    if (image != null) {
      seo.ogImage(ogImage: image!);
      seo.twitterImage(twitterImage: image!);
    }
    if (robotsName != null && robotsContent != null) {
      seo.robots(robotsName: robotsName!, content: robotsContent!);
    }
    if (twitterCard != null) {
      seo.twitterCard(twitterCard: twitterCard!);
    }
    if (facebookAppID != null) {
      seo.facebookAppID(facebookAppID: facebookAppID!);
    }
    if (url != null) {
      seo.propertyContent(property: "og:url", content: url!);
    }

    if (type != null) {
      seo.propertyContent(property: "og:type", content: type!);
    }

    if (themeColor != null) {
      seo.nameContent(
          name: "theme-color",
          content:
              "#${(themeColor!.value & 0xFFFFFF).toRadixString(16).padLeft(6, '0')}");
    }
  }
}
