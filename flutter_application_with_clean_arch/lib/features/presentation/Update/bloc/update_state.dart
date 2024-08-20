

import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import '../../formz/formz_validations.dart';

enum UpdateStateeEnum { initial, loading, loaded, error , updated}

class UpdateState extends Equatable {
  final ProductName name;
  final ProductPrice price;
  final ProductDescription description;
  final String imagePath;
  final FormzSubmissionStatus status;
  final UpdateStateeEnum pageStatus;
  const UpdateState({
    this.name = const ProductName.pure(),
    this.price = const ProductPrice.pure(),
    this.description = const ProductDescription.pure(),
    this.imagePath = '',
    this.status = FormzSubmissionStatus.initial,
    this.pageStatus = UpdateStateeEnum.initial,

  });

  UpdateState copyWith ({
    ProductName? name,
    ProductPrice? price,
    ProductDescription? description,
    String? imagePath,
    FormzSubmissionStatus? status,
    UpdateStateeEnum? pageStatus,
  }) {
    return UpdateState(
      name: name ?? this.name,
      price: price ?? this.price,
      description: description ?? this.description,
      imagePath: imagePath ?? this.imagePath,
      status: status ?? this.status,
      pageStatus: pageStatus ?? this.pageStatus,
    );
  }
 
  @override
  List<Object?> get props => [name, price, description, imagePath, status, pageStatus];

  
}