import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stock_manager_app/models/product.dart';

//Events
abstract class ProductActionEvent {}

class ProductActionUpdateEvent extends ProductActionEvent {
Product updatedProduct;
ProductActionUpdateEvent({required this.updatedProduct});
}

class ProductActionAddEvent extends ProductActionEvent {
Product addedProduct;
ProductActionAddEvent({required this.addedProduct});
}

class ProductActionDeleteEvent extends ProductActionEvent {
Product deletedProduct;
ProductActionDeleteEvent({required this.deletedProduct});
}

//States
abstract class ProductActionState {}
//initial State
class ProductActionDefaultState extends ProductActionState {
  Product? initialProduct;
  ProductActionDefaultState({required this.initialProduct});
}

class ProductActionUpdateState extends ProductActionState {
  Product updatedProduct;
  ProductActionUpdateState({required this.updatedProduct});
}

class ProductActionAddState extends ProductActionState {
  Product addedProduct;
  ProductActionAddState({required this.addedProduct});
}


class ProductActionDeleteState extends ProductActionState {
  Product deleteProduct;
  ProductActionDeleteState({required this.deleteProduct});
}


//Management
class ProductActionBloc extends Bloc<ProductActionEvent,ProductActionState>{
  Product? initialProduct;
  ProductActionBloc({ this.initialProduct}) : super(ProductActionDefaultState(initialProduct: initialProduct)){
    on<ProductActionUpdateEvent>((event, emit){
        Product updatedProduct = event.updatedProduct;
        emit(ProductActionUpdateState(updatedProduct: updatedProduct));
    });
  }
    void dispose(){
      //...
      super.close();
      //...
  }
}

