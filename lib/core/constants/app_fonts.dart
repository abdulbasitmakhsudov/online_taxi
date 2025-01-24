import 'package:flutter/material.dart';

import 'app_colors.dart';

const TextStyle pthin = TextStyle(
  color: AppColors.midnightBlue,
  fontFamily: "poppinsthin",
  fontSize: 14,
);

const TextStyle plight = TextStyle(
  color: AppColors.midnightBlue,
  fontFamily: "poppinslight",
  fontSize: 16,
);

const TextStyle pregular = TextStyle(
  color: AppColors.midnightBlue,
  fontFamily: "poppinsregular",
  // fontFamily: "senregular",
  fontSize: 14,
);

const TextStyle pmedium = TextStyle(
  color: AppColors.midnightBlue,
  fontFamily: "poppinsmedium",
  // fontFamily: "senmedium",
  fontSize: 16,
);

const TextStyle semiBold = TextStyle(
  color: AppColors.midnightBlue,
  fontFamily: "poppinssemibold",
  // fontFamily: "sensemibold",
  fontSize: 20,
);

const TextStyle pbold = TextStyle(
  color: AppColors.midnightBlue,
  fontFamily: "poppinsbold",
  // fontFamily: "senbold",
  fontSize: 16,
);

const TextStyle pblack = TextStyle(
  color: AppColors.white,
  fontFamily: "poppinsblack",
  fontSize: 22,
);

const TextStyle kBlackButtonTextStyle = TextStyle(
  color: AppColors.midnightBlue,
  fontFamily: 'poppinsregular',
  fontSize: 14,
);

const TextStyle kThemeButtonTextStyle = TextStyle(
  color: AppColors.white,
  fontFamily: 'poppinsregular',
  fontSize: 18,
);

ButtonStyle kButtonTransparentStyle = ButtonStyle(
  backgroundColor: const WidgetStatePropertyAll(AppColors.transparent),
  shape: const WidgetStatePropertyAll(
    RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(14)),
    ),
  ),
  overlayColor: WidgetStatePropertyAll(AppColors.overlay),
);

ButtonStyle kButtonWhiteStyle = ButtonStyle(
  backgroundColor: WidgetStateProperty.all(AppColors.white),
  shape: WidgetStateProperty.all(
    const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(14))),
  ),
  overlayColor: WidgetStateProperty.all(Colors.grey.withAlpha(40)),
);

ButtonStyle kButtonThemeStyle = ButtonStyle(
  backgroundColor: WidgetStateProperty.all(AppColors.primary),
  shape: WidgetStateProperty.all(
    const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(14))),
  ),
  overlayColor: WidgetStateProperty.all(Colors.grey.withAlpha(40)),
);

ButtonStyle kButtonShadowThemeStyle = ButtonStyle(
  backgroundColor: WidgetStateProperty.all(AppColors.primary),
  shadowColor: WidgetStateProperty.all(AppColors.primary),
  shape: WidgetStateProperty.all(
    const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(14)),
    ),
  ),
  overlayColor: WidgetStateProperty.all(Colors.grey.withAlpha(40)),
  elevation: WidgetStateProperty.all(5), // Adjust elevation as needed
);
