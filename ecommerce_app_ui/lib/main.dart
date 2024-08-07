import 'package:flutter/material.dart';
import 'package:ecommerce_app_ui/add_page.dart';
import 'package:ecommerce_app_ui/detailPage.dart';
import 'package:ecommerce_app_ui/product.dart';
import 'package:ecommerce_app_ui/search_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: RootPage(),
    );
  }
}

class RootPage extends StatefulWidget {
  const RootPage({super.key});

  @override
  State<RootPage> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  final List<Product> products = [
    Product(
      name: "Derby Leather Shoes",
      catagory: "Men's shoe",
      price: 120.0,
      image: "assets/Rectangle_27.png",
      rating: 4.0,
    ),
    Product(
      name: "Jimmy Choo Shoes",
      catagory: "Men's shoe",
      price: 120.0,
      image: "assets/Rectangle_27.png",
      rating: 4.0,
    ),
    Product(
      name: "Boss Lady Shoes",
      catagory: "Women's shoe",
      price: 120.0,
      image: "assets/Rectangle_27.png",
      rating: 4.0,
    ),
    
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
          child: Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: Color(0xFFCCCCCC),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "July 14, 2023",
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 12,
                        color: Color(0xFFAAAAAA),
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          "Hello,",
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 15,
                          ),
                        ),
                        Text(
                          "Yohannes",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16.0),
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(9.0),
              border: Border.all(
                color: Color(0xFFAAAAAA),
                width: 0.7,
              ),
            ),
            child: Center(
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  const Icon(
                    Icons.notifications_outlined,
                    color: Colors.black,
                    size: 24.0,
                  ),
                  Positioned(
                    right: 3.5,
                    top: 2,
                    child: Container(
                      width: 8.0,
                      height: 8.0,
                      decoration: const BoxDecoration(
                        color: Colors.blue,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      body: Center(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      "Available Products",
                      style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) {
                        return const SearchPage();
                      },
                    ));
                  },
                  child: Container(
                    margin: const EdgeInsets.only(right: 17.0),
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(9.0),
                      border: Border.all(
                        color: Color(0xFFAAAAAA),
                        width: 0.7,
                      ),
                    ),
                    child: const Center(
                      child: Icon(Icons.search),
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: GridView.count(
                crossAxisCount: 1,
                padding: const EdgeInsets.all(16.0),
                childAspectRatio: 6 / 5,
                mainAxisSpacing: 16.0,
                children: buildGridCars(context, products),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: SizedBox(
        width: 72,
        height: 72,
        child: FloatingActionButton(
          onPressed: () {
            // Navigator.of(context).push(PageRouteBuilder(
            //   pageBuilder: (context, animation, secondaryAnimation) => const Addpage(),
            //   transitionsBuilder: (context, animation, secondaryAnimation, child) {
            //     const begin = 0.0;
            //     const end = 1.0;
            //     const curve = Curves.easeInOut;
            //     var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
            //     var scaleAnimation = animation.drive(tween);
            //     return ScaleTransition(scale: scaleAnimation, child: child);
            //   },
            // ));
            Navigator.of(context).push(MaterialPageRoute(
              builder: (BuildContext context) {
                return const Addpage();
              },
            ));
          },
          child: Icon(
            Icons.add,
            color: Colors.white,
            size: 42,
          ),
          backgroundColor: Colors.blue,
          shape: const CircleBorder(),
        ),
      ),
    );
  }

  List<Widget> buildGridCars(BuildContext context, List<Product> products) {
    return products.asMap().entries.map((entry) {
      int index = entry.key;
      Product product = entry.value;
      return GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DetailPage(
                product: product,
                products: products,
                index: index,
              ),
            ),
          );
        },
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(width: 0),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                width: double.infinity,
                height: 200.0,
                child: Image.asset(
                  product.image,
                  fit: BoxFit.cover,
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: [
                        Text(
                          product.name,
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Spacer(),
                        Text(
                          "\$${product.price}",
                          style: TextStyle(
                            fontSize: 15.0,
                            fontWeight: FontWeight.w400,
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: 10.0),
                    Row(
                      children: [
                        Text(
                          product.catagory,
                          style: TextStyle(fontWeight: FontWeight.w300),
                        ),
                        Spacer(),
                        Icon(
                          Icons.star,
                          color: Colors.yellow,
                        ),
                        Text(
                          "(${product.rating})",
                          style: TextStyle(fontWeight: FontWeight.w300),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }).toList();
  }
}
