import 'package:expenseapp/core/app/all_import_file.dart';
import 'package:expenseapp/features/Home/LocalStorage/home_local_storage.dart';
import 'package:expenseapp/features/Home/Model/HomeMenuItem.dart';
import 'package:expenseapp/features/Home/Model/enums/HomeMenuType.dart';

@immutable
sealed class EditHomeState {}

final class EditHomeInitial extends EditHomeState {}

final class EditHomeSuccess extends EditHomeState {
  EditHomeSuccess(this.menuItems);
  final List<HomeMenuItem> menuItems;
}

final class EditHomeFailure extends EditHomeState {
  EditHomeFailure(this.error);
  final String error;
}

final class EditHomeLoading extends EditHomeState {}

class EditHomeCubit extends Cubit<EditHomeState> {
  EditHomeCubit() : super(EditHomeInitial());

  final HomeLocalStorage homeLocalStorage = HomeLocalStorage();

  Future<void> loadMenu(List<HomeMenuItem> defaultList) async {
    emit(EditHomeLoading());
    try {
      final menu = await homeLocalStorage.loadHomeMenu(defaultList);
      emit(EditHomeSuccess(menu));
    } catch (e, st) {
      emit(EditHomeFailure(e.toString()));
    }
  }

  /// Save menu to SharedPreferences
  Future<void> saveMenu(List<HomeMenuItem> list) async {
    //emit(EditHomeLoading());
    try {
      await homeLocalStorage.saveHomeMenu(list);
      emit(EditHomeSuccess(list));
    } catch (e, st) {
      emit(EditHomeFailure(e.toString()));
    }
  }

  List<HomeMenuType> getMenuMapFromSaved(List<HomeMenuItem> defaultList) {
    if (state is EditHomeSuccess) {
      final menuList = (state as EditHomeSuccess).menuItems;

      return menuList.where((e) => e.isOn).map((e) => e.type).toList();
    }
    return [];
  }

  bool isHomeBannerEnabled() {
    if (state is EditHomeSuccess) {
      final menuList = (state as EditHomeSuccess).menuItems;

      return menuList.where((e) => e.isOn).map((e) => e.type).toList().contains(HomeMenuType.HOME_PAGE_BANNER);
    }
    return false;
  }
}
