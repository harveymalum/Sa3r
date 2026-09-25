class Store {
  final String id;
  final String name;
  Store({required this.id, required this.name});
  factory Store.fromJson(Map<String,dynamic> j) =>
      Store(id:j['id'],name:j['name']);
}
class Offer {
  final String id;
  final double price;
  final double shippingCost;
  final Store store;
  Offer({required this.id,required this.price,required this.shippingCost,required this.store});
  factory Offer.fromJson(Map<String,dynamic> j)=>Offer(
    id:j['id'],
    price:double.parse(j['price'].toString()),
    shippingCost:double.parse(j['shippingCost'].toString()),
    store:Store.fromJson(j['store']),
  );
}
class Product {
  final String id,name,category;
  final String? brand,model,imageUrl;
  final List<Offer> offers;
  Product({required this.id,required this.name,required this.category,this.brand,this.model,this.imageUrl,required this.offers});
  double get lowestTotalPrice => offers.isEmpty ? 0 :
      offers.map((o)=>o.price+o.shippingCost).reduce((a,b)=>a<b?a:b);
  factory Product.fromJson(Map<String,dynamic> j)=>Product(
    id:j['id'],name:j['name'],category:j['category'],
    brand:j['brand'],model:j['model'],imageUrl:j['imageUrl'],
    offers:(j['offers'] as List? ?? []).map((e)=>Offer.fromJson(e)).toList(),
  );
}
