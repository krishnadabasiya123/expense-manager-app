import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

@immutable
sealed class GetImagesState {}

final class GetImagesInitial extends GetImagesState {}

class GetImagesCubit extends Cubit<GetImagesState> {
  GetImagesCubit() : super(GetImagesInitial());
}
