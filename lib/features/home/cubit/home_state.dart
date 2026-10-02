abstract class HomeState {}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeSuccess extends HomeState {}

class HomeError extends HomeState {
  final String message;
  HomeError(this.message);
}

//Add To Cart State
class AddToCartLoading extends HomeState {}

class AddToCartSuccess extends HomeState {}

class AddToCartError extends HomeState {
  final String message;
  AddToCartError(this.message);
}
