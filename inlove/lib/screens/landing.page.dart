import 'package:flutter/material.dart';
import 'package:inlove/routes/export.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({Key? key}) : super(key: key);
  static String routeName = "/landingPage";
  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        child: Column(
          children: [
            SizedBox(
              height: 100.dH,
            ),
            SvgPicture.asset(
              AppImages.assetNameLanding,
              height: 356.dH,
              width: 354.dW,
            ),
            SizedBox(height: 50.dH),
            Text(
              "It’s time to find Love",
              style: TextStyle(
                color: Colors.white,
                fontSize: 28.fS,
              ),
            ),
            SizedBox(height: 50.dH),
            GestureDetector(
              onTap: () {
                // print('next');
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  LoginPage.routeName,
                  (route) => false,
                );
              },
              child: SvgPicture.asset(
                AppImages.assetName,
              ),
            )
          ],
        ),
      ),
    );
  }

  // Widget _buildBase() {
  //   return Container(
  //     width: 390,
  //     height: 844,
  //     color: const Color(0xff020202),
  //     child: Stack(
  //       children: [
  //         Positioned(
  //           left: 117,
  //           top: 638,
  //           child: Container(
  //             width: 172,
  //             height: 171,
  //             decoration: BoxDecoration(
  //               borderRadius: BorderRadius.circular(8),
  //               border: Border.all(
  //                 color: const Color(0x4f05f0ff),
  //                 width: 3,
  //               ),
  //               color: const Color(0x7f7f3a44),
  //             ),
  //             child: Stack(
  //               children: [
  //                 Positioned.fill(
  //                   child: Align(
  //                     alignment: Alignment.center,
  //                     child: Container(
  //                       width: 139,
  //                       height: 138,
  //                       decoration: BoxDecoration(
  //                         borderRadius: BorderRadius.circular(8),
  //                         border: Border.all(
  //                           color: const Color(0x4f05f0ff),
  //                           width: 3,
  //                         ),
  //                         color: const Color(0x7f7f3a44),
  //                       ),
  //                     ),
  //                   ),
  //                 ),
  //                 Positioned.fill(
  //                   child: Align(
  //                     alignment: Alignment.center,
  //                     child: Container(
  //                       width: 105,
  //                       height: 108,
  //                       decoration: BoxDecoration(
  //                         borderRadius: BorderRadius.circular(8),
  //                         border: Border.all(
  //                           color: const Color(0x4f05f0ff),
  //                           width: 3,
  //                         ),
  //                         color: const Color(0x7f7f3a44),
  //                       ),
  //                     ),
  //                   ),
  //                 ),
  //                 Positioned.fill(
  //                   child: Align(
  //                     alignment: Alignment.center,
  //                     child: Container(
  //                       width: 68,
  //                       height: 67,
  //                       decoration: const BoxDecoration(
  //                         shape: BoxShape.circle,
  //                         color: const Color(0xff1db9fc),
  //                       ),
  //                     ),
  //                   ),
  //                 ),
  //                 Positioned.fill(
  //                   child: Align(
  //                     alignment: Alignment.center,
  //                     child: Container(
  //                       width: 99,
  //                       height: 65,
  //                       decoration: BoxDecoration(
  //                         borderRadius: BorderRadius.circular(8),
  //                       ),
  //                       child: const FlutterLogo(size: 65),
  //                     ),
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           ),
  //         ),
  //         Positioned(
  //           left: 36,
  //           top: 141,
  //           child: Container(
  //             width: 354,
  //             height: 356,
  //             decoration: const BoxDecoration(
  //               shape: BoxShape.circle,
  //               color: Color(0xff494746),
  //             ),
  //           ),
  //         ),
  //         Positioned(
  //           left: 18,
  //           top: 109,
  //           child: Container(
  //             width: 354,
  //             height: 356,
  //             decoration: BoxDecoration(
  //               borderRadius: BorderRadius.circular(8),
  //             ),
  //             child: const FlutterLogo(size: 354),
  //           ),
  //         ),
  //         const Positioned(
  //           left: 100,
  //           top: 556,
  //           child: Text(
  //             "It’s time to fine Love",
  //             style: TextStyle(
  //               color: Colors.white,
  //               fontSize: 28,
  //             ),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

}
