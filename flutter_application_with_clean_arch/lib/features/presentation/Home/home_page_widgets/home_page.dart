import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../LoginFeatures/presentation/Login/login_page.dart/login_page.dart';
import '../../../../core/constants/constants.dart';
import '../../../domain/entities/product.dart';
import '../../Add/add_page/add_page.dart';
import '../../Details/details_page/details_page.dart';
import '../../Search/search_page/search_page.dart';
import '../bloc/home_bloc.dart';
import '../bloc/home_state.dart';

class HomeView extends StatelessWidget {
  final String? name;
  const HomeView({super.key, this.name});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: const Color(0xFFCCCCCC),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "July 14, 2023",
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                      color: Color(0xFFAAAAAA),
                    ),
                  ),
                  Row(
                    children: [
                      const Text(
                        "Hello,",
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 15,
                        ),
                      ),
                      Text(
                        name ?? "User",
                        style: const TextStyle(
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
        
        automaticallyImplyLeading: false,


        actions: [
          GestureDetector(
            onTap: () {
              BlocProvider.of<HomeBloc>(context).add(const LogoutUserEvent());
                ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: Colors.white,
                  content: const Text(
                  'Logout successful',
                  style: TextStyle(
                    color: Colors.black,
                  ),
                  ),
                ),
              );  
            },
            child: Container(
              margin: const EdgeInsets.only(right: 16.0),
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(9.0),
                border: Border.all(
                  color: const Color(0xFFAAAAAA),
                  width: 0.7,
                ),
              ),
              child: Center(
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    const Icon(
                      Icons.logout_outlined,
                      color: Colors.black,
                      size: 24.0,
                    ),
                    // Positioned(
                    //   right: 3.5,
                    //   top: 2,
                    //   child: Container(
                    //     width: 8.0,
                    //     height: 8.0,
                    //     decoration: const BoxDecoration(
                    //       color: Colors.blue,
                    //       shape: BoxShape.circle,
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          BlocProvider.of<HomeBloc>(context).add(const FetchProductsEvent());
        },
        child: BlocBuilder<HomeBloc, HomePageState>(
          builder: (context, state) {
            if (state.status == HomePageStatusEnum.homeLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state.status == HomePageStatusEnum.homeLoaded) {
              return _buildProductList(context, state.products!);
            } else if (state.status == HomePageStatusEnum.homeError) {
              return const Center(child: Text('Failed to load products'));
            } else if (state.status == HomePageStatusEnum.homeInitial) {
              Future.microtask(() {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                );
              });
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text('Logging out...'),
                  ],
                ),
              );
            }
            else {
              return const Center(child: Text('Welcome!'));
            }
          },
        ),
      ),
      floatingActionButton: SizedBox(
        width: 72,
        height: 72,
        child: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (BuildContext context) {
                return const AddPage();
              },
            ));
          },
          backgroundColor: Colors.blue,
          shape: const CircleBorder(),
          child: const Icon(
            Icons.add,
            color: Colors.white,
            size: 42,
          ),
        ),
      ),
    );
  }

  Widget _buildProductList(BuildContext context, List<Product> products) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Expanded(
              child: Padding(
                padding: EdgeInsets.all(16.0),
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
                    return SearchPage(products: products);
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
                    color: const Color(0xFFAAAAAA),
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
          child: GridView.builder(
            padding: const EdgeInsets.all(16.0),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 1,
              childAspectRatio: 6 / 5,
              mainAxisSpacing: 16.0,
              crossAxisSpacing: 16.0,
            ),
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetailPage(
                        product: product,
                        // products: products,
                        index: product.id
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
                      SizedBox(
                        width: double.infinity,
                        height: 200.0,
                        child: Image.network(
                          product.image ?? Urls.imageUrl,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              children: [
                                Text(
                                  product.name,
                                  style: const TextStyle(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const Spacer(),
                                Text(
                                  "\$${product.price}",
                                  style: const TextStyle(
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10.0),
                            
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
