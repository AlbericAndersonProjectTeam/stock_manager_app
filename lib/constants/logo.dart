import 'package:flutter/material.dart';
import 'package:stock_manager_app/styles/colors.dart';

const Widget logoStockManager = 
                    CircleAvatar(
                      backgroundColor: secondaryColor,
                      child: Text('LOGO',textAlign: TextAlign.center,style: TextStyle(fontSize: 10.0,fontWeight: FontWeight.bold),),
                );

Widget thicklogoStockManager = 
                    Container(
                      alignment: Alignment.center,
                      height: 250,
                      width: 250,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(50.0)),
                        color: secondaryColor,
                      ),
                      child: const Text('GrAND LOGO',textAlign: TextAlign.center,style: TextStyle(fontSize: 10.0,fontWeight: FontWeight.bold),),
                );
          