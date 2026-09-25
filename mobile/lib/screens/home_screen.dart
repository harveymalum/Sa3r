import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/product.dart';
import 'product_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final api = ApiService();
  final c = TextEditingController();
  List<Product> products = [];
  bool loading = false;
  String? error;

  @override
  void initState() { super.initState(); search(); }

  Future<void> search() async {
    setState(() => loading = true);
    try {
      final result = await api.searchProducts(c.text);
      if (!mounted) return;
      setState(() { products = result; error = null; loading = false; });
    } catch (e) {
      if (!mounted) return;
      setState(() { error = 'تعذر الاتصال بالخادم'; loading = false; });
    }
  }

  @override
  Widget build(BuildContext context) => Directionality(
    textDirection: TextDirection.rtl,
    child: Scaffold(
      appBar: AppBar(title: const Text('سعّر')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(children: [
          Row(children: [
            Expanded(child: TextField(
              controller: c,
              onSubmitted: (_) => search(),
              decoration: const InputDecoration(
                hintText: 'ابحث عن منتج...', border: OutlineInputBorder(),
              ),
            )),
            const SizedBox(width: 8),
            FilledButton(onPressed: loading ? null : search, child: const Icon(Icons.search)),
          ]),
          const SizedBox(height: 12),
          if (loading) const LinearProgressIndicator(),
          if (error != null) Padding(
            padding: const EdgeInsets.all(8),
            child: Text(error!, style: const TextStyle(color: Colors.red)),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: search,
              child: ListView.builder(
                physics: const AlwaysScrollableScrollPhysics(),
                itemCount: products.length,
                itemBuilder: (_, i) {
                  final p = products[i];
                  return Card(child: ListTile(
                    leading: p.imageUrl != null && p.imageUrl!.isNotEmpty
                        ? Image.network(p.imageUrl!, width: 55, fit: BoxFit.contain,
                            errorBuilder: (_, __, ___) => const Icon(Icons.shopping_bag))
                        : const Icon(Icons.shopping_bag),
                    title: Text(p.name),
                    subtitle: Text('أقل إجمالي: ${p.lowestTotalPrice.toStringAsFixed(0)} جنيه'),
                    onTap: () => Navigator.push(context,
                      MaterialPageRoute(builder: (_) => ProductScreen(productId: p.id))),
                  ));
                },
              ),
            ),
          ),
        ]),
      ),
    ),
  );
}
