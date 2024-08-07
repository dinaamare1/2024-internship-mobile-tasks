import 'package:flutter/material.dart';
import 'package:ecommerce_app_ui/cards.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  RangeValues _currentRange = RangeValues(0, 100);
  bool _showFilter = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Column(
        children: [
          // this is the app bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 25),
                Container(
                  // color: Colors.blue,
                  padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(Icons.arrow_back_ios_rounded, size: 20, color: Colors.blue),
                      ),
                      const SizedBox(width: 95),
                      const Text(
                        "Search Product",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
                //this is the search and the button
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          labelText: "Search",
                          labelStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
                          floatingLabelBehavior: FloatingLabelBehavior.auto,
                          fillColor: Colors.grey[200],
                          filled: true,
                          contentPadding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
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
                      ),
                    ),
                    const SizedBox(width: 5,),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _showFilter = !_showFilter;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        minimumSize: Size(50, 60),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Icon(Icons.filter_list, color: Colors.white),
                    ),
                  ],
                ),
              ],
            ),
          ),
          //this is the list and the stack with the catagory and price and apply buttons/filter bar
          Expanded(
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: ListView.builder(
                    itemCount: 10,
                    itemBuilder: (context, index) {
                      return buildGridCars(10)[index];
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
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                            ),
                            SizedBox(height: 10),
                            TextField(
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
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
                            SizedBox(height: 20),
                            const Text(
                              "Price:",
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
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
                              activeColor: Colors.blue,
                              inactiveColor: Colors.grey
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
                                  minimumSize: Size(152, 50),
                                  backgroundColor: Colors.blue,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: const Text(
                                  "APPLY",
                                  style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500),
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
    );
  }
}
