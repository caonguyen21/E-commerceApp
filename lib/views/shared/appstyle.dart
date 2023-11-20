import 'dart:ui';

import 'package:flutter/src/painting/text_style.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

TextStyle appstyle(double size, Color color, FontWeight fw) {
  return GoogleFonts.poppins(fontSize: size.sp, color: color, fontWeight: fw);
}

TextStyle appstyle2(double fontSize, Color color, FontWeight fontWeight) {
  return TextStyle(
    fontSize: fontSize.toDouble(),  // Ensure fontSize is a double
    color: color,
    fontWeight: fontWeight,
  );
}


TextStyle appstyleWithHt(double size, Color color, FontWeight fw, double ht) {
  return GoogleFonts.poppins(fontSize: size.sp, color: color, fontWeight: fw, height: ht);
}
