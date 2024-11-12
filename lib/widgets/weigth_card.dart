import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class WeightCard extends StatelessWidget {
  final String name;
  final String value;

  const WeightCard({
    Key? key,
    required this.name,
    required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 384,
      height: 318,
      decoration: BoxDecoration(),
      child: Stack(
        children: <Widget>[
          Positioned(
            top: 0,
            left: 0,
            child: Container(
              width: 384,
              height: 318,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25),
                  topRight: Radius.circular(25),
                ),
                color: Color.fromRGBO(255, 255, 255, 1),
              ),
            ),
          ),
          Positioned(
            top: 23,
            left: 82,
            child: Text(
              name,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color.fromRGBO(0, 0, 0, 1),
                fontFamily: 'Arimo',
                fontSize: 20,
                fontWeight: FontWeight.normal,
                height: 0.7,
              ),
            ),
          ),
          Positioned(
            top: 163,
            left: 149,
            child: Container(
              width: 94,
              height: 30,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Color.fromRGBO(234, 228, 228, 0.61),
              ),
            ),
          ),
          Positioned(
            top: 159,
            left: 88,
            child: Container(
              width: 215,
              height: 38,
              child: Stack(
                children: <Widget>[
                  Positioned(
                    top: 0,
                    left: 0,
                    child: Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(242, 154, 204, 1),
                        borderRadius: BorderRadius.all(Radius.circular(19)),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 0,
                    left: 177,
                    child: Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(234, 28, 152, 0.4),
                        borderRadius: BorderRadius.all(Radius.circular(19)),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 7,
                    left: 184,
                    child: Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(255, 255, 255, 1),
                      ),
                      child: Stack(
                        children: <Widget>[
                          Positioned(
                            top: 5,
                            left: 5,
                            child: SvgPicture.asset(
                              'assets/images/vector.svg',
                              semanticsLabel: 'vector',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    top: 20,
                    left: 12,
                    child: SvgPicture.asset(
                      'assets/images/line14.svg',
                      semanticsLabel: 'line14',
                    ),
                  ),
                  Positioned(
                    top: 3,
                    left: 70,
                    child: Text(
                      value,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color.fromRGBO(0, 0, 0, 1),
                        fontFamily: 'Arial Nova',
                        fontSize: 26,
                        fontWeight: FontWeight.normal,
                        height: 1,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 76,
            left: 141,
            child: Container(
              width: 110,
              height: 29,
              child: Stack(
                children: <Widget>[
                  Positioned(
                    top: 0,
                    left: 0,
                    child: Container(
                      width: 110,
                      height: 29,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Color.fromRGBO(198, 225, 251, 0.63),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 2,
                    left: 54,
                    child: Container(
                      width: 55,
                      height: 25,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(9),
                        color: Color.fromRGBO(255, 255, 255, 1),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 6,
                    left: 21,
                    child: Text(
                      'kg',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        color: Color.fromRGBO(0, 0, 0, 1),
                        fontFamily: 'Inter',
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                        height: 1,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 6,
                    left: 74,
                    child: Text(
                      'lb',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        color: Color.fromRGBO(0, 0, 0, 1),
                        fontFamily: 'Inter',
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                        height: 1,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 246,
            left: 126,
            child: Container(
              width: 132,
              height: 37,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Color.fromRGBO(234, 28, 152, 1),
              ),
            ),
          ),
          Positioned(
            top: 252,
            left: 142,
            child: Text(
              'Done',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color.fromRGBO(255, 255, 255, 1),
                fontFamily: 'Arial Nova',
                fontSize: 20,
                fontWeight: FontWeight.normal,
                height: 1,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
