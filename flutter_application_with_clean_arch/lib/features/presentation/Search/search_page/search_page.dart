import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/product.dart';
import '../bloc/search_bloc.dart';
import '../bloc/search_state.dart';

class SearchPage extends StatefulWidget {
  final List<Product> products;

  const SearchPage({super.key, required this.products});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  RangeValues _currentRange = RangeValues(0, 100);
  bool _showFilter = false;
  TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SearchBloc(initialProducts: widget.products),
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 25),
                  Container(
                    padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: const Icon(Icons.arrow_back_ios_rounded,
                              size: 20, color: Colors.blue),
                        ),
                        const SizedBox(width: 95),
                        const Text(
                          "Search Product",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _searchController,
                          decoration: InputDecoration(
                            labelText: "Search",
                            labelStyle: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w400),
                            floatingLabelBehavior: FloatingLabelBehavior.auto,
                            fillColor: Colors.grey[200],
                            filled: true,
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 20, horizontal: 15),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: const BorderSide(
                                color: Colors.white,
                                width: 2.0,
                              ),
                            ),
                            focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.blue),
                            ),
                          ),
                          onChanged: (value) {
                            context
                                .read<SearchBloc>()
                                .add(SearchProducts(query: value));
                          },
                        ),
                      ),
                      const SizedBox(width: 5),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _showFilter = !_showFilter;
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          minimumSize: const Size(50, 60),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child:
                            const Icon(Icons.filter_list, color: Colors.white),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          Expanded(
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: BlocConsumer<SearchBloc, SearchState>(
                      listener: (context, state) {
                        if (state is SearchError) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(state.message),
                            ),
                          );
                        }
                      },
                      builder: (context, state) {
                        if (state is SearchLoading) {
                          return const Center(
                              child: CircularProgressIndicator());
                        } else if (state is SearchLoaded) {
                          return ListView.builder(
                            itemCount: state.products.length,
                            itemBuilder: (context, index) {
                              return buildProductCard(state.products[index]);
                            },
                          );
                        } else if (state is SearchError) {
                          return Center(child: Text(state.message));
                        } else {
                          return const Center(
                              child: Text('No products found'));
                        }
                      },
                    ),
                  ),
                  if (_showFilter)
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        color: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Category:",
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w400),
                              ),
                              const SizedBox(height: 10),
                              TextField(
                                // Uncomment and use this if you have category filtering
                                // onChanged: (value) {
                                //   context.read<SearchBloc>().add(FilterByCategory(category: value));
                                // },
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.symmetric(
                                      vertical: 15, horizontal: 15),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    borderSide: const BorderSide(
                                      color: Colors.grey,
                                      width: 1.0,
                                    ),
                                  ),
                                  focusedBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.blue),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
                              const Text(
                                "Price:",
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w400),
                              ),
                              RangeSlider(
                                values: _currentRange,
                                min: 0,
                                max: 100,
                                labels: RangeLabels(
                                  _currentRange.start.round().toString(),
                                  _currentRange.end.round().toString(),
                                ),
                                onChanged: (RangeValues values) {
                                  setState(() {
                                    _currentRange = values;
                                  });
                                },
                                onChangeEnd: (RangeValues values) {
                                  context.read<SearchBloc>().add(
                                      UpdatePriceFilter(priceRange: values));
                                },
                                activeColor: Colors.blue,
                                inactiveColor: Colors.grey,
                              ),
                              const SizedBox(height: 20),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      _showFilter = false;
                                    });
                                  },
                                  style: ElevatedButton.styleFrom(
                                    minimumSize: const Size(152, 50),
                                    backgroundColor: Colors.blue,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  child: const Text(
                                    "APPLY",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildProductCard(Product product) {
    return Container(
      margin: const EdgeInsets.fromLTRB(0, 0, 0, 10),
      decoration: BoxDecoration(
        border: Border.all(width: 0),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
            child: Image.asset(
              "assets/Rectangle_27.png",
              width: double.infinity,
              height: 200.0,
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
                          fontSize: 20.0, fontWeight: FontWeight.w500),
                    ),
                    const Spacer(),
                    Text(
                      "\$${product.price}",
                      style: const TextStyle(
                          fontSize: 15.0, fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
                const SizedBox(height: 10.0),
                Row(
                  children: [
                    Text(
                      "5", // Assuming the product has a category property
                      style: const TextStyle(fontWeight: FontWeight.w300),
                    ),
                    const Spacer(),
                    const Icon(
                      Icons.star,
                      color: Colors.yellow,
                    ),
                    Text(
                      "(4.0)", // Example rating, replace with actual rating if available
                      style: const TextStyle(fontWeight: FontWeight.w300),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
