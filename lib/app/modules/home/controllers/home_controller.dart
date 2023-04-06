import 'package:get/get.dart';
import 'package:flutter/material.dart';

import '../db/db_provider.dart';
import '../model/task_model.dart';

class HomeController extends GetxController {
  //TODO: Implement HomeController
  var title = TextEditingController().obs;
  var description = TextEditingController().obs;
  RxInt id =0.obs;
  final count = 0.obs;
  RxList<todoModel> todoList =<todoModel>[].obs;

  Future<List<todoModel>> check()async{
    todoList.value=await DataBaseHelper.dbInstance.getTodos() ;
    return todoList.value;
    update();
  }


  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void increment() => count.value++;
}
