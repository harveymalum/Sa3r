import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
void main()=>runApp(const Sa3rApp());
class Sa3rApp extends StatelessWidget{
  const Sa3rApp({super.key});
  @override Widget build(BuildContext context)=>MaterialApp(
    debugShowCheckedModeBanner:false,title:'سعّر',
    theme:ThemeData(useMaterial3:true,colorSchemeSeed:Colors.indigo),
    home:const HomeScreen()
  );
}
