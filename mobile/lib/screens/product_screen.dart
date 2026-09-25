import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/product.dart';

class ProductScreen extends StatefulWidget{
  final String productId;
  const ProductScreen({super.key,required this.productId});
  @override State<ProductScreen> createState()=>_ProductScreenState();
}
class _ProductScreenState extends State<ProductScreen>{
  Product? p; String? error;
  @override void initState(){super.initState();load();}
  Future<void> load()async{try{p=await ApiService().getProduct(widget.productId);setState((){});}catch(e){error=e.toString();setState((){});}}
  @override Widget build(BuildContext context)=>Directionality(
    textDirection:TextDirection.rtl,
    child:Scaffold(appBar:AppBar(title:const Text('مقارنة الأسعار')),
      body:p==null?Center(child:error==null?const CircularProgressIndicator():Text(error!)):
      ListView(padding:const EdgeInsets.all(16),children:[
        Text(p!.name,style:const TextStyle(fontSize:24,fontWeight:FontWeight.bold)),
        const SizedBox(height:16),
        ...p!.offers.map((o)=>Card(child:ListTile(
          title:Text(o.store.name),
          subtitle:Text('الشحن: ${o.shippingCost.toStringAsFixed(0)} جنيه'),
          trailing:Text('${(o.price+o.shippingCost).toStringAsFixed(0)} جنيه',
            style:const TextStyle(fontWeight:FontWeight.bold)),
        )))
      ])
    )
  );
}
