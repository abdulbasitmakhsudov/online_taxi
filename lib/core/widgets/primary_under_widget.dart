import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:online_taxi/config/themes/color_scheme.dart';
import 'package:online_taxi/core/constants/app_colors.dart';
import 'package:online_taxi/core/constants/app_fonts.dart';
import 'package:online_taxi/core/widgets/primary_button.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

import '../extensions/common_extensions.dart';

class PrimaryUnderWidget extends StatelessWidget {
  final VoidCallback onFinishTap;
  final VoidCallback onStartPlaceTap;
  final VoidCallback onFinishPlaceTap;
  final Point? startPoint;
  final Point? endPoint;
  final bool isEnable;

  const PrimaryUnderWidget({
    super.key,
    required this.onFinishTap,
    required this.onStartPlaceTap,
    required this.onFinishPlaceTap,
    this.startPoint,
    this.endPoint,
    required this.isEnable,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Card(
        margin: const EdgeInsets.all(0),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        elevation: 0,
        child: Container(
            height: 234.h,
            alignment: const Alignment(0, 0),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(24),
                topRight: Radius.circular(24),
              ),
              color: Theme.of(context).colorScheme.appBarColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1), // Light shadow
                  blurRadius: 10, // Blur effect
                  spreadRadius: 5, // Spread of the shadow
                  offset:
                      const Offset(0, -5), // Position of shadow (move upwards)
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  onTap: onStartPlaceTap,
                  leading: Icon(CupertinoIcons.location),
                  title: startPoint != null
                      ? FutureBuilder<String>(
                          future: getLocationDetails(startPoint!),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Text(
                                "Loading...",
                                style: pmedium,
                              );
                            } else if (snapshot.hasError) {
                              return Text(
                                "Loading failed",
                                style: pmedium,
                              );
                            } else {
                              return Text(
                                snapshot.data ?? "Unnamed Road",
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                                style: pmedium,
                              );
                            }
                          },
                        )
                      : Text(
                          "Where from?",
                          style: pmedium.copyWith(color: AppColors.steelGrey),
                        ),
                ),
                Divider(),
                ListTile(
                  onTap: onFinishPlaceTap,
                  leading: Icon(CupertinoIcons.flag),
                  title: endPoint != null
                      ? FutureBuilder<String>(
                          future: getLocationDetails(endPoint!),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Text(
                                "Loading...",
                                style: pmedium,
                              );
                            } else if (snapshot.hasError) {
                              return Text(
                                "Loading failed",
                                style: pmedium,
                              );
                            } else {
                              return Text(
                                snapshot.data ?? "Unnamed Road",
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                                style: pmedium,
                              );
                            }
                          },
                        )
                      : Text(
                          "Where to?",
                          style: pmedium.copyWith(color: AppColors.steelGrey),
                        ),
                ),
                PrimaryButton(
                  color: isEnable ? AppColors.primary : AppColors.disabled,
                  onTap: () {
                    if (isEnable) {
                      onFinishTap.call();
                    }
                  },
                  text: "Start Drive",
                ),
              ],
            )),
      ),
    );
  }
}
