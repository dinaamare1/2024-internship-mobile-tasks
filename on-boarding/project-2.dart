import 'dart:io';

class Product {
  String? name;
  String? Description;
  double? Price;
  Product(name, Description,double Price){
    this.name = name;
    this.Description = Description;
    this.Price = Price;
  }
  void showData(){
    print(name);
    print(Price);
  }
}
class ProductManger{
  var Products = [];

  void addProducts(Product product){
    Products.add(product);
    print("added sucessfully");
  }
  void viewAll(){
    int num = 1;
    print("number \t Name \t Description \t Price");
    for (var product in Products){
      print("$num \t ${product.name} \t ${product.Description} \t ${product.Price}");
      num ++;
    }
  }
  Product singleElement(index){
    return Products[index-1];
  }
  void delete(index){
  if (index > 0 && index <= Products.length) {
    Product val = Products[index - 1];
    Products.removeAt(index - 1);
    print("${val.name} is deleted");
  } else {
    print("No such product exists");
  }
}

  void Update(index,newName, newDescription,newPrice){
    if (0<= index || index <= Products.length){
      Product edited = Products[index];
      edited.name = newName;
      edited.Description = newDescription;
      edited.Price = newPrice;
      print("updated sucessfully");
    }
    else{
      print("no such Product exits!");
    }
  }

}
void main(){
  print("hello world");
  ProductManger product = ProductManger();

  while(true){
    print('=== eCommerce Application ===');
    print('1. Add Product');
    print('2. View All Products');
    print('3. View a single Product');
    print('4. Edit Product');
    print('5. Delete Product');
    print('Enter your choice:');
    String? choice = stdin.readLineSync();
    int intChoice = int.parse(choice ?? '0');
    switch(intChoice){
      case 1:
        print("enter the name of the new Product");
        String? name = stdin.readLineSync();
        print("enter the Descrption of the Product");
        String? Description = stdin.readLineSync();
        print("enter the Price of the product");
        String? Price = stdin.readLineSync();
        double doublePrice = double.parse(Price ?? '0.00');
        Product newProduct = Product(name, Description, doublePrice);
        product.addProducts(newProduct);
        break;

      case 2:
        if( product.Products.length == 0){
          print("No avaliable Items");
        }
        else{
          print("the Products currently avaliable are:");
          product.viewAll();
        }
        break;
      case 3:
        print("enter the id of product you want to see");
        String? id = stdin.readLineSync();
        var newId = int.parse(id??"0");
        if (newId > 0 && newId <=product.Products.length){
          Product prod = product.singleElement(newId); 
          print("$newId \t ${prod.name} \t ${prod.Description} \t ${prod.Price}  ");
        }
        else{
          print("no product with such id exists");
        }
        break;
      case 4:
        print("enter the id of the product you want to edit");
        String? id = stdin.readLineSync();
        int newId = int.parse(id??'${product.Products.length+1}');
        if (newId <= product.Products.length){
          print("enter the new name");
          String? name= stdin.readLineSync();
          print("enter the new description");
          String? Description = stdin.readLineSync();
          print("enter the new price");
          String? price = stdin.readLineSync();
          double newprice = double.parse(price?? '0');
          if (newprice == 0){
            break;
          }
          product.Update(newId-1, name, Description, newprice);
        }
        else{
          print("No such product");
        }
        break;
      case 5:
        print("enter the id of product you want to delete");
        String? id = stdin.readLineSync();
        int newId = int.parse(id??'0');
        if (newId <= product.Products.length){
          product.delete(newId);
        }
        else{
          print("No such products exist");
        }
      default:
        break;
        
    }
  }
}

