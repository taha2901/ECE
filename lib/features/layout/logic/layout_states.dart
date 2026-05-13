import 'package:equatable/equatable.dart';

abstract class LayoutState extends Equatable {
  final int currentIndex;
  const LayoutState({this.currentIndex = 0});

  @override
  List<Object?> get props => [currentIndex];
}

class LayoutInitial extends LayoutState {
  const LayoutInitial() : super(currentIndex: 0);
}

class LayoutChangeIndexState extends LayoutState {
  const LayoutChangeIndexState({required super.currentIndex});
}