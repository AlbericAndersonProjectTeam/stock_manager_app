import 'package:flutter/material.dart';

class OnProcess extends StatelessWidget{
  const OnProcess({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        children: [
          CircularProgressIndicator(),
          Text("Récupération des données en ligne..."),
                    ],
                    ),);
  }

}

class ErrorFetchingData extends StatelessWidget{
  const ErrorFetchingData({super.key});

  @override
  Widget build(BuildContext context) {
    return const  Center(
                      child:  Text("Récupération des données en ligne..."),
                    );
  }

}