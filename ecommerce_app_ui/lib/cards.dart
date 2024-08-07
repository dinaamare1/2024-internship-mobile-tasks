import 'package:flutter/material.dart';

List<Widget> buildGridCars(int count) {
  return List.generate(count, (int index) {
    return Container(
      margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
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
          const Padding(
            padding: EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: [
                    Text(
                      "Derby Leather Shoes",
                      style: TextStyle(
                          fontSize: 20.0, fontWeight: FontWeight.w500),
                    ),
                    Spacer(),
                    Text(
                      "\$120",
                      style: TextStyle(
                          fontSize: 15.0, fontWeight: FontWeight.w400),
                    )
                  ],
                ),
                SizedBox(height: 10.0),
                Row(
                  children: [
                    Text(
                      "Men's shoe",
                      style: TextStyle(fontWeight: FontWeight.w300),
                    ),
                    Spacer(),
                    Icon(
                      Icons.star,
                      color: Colors.yellow,
                    ),
                    Text(
                      "(4.0)",
                      style: TextStyle(fontWeight: FontWeight.w300),
                    )
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  });
}
