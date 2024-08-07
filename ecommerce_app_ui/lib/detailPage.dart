import 'package:flutter/material.dart';
import 'package:ecommerce_app_ui/product.dart';
import 'package:ecommerce_app_ui/update.dart';

class DetailPage extends StatefulWidget {
  final Product product;
  final int index;
  final List<Product> products;  
  const DetailPage({
    Key? key,
    required this.product,
    required this.products,
    required this.index,
  }) : super(key: key);

  @override
  State<DetailPage> createState() => _DetailPageState();
}
class _DetailPageState extends State<DetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              Image.asset(
                widget.product.image,
                width: double.infinity,
                height: 286,
                fit: BoxFit.cover,
              ),
              Padding(
                padding: const EdgeInsets.all(30.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          widget.product.catagory,
                          style: TextStyle(fontWeight: FontWeight.w300, fontSize: 16),
                        ),
                        Spacer(),
                        Icon(
                          Icons.star,
                          color: Colors.yellow,
                        ),
                        Text(
                          "(${widget.product.rating})",
                          style: TextStyle(fontWeight: FontWeight.w300),
                        ),
                      ],
                    ),
                    SizedBox(height: 10.0),
                    Row(
                      children: [
                        Text(
                          widget.product.name,
                          style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.w600),
                        ),
                        Spacer(),
                        Text(
                          "\$${widget.product.price}",
                          style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                    SizedBox(height: 20.0),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Size:",
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                        ),
                        SizedBox(height: 10),
                        Container(
                          height: 70,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: sizelist.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: listedButtons(index: sizelist[index]),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 15.0),
                    SingleChildScrollView(
                      child: Container(
                        child: const Text(
                          "A derby leather shoe is a classic and versatile footwear option characterized by its open lacing system, where the shoelace eyelets are sewn on top of the vamp (the upper part of the shoe). This design feature provides a more relaxed and casual look compared to the closed lacing system of oxford shoes. Derby shoes are typically made of high-quality leather, known for its durability and elegance, making them suitable for both formal and casual occasions.",
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                    SizedBox(height: 27.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                          onPressed: () {},
                          child: Text(
                            "DELETE",
                            style: TextStyle(
                                color: Colors.red, fontSize: 14, fontWeight: FontWeight.w500),
                          ),
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(152, 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            side: const BorderSide(
                              color: Colors.red,
                              width: 1,
                            ),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) {
                              return UpdatePage(products:widget.products, index:widget.index);
                            }));
                          },
                          style: ElevatedButton.styleFrom(
                            minimumSize: Size(152, 50),
                            backgroundColor: Colors.blue,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text(
                            "UPDATE",
                            style: TextStyle(
                                color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          Positioned(
            top: 35.0,
            left: 18,
            child: SizedBox(
              width: 40,
              height: 40,
              child: FloatingActionButton(
                backgroundColor: Colors.white,
                shape: const CircleBorder(),
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Center(
                  child: Icon(
                    Icons.arrow_back_ios_new,
                    size: 20,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

List<String> sizelist = ["39", "40", "41", "42", "43"];

Widget listedButtons({required String index}) {
  return Container(
    margin: const EdgeInsets.only(bottom: 8.0),
    child: ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        minimumSize: Size(60, 60),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      child: Text(
        index,
        style: TextStyle(fontSize: 20, color: Colors.black),
      ),
    ),
  );
}
