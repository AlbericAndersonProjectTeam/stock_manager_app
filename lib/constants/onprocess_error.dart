import 'package:flutter/material.dart';
import 'package:stock_manager_app/styles/colors.dart';

class OnProcess extends StatelessWidget{
  const OnProcess({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
        children: [
          SizedBox(height: MediaQuery.of(context).size.height*0.30,),
          const Center(child: Column(children: [
             const CircularProgressIndicator(color: primaryColor,),
             const SizedBox(height: 5.0,),
             const Text("Chargement des données ...")
          ],)),
                    ],
                    );
  }

}

class ErrorFetchingData extends StatelessWidget{
  const ErrorFetchingData({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
        children: [
          SizedBox(height: MediaQuery.of(context).size.height*0.30,),
          const Center(child: Text("Récupération des données en ligne..."),)
                    ],
                    );
  }

}