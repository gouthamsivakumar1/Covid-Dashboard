

 import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget datePicker(DateTime date){

 return  Row(
 children: [
 Icon(Icons.calendar_today),
 SizedBox(width: 10,),
 Text(
 "${date.toLocal()}".split(' ')[0],
 style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
 ),
 ]);
 }