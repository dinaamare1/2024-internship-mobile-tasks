import 'dart:io';
import 'package:formz/formz.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/services.dart';

import '../../Home/bloc/home_bloc.dart';
import '../bloc/add_bloc.dart';
import '../bloc/add_event.dart';
import '../bloc/add_state.dart';

class AddPage extends StatefulWidget {
  const AddPage({super.key});

  @override
  State<AddPage> createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  File? _image;

  final _nameController = TextEditingController();
  final _categoryController = TextEditingController();
  final _priceController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _categoryController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final status = await Permission.storage.request();

    if (status.isGranted) {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        setState(() {
          _image = File(pickedFile.path);
        });
        context.read<AddBloc>().add(ProductImageChanged(pickedFile.path));
      }
    } else if (status.isDenied) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Permission denied to access gallery")),
      );
    } else if (status.isPermanentlyDenied) {
      openAppSettings();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: BlocConsumer<AddBloc, AddState>(
            listener: (context, state) {
              if (state.status.isInProgress) {
                // Optionally show a loading indicator
              } else if (state.status.isSuccess) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Product added successfully!')),
                );
                // Fetch the updated list of products
                context.read<HomeBloc>().add(const FetchProductsEvent());

                // Navigate back to the previous screen
                Navigator.of(context).pop();
              } else if (state.status.isFailure) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Failed to add product. Please check all fields.')),
                );
              }
            },
            builder: (context, state) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 25),
                  Container(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: const Icon(Icons.arrow_back_ios_rounded, size: 20),
                        ),
                        const SizedBox(width: 100),
                        const Text(
                          "Add Products",
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: _pickImage,
                    child: Center(
                      child: Container(
                        width: double.infinity,
                        height: 190,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(8.0),
                          border: Border.all(color: Colors.white),
                        ),
                        child: _image == null
                            ? Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const SizedBox(height: 10),
                                  Icon(
                                    Icons.image_outlined,
                                    color: Colors.grey[800],
                                  ),
                                  Text(
                                    "Upload Image",
                                    style: TextStyle(color: Colors.grey[800]),
                                  ),
                                ],
                              )
                            : Image.file(
                                _image!,
                                fit: BoxFit.cover,
                              ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: 'Name',
                      fillColor: Colors.grey[200],
                      filled: true,
                      border: const OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      context.read<AddBloc>().add(ProductNameChanged(value));
                    },
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (_) {
                      return state.name.isNotValid ? 'Name cannot be empty' : null;
                    },
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _categoryController,
                    decoration: InputDecoration(
                      labelText: 'Category',
                      fillColor: Colors.grey[200],
                      filled: true,
                      border: const OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      // Handle category change if needed
                    },
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _priceController,
                    decoration: InputDecoration(
                      labelText: 'Price',
                      fillColor: Colors.grey[200],
                      filled: true,
                      border: const OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly
                    ],
                    onChanged: (value) {
                      context.read<AddBloc>().add(ProductPriceChanged(value));
                    },
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (_) {
                      return state.price.isNotValid ? 'Invalid price' : null;
                    },
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _descriptionController,
                    decoration: InputDecoration(
                      labelText: 'Description',
                      fillColor: Colors.grey[200],
                      filled: true,
                      border: const OutlineInputBorder(),
                    ),
                    maxLines: 5,
                    onChanged: (value) {
                      context.read<AddBloc>().add(ProductDescriptionChanged(value));
                    },
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (_) {
                      return state.description.isNotValid ? 'Description cannot be empty' : null;
                    },
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      context.read<AddBloc>().add(const AddProductSubmitted());
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: state.status.isInProgress
                        ? const CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          )
                        : const Text(
                            "ADD",
                            style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500),
                          ),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      // Handle delete functionality if needed
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      side: const BorderSide(
                        color: Colors.red,
                        width: 1,
                      ),
                    ),
                    child: const Text(
                      "DELETE",
                      style: TextStyle(color: Colors.red, fontSize: 14, fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
