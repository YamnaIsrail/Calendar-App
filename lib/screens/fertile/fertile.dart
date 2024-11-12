import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class fertile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          width: 394,
          height: 951,
          decoration: BoxDecoration(),
          child: Stack(children: <Widget>[
            Positioned(
                top: 175,
                left: 36,
                child: Text(
                  'This phase starts on the first day of your period and ends when you ovulate.'
                      ' During this time, female hormones makes the uterus lining grow thicker,'
                      ' and FSH helps eggs in the ovaries grow. By days 10 to 14, one egg becomes fully mature.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Color.fromRGBO(0, 0, 0, 1),
                      fontFamily: 'Be Vietnam',
                      fontSize: 13,
                      letterSpacing:
                          0 /*percentages not used in flutter. defaulting to zero*/,
                      fontWeight: FontWeight.normal,
                      height: 1),
                )),
            Positioned(
                top: 289,
                left: 0,
                child: Container(
                    width: 393,
                    height: 150,
                    child: Stack(children: <Widget>[
                      Positioned(
                          top: 0,
                          left: 0,
                          child: Container(
                              width: 393,
                              height: 150,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(16),
                                  topRight: Radius.circular(16),
                                  bottomLeft: Radius.circular(16),
                                  bottomRight: Radius.circular(16),
                                ),
                                color: Color.fromRGBO(246, 214, 237, 1),
                              ))),
                      Positioned(
                          top: 7,
                          left: 20,
                          child: Text(
                            'Cervical Mucus',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                color: Color.fromRGBO(0, 0, 0, 1),
                                fontFamily: 'Poppins',
                                fontSize: 16,
                                letterSpacing:
                                    0 /*percentages not used in flutter. defaulting to zero*/,
                                fontWeight: FontWeight.normal,
                                height: 1.5),
                          )),
                      Positioned(
                          top: 33,
                          left: 20,
                          child: Text(
                            'In this phase, cervical mucus may be creamy white and opaque. '
                            'As ovulation gets closer, it turns more plentiful, clear, and elastic,'
                            ' resembling egg whites.',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                color: Color.fromRGBO(0, 0, 0, 1),
                                fontFamily: 'Be Vietnam',
                                fontSize: 13,
                                letterSpacing:
                                    0 /*percentages not used in flutter. defaulting to zero*/,
                                fontWeight: FontWeight.normal,
                                height: 1.3846153846153846),
                          )),
                    ]))),
            Positioned(
                top: 447,
                left: 1,
                child: Container(
                    width: 393,
                    height: 355,
                    decoration: BoxDecoration(),
                    child: Stack(children: <Widget>[
                      Positioned(
                          top: 0,
                          left: 0,
                          child: Container(
                              width: 393,
                              height: 355,
                              child: Stack(children: <Widget>[
                                Positioned(
                                    top: 0,
                                    left: 0,
                                    child: Container(
                                        width: 393,
                                        height: 355,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(16),
                                            topRight: Radius.circular(16),
                                            bottomLeft: Radius.circular(16),
                                            bottomRight: Radius.circular(16),
                                          ),
                                          color: Color.fromRGBO(
                                              253, 205, 225, 0.7699999809265137),
                                        ))),
                                Positioned(
                                    top: 101.80126953125,
                                    left: 33,
                                    child: SvgPicture.asset(
                                        'assets/images/vector13.svg',
                                        semanticsLabel: 'vector13')),
                                Positioned(
                                    top: 15,
                                    left: 19,
                                    child: Text(
                                      'HIGH',
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                          color: Color.fromRGBO(234, 28, 152, 1),
                                          fontFamily: 'Inter',
                                          fontSize: 20,
                                          letterSpacing:
                                              0 /*percentages not used in flutter. defaulting to zero*/,
                                          fontWeight: FontWeight.normal,
                                          height: 1),
                                    )),
                                Positioned(
                                    top: 40,
                                    left: 19,
                                    child: Text(
                                      'Chance of Conception',
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                          color: Color.fromRGBO(234, 28, 152, 1),
                                          fontFamily: 'Inter',
                                          fontSize: 14,
                                          letterSpacing:
                                              0 /*percentages not used in flutter. defaulting to zero*/,
                                          fontWeight: FontWeight.normal,
                                          height: 1),
                                    )),
                                Positioned(
                                    top: 196,
                                    left: 32,
                                    child: Divider(
                                        color: Color.fromRGBO(0, 0, 0, 1),
                                        thickness: 1)),
                                Positioned(
                                    top: 179,
                                    left: 332,
                                    child: Text(
                                      'LOW',
                                      textAlign: TextAlign.right,
                                      style: TextStyle(
                                          color: Color.fromRGBO(234, 28, 152, 1),
                                          fontFamily: 'Inter',
                                          fontSize: 8,
                                          letterSpacing:
                                              0 /*percentages not used in flutter. defaulting to zero*/,
                                          fontWeight: FontWeight.normal,
                                          height: 1),
                                    )),
                                Positioned(
                                    top: 119,
                                    left: 321,
                                    child: Text(
                                      'MEDIUM',
                                      textAlign: TextAlign.right,
                                      style: TextStyle(
                                          color: Color.fromRGBO(234, 28, 152, 1),
                                          fontFamily: 'Inter',
                                          fontSize: 8,
                                          letterSpacing:
                                              0 /*percentages not used in flutter. defaulting to zero*/,
                                          fontWeight: FontWeight.normal,
                                          height: 1),
                                    )),
                                Positioned(
                                    top: 59,
                                    left: 335,
                                    child: Text(
                                      'HIGH',
                                      textAlign: TextAlign.right,
                                      style: TextStyle(
                                          color: Color.fromRGBO(234, 28, 152, 1),
                                          fontFamily: 'Inter',
                                          fontSize: 8,
                                          letterSpacing:
                                              0 /*percentages not used in flutter. defaulting to zero*/,
                                          fontWeight: FontWeight.normal,
                                          height: 1),
                                    )),
                                Positioned(
                                    top: 204,
                                    left: 32,
                                    child: Text(
                                      'Cycle Day 21',
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                          color: Color.fromRGBO(0, 0, 0, 0.5),
                                          fontFamily: 'Inter',
                                          fontSize: 8,
                                          letterSpacing:
                                              0 /*percentages not used in flutter. defaulting to zero*/,
                                          fontWeight: FontWeight.normal,
                                          height: 1),
                                    )),
                                Positioned(
                                    top: 204,
                                    left: 286,
                                    child: Text(
                                      'Conception Chance',
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                          color: Color.fromRGBO(234, 28, 152, 1),
                                          fontFamily: 'Inter',
                                          fontSize: 8,
                                          letterSpacing:
                                              0 /*percentages not used in flutter. defaulting to zero*/,
                                          fontWeight: FontWeight.normal,
                                          height: 1),
                                    )),
                                Positioned(
                                    top: 234,
                                    left: 30,
                                    child: Text(
                                      'Your LH levels, which trigger ovulation, are nearing their peak, indicating that ovulation is approaching'
                                      'The chances of getting pregnant are high, as sperm can survive in the body for up to five days.',
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                          color: Color.fromRGBO(0, 0, 0, 1),
                                          fontFamily: 'Inter',
                                          fontSize: 14,
                                          letterSpacing:
                                              0 /*percentages not used in flutter. defaulting to zero*/,
                                          fontWeight: FontWeight.normal,
                                          height: 1.4285714285714286),
                                    )),
                              ]))),
                    ]))),
            Positioned(
                top: -106,
                left: -1,
                child: //Mask holder Template
                    Container(width: 394, height: 261, child: null)),
            Positioned(
                top: -39,
                left: 23,
                child: Container(
                    width: 25,
                    height: 25,
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(255, 255, 255, 1),
                    ),
                    child: Stack(children: <Widget>[
                      Positioned(
                          top: 7.421875,
                          left: 7.421875,
                          child: SvgPicture.asset('assets/images/vector.svg',
                              semanticsLabel: 'vector')),
                    ]))),
            Positioned(
                top: -6,
                left: 117,
                child: Container(
                    width: 160,
                    height: 161,
                    child: Stack(children: <Widget>[
                      Positioned(
                          top: 0,
                          left: 19,
                          child: Container(
                              width: 119,
                              height: 118,
                              decoration: BoxDecoration(
                                color: Color.fromRGBO(255, 255, 255, 1),
                              ),
                              child: Stack(children: <Widget>[
                                Positioned(
                                    top: 15.722794532775879,
                                    left: 17.17041015625,
                                    child: SvgPicture.asset(
                                        'assets/images/vector.svg',
                                        semanticsLabel: 'vector')),
                                Positioned(
                                    top: 26.294137954711914,
                                    left: 30.164766311645508,
                                    child: Container(
                                        width: 62.21482849121094,
                                        height: 66.74665832519531,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                              Radius.elliptical(62.21482849121094,
                                                  66.74665832519531)),
                                        ))),
                                Positioned(
                                    top: 34.3846435546875,
                                    left: 37.70595932006836,
                                    child: Container(
                                        width: 49.01774597167969,
                                        height: 52.58827590942383,
                                        decoration: BoxDecoration(
                                          color: Color.fromRGBO(
                                              244, 77, 77, 0.7900000214576721),
                                          borderRadius: BorderRadius.all(
                                              Radius.elliptical(49.01774597167969,
                                                  52.58827590942383)),
                                        ))),
                                Positioned(
                                    top: 46.5203971862793,
                                    left: 73.52661895751953,
                                    child: Container(
                                        width: 11.311787605285645,
                                        height: 12.135757446289062,
                                        child: Stack(children: <Widget>[
                                          Positioned(
                                              top: 0,
                                              left: 0,
                                              child: SvgPicture.asset(
                                                  'assets/images/vector.svg',
                                                  semanticsLabel: 'vector')),
                                          Positioned(
                                              top: 1.3579654693603516,
                                              left: 1.2648429870605469,
                                              child: SvgPicture.asset(
                                                  'assets/images/vector.svg',
                                                  semanticsLabel: 'vector')),
                                          Positioned(
                                              top: 1.8349800109863281,
                                              left: 1.1396446228027344,
                                              child: SvgPicture.asset(
                                                  'assets/images/vector.svg',
                                                  semanticsLabel: 'vector')),
                                        ]))),
                                Positioned(
                                    top: 1.314697265625,
                                    left: 1,
                                    child: SvgPicture.asset(
                                        'assets/images/vector.svg',
                                        semanticsLabel: 'vector')),
                                Positioned(
                                    top: 61.43603515625,
                                    left: 72.16845703125,
                                    child: SvgPicture.asset(
                                        'assets/images/vector.svg',
                                        semanticsLabel: 'vector')),
                                Positioned(
                                    top: 111.56804656982422,
                                    left: 81.68995666503906,
                                    child: SvgPicture.asset(
                                        'assets/images/vector.svg',
                                        semanticsLabel: 'vector')),
                                Positioned(
                                    top: 0,
                                    left: 62.87467956542969,
                                    child: SvgPicture.asset(
                                        'assets/images/vector.svg',
                                        semanticsLabel: 'vector')),
                              ]))),
                      Positioned(
                          top: 122,
                          left: 0,
                          child: Text(
                            'Fertile Phase',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Color.fromRGBO(0, 0, 0, 1),
                                fontFamily: 'Be Vietnam',
                                fontSize: 16,
                                letterSpacing:
                                    0 /*percentages not used in flutter. defaulting to zero*/,
                                fontWeight: FontWeight.normal,
                                height: 1),
                          )),
                    ]))),
            Positioned(
                top: 108,
                left: 59,
                child: Container(
                    width: 277,
                    height: 24,
                    child: Stack(children: <Widget>[
                      Positioned(
                          top: 0,
                          left: 253,
                          child: Container(
                              width: 24,
                              height: 24,
                              child: Stack(children: <Widget>[
                                Positioned(
                                    top: 24,
                                    left: 24,
                                    child: Container(
                                        width: 24,
                                        height: 24,
                                        decoration: BoxDecoration(
                                          color: Color.fromRGBO(255, 255, 255, 1),
                                        ),
                                        child: Stack(children: <Widget>[
                                          Positioned(
                                              top: 4.026750087738037,
                                              left: 1.999426245689392,
                                              child: SvgPicture.asset(
                                                  'assets/images/vector.svg',
                                                  semanticsLabel: 'vector')),
                                        ]))),
                              ]))),
                      Positioned(
                          top: 0,
                          left: 24,
                          child: Container(
                              width: 24,
                              height: 24,
                              child: Stack(children: <Widget>[
                                Positioned(
                                    top: 24,
                                    left: -24,
                                    child: Container(
                                        width: 24,
                                        height: 24,
                                        decoration: BoxDecoration(
                                          color: Color.fromRGBO(255, 255, 255, 1),
                                        ),
                                        child: Stack(children: <Widget>[
                                          Positioned(
                                              top: 4.026750087738037,
                                              left: 1.999426245689392,
                                              child: SvgPicture.asset(
                                                  'assets/images/vector.svg',
                                                  semanticsLabel: 'vector')),
                                        ]))),
                              ]))),
                    ]))),
          ])),
    );
  }
}
