import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_flow/services/sqlite_instance.dart';

class CheckboxCubit extends Cubit<bool> {
  CheckboxCubit() : super(false);
  final _sqliteInstance = SqliteInstance();
  bool isInitialized = false;

  void initValue(bool initStatus) {
    isInitialized = true;
    emit(initStatus);
  }

  void changeCheckboxValue(int id, bool value) async {
    await _sqliteInstance.connection();
    final changeResult = await _sqliteInstance.updateStatusComplete(id, value);
    if (changeResult != 0) {
      isInitialized = false;
      emit(value);
    }
  }
}
