import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:online_taxi/config/themes/color_scheme.dart';

Widget primarySvgImage(
  BuildContext context, {
  required String iconPath,
  double? size,
  double? height,
  double? width,
  Color? color,
}) {
  return SvgPicture.asset(
    iconPath,
    height: size ?? height ?? 24,
    width: size ?? width ?? 24,
    colorFilter: ColorFilter.mode(
        color ?? Theme.of(context).colorScheme.textColor, BlendMode.srcIn),
  );
}

Widget primaryPngImage(
  BuildContext context, {
  required String iconPath,
  double? size,
  double? height,
  double? width,
  Color? color,
}) {
  return Image.asset(
    iconPath,
    height: size ?? height ?? 24,
    width: size ?? width ?? 24,
    color: color ?? Theme.of(context).colorScheme.textColor,
  );
}
