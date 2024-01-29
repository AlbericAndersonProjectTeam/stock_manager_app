import 'package:flutter/material.dart';
import 'package:stock_manager_app/styles/colors.dart';

Widget logoStockManager = 
                    CircleAvatar(
                      backgroundColor: secondaryColor,
                      child: Image.asset("assets/icon/logo_avec_fond.png",width: 50.0,),
                );

Widget thicklogoStockManager = 
                    Container(
                      alignment: Alignment.center,
                      height: 250,
                      width: 250,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(50.0)),
                      ),
                      child: Image.asset("assets/icon/logo_avec_fond.png",width: 250.0,),
                );
          