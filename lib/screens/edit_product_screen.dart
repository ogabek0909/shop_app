import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/product.dart';
import 'package:shop_app/providers/products.dart';

class EditProductScreen extends StatefulWidget {
  const EditProductScreen({super.key});
  static const routeName = 'EditProductScreen';

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _discriptionFocusNode = FocusNode();
  final _imageFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _form = GlobalKey<FormState>();
  Product _editedProduct =
      Product(id: '', title: '', description: '', price: 0, imageUrl: '');

  var _initValues = {
    'title': '',
    'description': '',
    'price': '',
    'imageUrl': '',
  };
  var _isInit = true;
  var _isLoading = false;

  @override
  void initState() {
    _imageFocusNode.addListener(_updateImageUrl);
    super.initState();
  }

  void _updateImageUrl() {
    if (!_imageFocusNode.hasFocus) {
      if ((!_imageUrlController.text.startsWith('http') &&
              !_imageUrlController.text.startsWith('https')) ||
          (!_imageUrlController.text.endsWith('.png') &&
              !_imageUrlController.text.endsWith('.jpg') &&
              !_imageUrlController.text.endsWith('.jpeg'))) {
        return;
      }
      setState(() {});
    }
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final productId = ModalRoute.of(context)!.settings.arguments;
      if (productId != null) {
        _editedProduct = Provider.of<Products>(context, listen: false)
            .findById(productId as String);
        _initValues = {
          'title': _editedProduct.title,
          'description': _editedProduct.description,
          'price': _editedProduct.price.toString(),
          // 'imageUrl': _editedProduct.imageUrl,
          'imageUrl': '',
        };
        _imageUrlController.text = _editedProduct.imageUrl;
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _discriptionFocusNode.dispose();
    _imageFocusNode.dispose();
    _priceFocusNode.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  Future<void> _saveForm() async{
    final a = _form.currentState!.validate();
    if (!a) {
      return;
    }
    _form.currentState!.save();
    setState(() {
      _isLoading = true;
    });
    if (_editedProduct.id != '') {
      await Provider.of<Products>(context, listen: false)
          .editProduct(_editedProduct.id, _editedProduct);
      
    } else {
      try{
        await Provider.of<Products>(context, listen: false)
          .addProduct(_editedProduct);
      }catch(error){
         await showDialog<Null>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('You have an error'),
            content: const Text('Something went wrong!'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
                child: const Text('Okay'),
              )
            ],
          ),
        );
      }
      // finally{
      //   setState(() {
      //     _isLoading = false;
      //   });
      //   Navigator.of(context).pop();
      // }
      
          
    }
    setState(() {
        _isLoading = false;
      });
      Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    // print(_imageUrlController.text);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Product'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveForm,
          )
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                  key: _form,
                  child: ListView(
                    children: [
                      TextFormField(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Please enter your title";
                          }
                          return null;
                        },
                        initialValue: _initValues['title'],
                        decoration: const InputDecoration(labelText: 'Title'),
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (value) {
                          FocusScope.of(context).requestFocus(_priceFocusNode);
                        },
                        onSaved: (newValue) {
                          _editedProduct = Product(
                            id: _editedProduct.id,
                            title: newValue!,
                            description: _editedProduct.description,
                            price: _editedProduct.price,
                            imageUrl: _editedProduct.imageUrl,
                          );
                        },
                      ),
                      TextFormField(
                        decoration: const InputDecoration(labelText: 'Price'),
                        initialValue: _initValues['price'],
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please, Enter a price!';
                          }
                          if (double.tryParse(value) == null) {
                            return 'Please, Enter a valid number!';
                          }
                          if (double.parse(value) <= 0) {
                            return 'Please, Enter a number greater than zero!';
                          }
                          return null;
                        },
                        onFieldSubmitted: (_) {
                          FocusScope.of(context)
                              .requestFocus(_discriptionFocusNode);
                        },
                        onSaved: (newValue) {
                          _editedProduct = Product(
                            id: _editedProduct.id,
                            title: _editedProduct.title,
                            description: _editedProduct.description,
                            price: double.parse(newValue!),
                            imageUrl: _editedProduct.imageUrl,
                          );
                        },
                        focusNode: _priceFocusNode,
                      ),
                      TextFormField(
                        decoration:
                            const InputDecoration(labelText: 'Description'),
                        initialValue: _initValues['description'],
                        maxLines: 3,
                        focusNode: _discriptionFocusNode,
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.multiline,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please, Enter a description!';
                          }
                          return null;
                        },
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).requestFocus(_imageFocusNode);
                        },
                        onSaved: (newValue) {
                          _editedProduct = Product(
                            id: _editedProduct.id,
                            title: _editedProduct.title,
                            description: newValue!,
                            price: _editedProduct.price,
                            imageUrl: _editedProduct.imageUrl,
                          );
                        },
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                            width: 100,
                            height: 100,
                            margin: const EdgeInsets.only(top: 8, right: 10),
                            decoration: BoxDecoration(border: Border.all()),
                            child: _imageUrlController.text.isEmpty
                                ? const Center(child: Text('Enter image'))
                                : FittedBox(
                                    child:
                                        Image.network(_imageUrlController.text),
                                  ),
                          ),
                          Expanded(
                            child: TextFormField(
                              focusNode: _imageFocusNode,
                              //initialValue: _initValues['imageUrl'],
                              decoration: const InputDecoration(
                                  labelText: 'Please, Enter image URL'),
                              textInputAction: TextInputAction.done,

                              keyboardType: TextInputType.url,
                              controller: _imageUrlController,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please, Enter an image URL';
                                }
                                if (!value.startsWith('http') &&
                                    !value.startsWith('.png')) {
                                  return 'Please, Enter a valid URL';
                                }
                                if (!value.endsWith('.png') &&
                                    !value.endsWith('.jpg') &&
                                    !value.endsWith('.jpeg')) {
                                  return 'Please, Enter a valid image URL';
                                }
                                return null;
                              },
                              onSaved: (newValue) {
                                _editedProduct = Product(
                                  id: _editedProduct.id,
                                  title: _editedProduct.title,
                                  description: _editedProduct.description,
                                  price: _editedProduct.price,
                                  imageUrl: newValue!,
                                );
                              },
                              onFieldSubmitted: (value) {
                                _saveForm();
                              },
                              // focusNode: _priceFocusNode,
                            ),
                          ),
                        ],
                      ),
                    ],
                  )),
            ),
    );
  }
}
