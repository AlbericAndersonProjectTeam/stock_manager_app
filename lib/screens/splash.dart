import 'dart:async';
import 'dart:ui' as ui;
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stock_manager_app/constants/others_constants.dart';
import 'package:stock_manager_app/screens/login.dart';
import 'package:stock_manager_app/styles/colors.dart';

class SplashScreen extends StatefulWidget{
  const SplashScreen({super.key});

  @override
  SplashScreenState createState() => SplashScreenState();
  
}

class SplashScreenState extends State<SplashScreen>{

 late ui.Image image;
  bool isImageloaded = false;

  Future <void> init() async {
    final ByteData data = await rootBundle.load('assets/Images/Bg_splash2.png');
    image = await loadImage( Uint8List.view(data.buffer));
  }

  Future<ui.Image> loadImage(Uint8List img) async {
    final Completer<ui.Image> completer =  Completer();
    ui.decodeImageFromList(img, (ui.Image img) {
      setState(() {
        isImageloaded = true;
      });
      return completer.complete(img);
    });
    return completer.future;
  }

  Widget _buildImage() {
    if (isImageloaded) {
      return  CustomPaint(
            size: Size.infinite,
            painter: CurvedPainter(splashImage: image),
          );
    } else {
      return const CircularProgressIndicator(color: primaryColor,);
    }
  }
  @override
  void initState() {
    super.initState();
    init();
    Timer(const Duration(seconds: 3), () { 
      Navigator.of(context).pushReplacement(
        CustomPageTransistion(page: const LoginScreen(),duration: 2300).maketransition()
      );
    });
  }


  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: isImageloaded ? primaryColor : Colors.white ,
      body: _buildImage(),
    );
  }

}



class CurvedPainter extends CustomPainter {

 CurvedPainter({required this.splashImage});


 ui.Image splashImage;


  @override
  void paint(Canvas canvas, Size size) async {
    var paint = Paint()
      ..color = secondaryColor
      ..strokeWidth = 15;

    var path = Path();


    //Curved Shape
    path.moveTo(0, size.height * 0.25);

    path.quadraticBezierTo(size.width * 0.25, size.height * 0.35,
        size.width * 0.29, size.height * 0.32);
    path.quadraticBezierTo(size.width * 0.32, size.height * 0.295,
        size.width * 0.36, size.height * 0.32);

    path.quadraticBezierTo(size.width * 0.45, size.height * 0.37,
        size.width * 0.49, size.height * 0.35);
    path.quadraticBezierTo(size.width * 0.52, size.height * 0.33,
        size.width * 0.58, size.height * 0.36);

    
    path.quadraticBezierTo(size.width * 0.72, size.height * 0.44,
        size.width * 0.78, size.height * 0.42);
    path.quadraticBezierTo(size.width * 0.83, size.height * 0.40,
        size.width * 0.91, size.height * 0.45);

    path.quadraticBezierTo(size.width * 1.4, size.height * 0.75,
        size.width , size.height * 0.65);

    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);

    canvas.drawPath(path, paint);


    //Complete circle
    Offset center = Offset(size.width * 0.25, size.height *0.42);
    paint.color = primaryColor;
    paint.style = PaintingStyle.stroke;
    paint.strokeWidth = 4;

    canvas.drawCircle(center, 15, paint);


    //Demi Circle bottom left
    center = Offset(0, size.height);
    canvas.drawCircle(center, 60, paint);


    //Demi Circle bottom right
    center = Offset(size.width, size.height*0.86);
    canvas.drawCircle(center, 40, paint);
    
    //Footer text
    const footerTextSpan = TextSpan(
    text: 'Gérez facilement vos stocks',
    style: TextStyle(
      color: primaryColor,
      fontWeight: FontWeight.w900,
      fontSize: 20.0,
      fontStyle: FontStyle.italic
    ),
  );
  
  final textFooterPainter = TextPainter(
    textAlign: TextAlign.center,
    text: footerTextSpan,
    textDirection: TextDirection.ltr,
  );

  textFooterPainter.layout(
    minWidth: 0,
    maxWidth: size.width,
  );

  final offsetFooterText = Offset(size.width * 0.17, size.height*0.91);
  textFooterPainter.paint(canvas, offsetFooterText);

   //Header text
    const headerTextSpan = TextSpan(
    children: <TextSpan>[
      TextSpan(
        text: 'Bienvenue sur \n',
        
        style: TextStyle(
          color: Colors.white,
          fontSize: 35.0,
          fontFamily: 'Times New Roman'
        )
      ),
      TextSpan(
        text: 'Stock Manager',
        style: TextStyle(
          color: Colors.white,
          fontSize: 45.0,
          fontFamily: 'Arial',
          height: 1.5
        )
      )
    ]
  );
  
  final textHeaderPainter = TextPainter(
    textAlign: TextAlign.center,
    text: headerTextSpan,
    textDirection: TextDirection.ltr,
  );

  textHeaderPainter.layout(
    minWidth: 0,
    maxWidth: size.width,
  );


  final offsetHeaderText = Offset(size.width * 0.10, size.height*0.12);
  textHeaderPainter.paint(canvas, offsetHeaderText);

  //Image

   Future<ByteData?> data = splashImage.toByteData();
   data = data;

   final imageOffset = Offset(size.width*0.10,size.height*0.50);
   canvas.drawImage(splashImage, imageOffset, paint);

  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}