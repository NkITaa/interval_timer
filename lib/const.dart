import 'dart:ui';

// L - lightNeutral
const lightNeutral0 = Color(0xffFCFCFC);
const lightNeutral50 = Color(0xffF5F5F5);
const lightNeutral100 = Color(0xffEFF1F2);
const lightNeutral200 = Color(0xffC9CDD2);
const lightNeutral300 = Color(0xffB4B4B4);
const lightNeutral400 = Color(0xff878E96);
const lightNeutral500 = Color(0xff666D74);
const lightNeutral600 = Color(0xff52575D);
const lightNeutral700 = Color(0xff3E4246);
const lightNeutral800 = Color(0xff282B2E);
const lightNeutral850 = Color(0xff16181A);
const lightNeutral900 = Color(0xff141617);

// D - darkNeutral
const darkNeutral0 = Color(0xff121212);
const darkNeutral50 = Color(0xff222222);
const darkNeutral100 = Color(0xff292929);
const darkNeutral200 = Color(0xff3B3B3B);
const darkNeutral300 = Color(0xff4F4F4F);
const darkNeutral400 = Color(0xff646464);
const darkNeutral500 = Color(0xff797979);
const darkNeutral600 = Color(0xff8D8D8D);
const darkNeutral700 = Color(0xffA2A2A2);
const darkNeutral800 = Color(0xffB6B6B6);
const darkNeutral850 = Color(0xffBFBBBB);
const darkNeutral900 = Color(0xffD9D4D4);

// L - lightSuccess
const lightSuccess50 = Color(0xffE9FDF6);
const lightSuccess100 = Color(0xffC3FAE8);
const lightSuccess200 = Color(0xffA7F3DA);
const lightSuccess300 = Color(0xff6EE7BF);
const lightSuccess400 = Color(0xff34D39E);
const lightSuccess500 = Color(0xff10B981);
const lightSuccess600 = Color(0xff059666);
const lightSuccess700 = Color(0xff047851);
const lightSuccess800 = Color(0xff065F41);
const lightSuccess900 = Color(0xff064E36);

// D - darkSuccess
const darkSuccess50 = Color(0xffFDF3F3);
const darkSuccess100 = Color(0xffF0FAF7);
const darkSuccess200 = Color(0xffD8F3EA);
const darkSuccess300 = Color(0xff9DE7CE);
const darkSuccess400 = Color(0xff5FD3AC);
const darkSuccess500 = Color(0xff36B98D);
const darkSuccess600 = Color(0xff239670);
const darkSuccess700 = Color(0xff1C7859);
const darkSuccess800 = Color(0xff195F48);
const darkSuccess900 = Color(0xff164E3B);

// L - lightWarning
const lightWarning50 = Color(0xffFFFCEB);
const lightWarning100 = Color(0xffFEF5C7);
const lightWarning200 = Color(0xffFDEA8A);
const lightWarning300 = Color(0xffFCDF4D);
const lightWarning400 = Color(0xffFBC524);
const lightWarning500 = Color(0xffF5A70B);
const lightWarning600 = Color(0xffD97006);
const lightWarning700 = Color(0xffB45F09);
const lightWarning800 = Color(0xff92500E);
const lightWarning900 = Color(0xff78440F);

// D - darkWarning
const darkWarning50 = Color(0xffFFFDF5);
const darkWarning100 = Color(0xffFEFBEA);
const darkWarning200 = Color(0xffFDF2BE);
const darkWarning300 = Color(0xffFCE781);
const darkWarning400 = Color(0xffFBD255);
const darkWarning500 = Color(0xffF5B73B);
const darkWarning600 = Color(0xffD98532);
const darkWarning700 = Color(0xffB4712D);
const darkWarning800 = Color(0xff925F2C);
const darkWarning900 = Color(0xff784F26);

// L - lightError
const lightError50 = Color(0xffFEF3F2);
const lightError100 = Color(0xffFEE4E2);
const lightError200 = Color(0xffFECECA);
const lightError300 = Color(0xffFCACA5);
const lightError400 = Color(0xffF87C71);
const lightError500 = Color(0xffEF5244);
const lightError600 = Color(0xffDC3526);
const lightError700 = Color(0xffB9291C);
const lightError800 = Color(0xff99261B);
const lightError900 = Color(0xff7F251D);

// D - darkError
const darkError50 = Color(0xffFEF7F6);
const darkError100 = Color(0xffFEF0EF);
const darkError200 = Color(0xffFEE7E5);
const darkError300 = Color(0xffFCD9D6);
const darkError400 = Color(0xffF8ABA4);
const darkError500 = Color(0xffEF7D73);
const darkError600 = Color(0xffDC5D51);
const darkError700 = Color(0xffB94B41);
const darkError800 = Color(0xff99423A);
const darkError900 = Color(0xff7F3D37);

// headingFonts
TextStyle heading1 = TextStyle(fontSize: 26, height: 3.12);
TextStyle heading1Bold =
    TextStyle(fontSize: 26, height: 3.12, fontWeight: FontWeight.bold);
TextStyle heading2Bold =
    TextStyle(fontSize: 24, height: 2.88, fontWeight: FontWeight.bold);
TextStyle heading3Bold =
    TextStyle(fontSize: 22, height: 2.64, fontWeight: FontWeight.bold);

// bodyFonts
TextStyle body0Bold =
    TextStyle(fontSize: 20, height: 2.8, fontWeight: FontWeight.bold);
TextStyle body1 = TextStyle(fontSize: 16, height: 2.24);
TextStyle body1Bold =
    TextStyle(fontSize: 16, height: 2.24, fontWeight: FontWeight.bold);
TextStyle body1Underlined =
    TextStyle(fontSize: 16, height: 2.24, decoration: TextDecoration.underline);
TextStyle body2 = TextStyle(fontSize: 14, height: 1.96);
TextStyle body2Bold =
    TextStyle(fontSize: 14, height: 1.96, fontWeight: FontWeight.bold);
TextStyle body2Underlined =
    TextStyle(fontSize: 14, height: 1.96, decoration: TextDecoration.underline);
TextStyle body3 = TextStyle(fontSize: 12, height: 1.6);
TextStyle body3Bold =
    TextStyle(fontSize: 12, height: 1.6, fontWeight: FontWeight.bold);

// footerFonts
TextStyle footer = TextStyle(fontSize: 12, height: 1.4);
TextStyle footerBold =
    TextStyle(fontSize: 12, height: 1.4, fontWeight: FontWeight.bold);

// displayFonts
TextStyle display1 =
    TextStyle(fontSize: 100, height: 12, fontWeight: FontWeight.bold);
TextStyle display2 =
    TextStyle(fontSize: 80, height: 9.6, fontWeight: FontWeight.bold);
TextStyle display3 =
    TextStyle(fontSize: 32, height: 3.84, fontWeight: FontWeight.bold);
