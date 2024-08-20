import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/product_model.dart';
import 'local_contracts.dart';

class LocalDataSourceImp implements ProductLocalDataSource {

   final SharedPreferences sharedPreferences;

   LocalDataSourceImp({required this.sharedPreferences});
    final Key = 'ProductKey';
   
    @override
     Future<bool> cachedProducts(List<ProductModel> products) async {
      var mapped = products.map((product)=>product.toJson()).toList();
      final jsonMap = json.encode(mapped);
      bool response = await sharedPreferences.setString(Key, jsonMap);
      if (response == false){
        throw Exception('no cached element');
        // return false;
        
      }
      return true;

     }
   
     @override
     Future<bool> deleteProduct(String id) async {
        var response = sharedPreferences.getString(Key);
        if (response != null){
          List<ProductModel> products =  _jsonToProductList(response);
          var index = 0;
          for (var product in products){
            if (product.id == id){
              products.removeAt(index);
              await cachedProducts(products);
              return true;
            }
            index ++;
          }
          throw Exception('product not found');
        }
        else{
          throw Exception('error occcoured getting the response');
        }
     }
     @override
     Future<List<ProductModel>> getAllProdcuts() async {
      var response = sharedPreferences.getString(Key);
      if (response != null){
        List<ProductModel> listOfProducts = _jsonToProductList(response);
        return listOfProducts;
      }
      else{
      throw Exception('no element was cached');
      }
     }
    List<ProductModel> _jsonToProductList(String response) {
     var listJson = json.decode(response);
      List<ProductModel> listOfCachedProducts = [];
      for(var li in listJson){
        listOfCachedProducts.add(ProductModel.fromJson(li));
      }
      return listOfCachedProducts;
    }
    
     @override
    ProductModel getSingleProduct(String id) {
      var response = sharedPreferences.getString(Key);
      if (response != null){
        List<ProductModel> products =  _jsonToProductList(response);
        for (var product in products){
          if (product.id == id){
            return product;
          }
        }
        throw Exception('product not found');
      }
      else{
        throw Exception('no response');
      }
     }
    //what is this doing
    
     @override
     Future<ProductModel> updateProduct(String id,ProductModel updatedProduct) async {
        var response = sharedPreferences.getString(Key);
        if (response != null){
          List<ProductModel> products =  _jsonToProductList(response);
          var index = 0;
          for (var product in products){
            if (product.id == id){
              products[index] = updatedProduct;
              await cachedProducts(products);
              return products[index];
            }
            index ++;
          }
          throw Exception('product not found');
        }
        else{
          throw Exception('could not find a response');
        }
     }
}