import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomePage extends StatefulWidget {
  static String routeName = "/homePage";

  const HomePage({Key? key}) : super(key: key);
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff020202),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Color(0xff020202),
        title: Text('LoVers'),
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: MediaQuery.of(context).size.width * .9,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(26),
                  color: Color(0xff1b1b1b),
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 010, left: 10, right: 10, bottom: 10),
                      child: Image.asset(
                        "assets/modelo.png",
                        height: 300,
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            width: MediaQuery.of(context).size.width * .9,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(26),
              color: Color(0xff1b1b1b),
            ),
            child: Column(
              children: const [
                Padding(
                  padding:
                      EdgeInsets.only(top: 0, left: 20, right: 20, bottom: 20),
                  child: Text(
                    "Sarah Richard W.",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                      letterSpacing: 2.10,
                    ),
                  ),
                ),
                Text(
                  "Una chica divertida, honesta y cool.\nNo tengo hijos y estoy buscando algo\nestable.",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                  ),
                )
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                  width: 88,
                  height: 90,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xff1db9fc),
                  ),
                  child: SvgPicture.asset("assets/deny.svg")),
              const SizedBox(
                width: 10,
              ),
              Container(
                width: 88,
                height: 90,
                child: SvgPicture.asset("assets/love.svg"),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xff1db9fc),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
