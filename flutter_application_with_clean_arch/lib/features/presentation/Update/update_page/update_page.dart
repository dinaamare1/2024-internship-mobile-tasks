import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../service_locator.dart';
import '../../../domain/entities/product.dart';
import '../../../domain/usecases/update_product.dart';
import '../../Details/bloc/details_bloc.dart';
import '../../Details/details_page/details_page.dart';
import '../bloc/update_bloc.dart';
import '../bloc/update_state.dart';

class UpdatePage extends StatefulWidget {
  final String index;
  final Product product;
  final DetailsBloc detailsBloc;
  const UpdatePage({super.key, required this.product, required this.index, required this.detailsBloc});
  _UpdatePageState createState() => _UpdatePageState();
}

class _UpdatePageState extends State<UpdatePage> {
  late TextEditingController _nameController;
  late TextEditingController _priceController;
  late TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();

    _nameController = TextEditingController(text: widget.product.name);
    _priceController =
        TextEditingController(text: widget.product.price.toString());
    _descriptionController =
        TextEditingController(text: widget.product.description);
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   context.read<UpdateBloc>().add(ProductNameChanged(_nameController.text));
    //   context.read<UpdateBloc>().add(ProductPriceChanged(_priceController.text));
    //   context.read<UpdateBloc>().add(ProductDescriptionChanged(_descriptionController.text));
    // });
  }
  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => UpdateBloc(
        updateProductUseCase: locator<UpdateProductUseCase>(),
      ),
      child: BlocConsumer<UpdateBloc, UpdateState>(
        listener: (context, state) {
          if (state.pageStatus == UpdateStateeEnum.updated) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Product updated successfully.")),
            );
            final updatedProduct = Product(
              id: widget.index,
              name: _nameController.text,
              price: double.parse(_priceController.text),
              description: _descriptionController.text,
              image: widget.product.image,
            );
            Navigator.of(context).push(MaterialPageRoute(builder: (context)=>DetailPage(product: updatedProduct, index: updatedProduct.id)));
          } else if (state.pageStatus == UpdateStateeEnum.error) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Update failed. Please try again.")),
            );
          }
        },
        builder: (context, state) {
          return Scaffold(
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 25),
                  Container(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(builder: (context)=>DetailPage(product: widget.product, index: widget.index)));
                          },
                          icon: const Icon(Icons.arrow_back_ios_rounded,
                              size: 20),
                        ),
                        const SizedBox(width: 100),
                        const Text(
                          "Update Product",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                  Center(
                    child: Container(
                      width: 366,
                      height: 230,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(8.0),
                        border: Border.all(color: Colors.white),
                      ),
                      child: widget.product.image != null
                          ? Image.network(
                              widget.product.image!,
                              fit: BoxFit.cover,
                            )
                          : Center(
                              child: Text(
                                "No Image Available",
                                style: TextStyle(color: Colors.grey[800]),
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(22, 0, 22, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Name:',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8.0),
                        SizedBox(
                          height: 50,
                          child: TextField(
                            controller: _nameController,
                            onChanged: (value ) => context
                                .read<UpdateBloc>()
                                .add(ProductNameChanged(value)),
                            decoration: InputDecoration(
                              fillColor: Colors.grey[200],
                              filled: true,
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 15, horizontal: 15),
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
                        const SizedBox(height: 10),
                        const Text(
                          'Price:',
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(height: 8.0),
                        SizedBox(
                          height: 50,
                          child: TextField(
                            controller: _priceController,
                            keyboardType: TextInputType.number,
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            onChanged: (value) => context
                                .read<UpdateBloc>()
                                .add(ProductPriceChanged(value)),
                            decoration: InputDecoration(
                              fillColor: Colors.grey[200],
                              filled: true,
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 15, horizontal: 15),
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
                        const SizedBox(height: 10),
                        const Text(
                          'Description:',
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(height: 8.0),
                        SizedBox(
                          height: 200,
                          child: TextField(
                            controller: _descriptionController,
                            onChanged: (value) => context
                                .read<UpdateBloc>()
                                .add(ProductDescriptionChanged(value)),
                            decoration: InputDecoration(
                              fillColor: Colors.grey[200],
                              filled: true,
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 15, horizontal: 15),
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
                            maxLines: 10,
                          ),
                        ),
                        const SizedBox(height: 40),
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: () {
                              context.read<UpdateBloc>().add(
                                    UpdateProductSubmitted(
                                      id: widget.index,
                                      product: widget.product,
                                      name: _nameController.text,
                                      price: double.parse(_priceController.text),
                                      description: _descriptionController.text,
                                    ),
                                  );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                            ),
                            child: const Text(
                              'Update Product',
                              style: TextStyle(fontSize: 16, color: Colors.white),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
