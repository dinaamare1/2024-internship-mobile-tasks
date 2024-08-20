import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/constants.dart';
import '../../../../service_locator.dart';
import '../../../domain/entities/product.dart';
import '../../../domain/usecases/delete_product.dart';
import '../../../domain/usecases/get_single_product.dart';
import '../../Home/bloc/home_bloc.dart';
import '../../Home/home_page_widgets/home_page.dart';
import '../../Update/update_page/update_page.dart';
import '../bloc/details_bloc.dart';

class DetailPage extends StatefulWidget {
  final Product product;
  final String index;
  // final List<Product> products;

  const DetailPage({
    Key? key,
    required this.product,
    // required this.products,
    required this.index,
  }) : super(key: key);

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DetailsBloc(
        getSingleProductUseCase: locator<GetSingleProductUseCase>(),
        deleteProductUseCase: locator<DeleteProductUseCase>(),
      )..add(FetchProductEvent(id: widget.product.id)),
      child: Scaffold(
        body: Stack(
          children: [
            BlocConsumer<DetailsBloc, DetailsPageState>(
              listener: (context, state) {
                if (state.status == DetailsPageStatusEnum.deleted) {
                  context.read<HomeBloc>().add(const FetchProductsEvent());
                  Navigator.of(context).pop();
                  
                } else if (state.status == DetailsPageStatusEnum.error) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Error deleting product.'),
                    ),
                  );
                }
              },
              builder: (context, state) {
                if (state.status == DetailsPageStatusEnum.loading) {
                  return Center(child: CircularProgressIndicator());
                } else if (state.status == DetailsPageStatusEnum.error) {
                  return Center(child: Text('Error loading product.'));
                } else if (state.status == DetailsPageStatusEnum.loaded) {
                  final product = state.product!;
                  return Column(
                    children: [
                      Image.network(
                        product.image ?? Urls.imageUrl,
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
                                  "Product Category",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w300, fontSize: 16),
                                ),
                                Spacer(),
                                Icon(
                                  Icons.star,
                                  color: Colors.yellow,
                                ),
                                Text(
                                  "({product.rating})",
                                  style: TextStyle(fontWeight: FontWeight.w300),
                                ),
                              ],
                            ),
                            SizedBox(height: 10.0),
                            Row(
                              children: [
                                Text(
                                  product.name,
                                  style: TextStyle(
                                      fontSize: 24.0, fontWeight: FontWeight.w600),
                                ),
                                Spacer(),
                                Text(
                                  "\$${product.price}",
                                  style: TextStyle(
                                      fontSize: 16.0, fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                            SizedBox(height: 20.0),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Size:",
                                  style: TextStyle(
                                      fontSize: 20, fontWeight: FontWeight.w500),
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
                                child: Text(
                                  product.description,
                                  style: TextStyle(fontSize: 16),
                                ),
                              ),
                            ),
                            SizedBox(height: 27.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    context.read<DetailsBloc>().add(DeleteProductEvent(id: widget.product.id));
                                    context.read<HomeBloc>().add(FetchProductsEvent());
                                  },
                                  child: Text(
                                    "DELETE",
                                    style: TextStyle(
                                        color: Colors.red,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500),
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
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => UpdatePage(
                                          product: product,
                                          index: widget.index,
                                          detailsBloc: BlocProvider.of<DetailsBloc>(context)
                                        ),
                                      ),
                                    );
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
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                }
                return SizedBox.shrink();
              },
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
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => HomeView()),
                    );
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
      ),
    );
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
}
