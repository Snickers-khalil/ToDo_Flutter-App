import 'dart:math';

import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../routes/app_pages.dart';
import '../controllers/home_controller.dart';
import '../db/db_provider.dart';
import '../model/task_model.dart';

class HomeView extends GetView<HomeController> {
   HomeView({Key key}) : super(key: key);
   Random id = Random();
   void check()async{
     controller.todoList.value=await DataBaseHelper.dbInstance.getTodos();
   }
  @override
  Widget build(BuildContext context) {
    check();
    return Scaffold(
        appBar: AppBar(
          title: const Text('LocaldatabaseView'),
          centerTitle: true,
        ),
        body: Column(
          children: [
            const SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: TextFormField(
                controller: controller.title.value,
                decoration: const InputDecoration(
                    hintText: 'Title'
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: TextFormField(
                controller: controller.description.value,
                decoration: const InputDecoration(
                    hintText: 'Description'
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(onPressed: () async{
                  var todo = todoModel(
                    id: id.nextInt(100),title: controller.title.value.text,description: controller.description.value.text,
                  );

                  await DataBaseHelper.dbInstance.addTodos(todo);
                  controller.todoList.value=await DataBaseHelper.dbInstance.getTodos() ;

                  controller.title.value.clear();
                  controller.description.value.clear();

                }, child: Text('Add')),
                ElevatedButton(onPressed: () async{
                  var todo = todoModel(
                    id: controller.id.value,
                    title: controller.title.value.text,
                    description: controller.description.value.text,
                  );
                  await DataBaseHelper.dbInstance.updateTodo(todo);
                  controller.todoList.value=await DataBaseHelper.dbInstance.getTodos() ;

                  controller.title.value.clear();
                  controller.description.value.clear();
                }, child: Text("Update"))
              ],),

            // Obx(()=>controller.todoList.length!=null?Expanded(
            //   child: ListView.builder(
            //     itemCount: controller.todoList.length,
            //     itemBuilder: (BuildContext context,int index){
            //       return Card(
            //         child: ListTile(
            //           leading: Icon(Icons.person_pin,),
            //           title: Text('${controller.todoList[index].title}'),
            //           subtitle: Text('${controller.todoList[index].description}'),
            //           trailing: FittedBox(
            //             child: Row(
            //               children: [
            //                 IconButton(onPressed: (){}, icon: Icon(Icons.edit)),
            //                 IconButton(onPressed: (){}, icon: Icon(Icons.delete))
            //               ],
            //             ),
            //           ),
            //         ),
            //       );
            //     },),
            // ):Container(),)

            // Expanded(
            //   child: FutureBuilder(
            //     future:controller.check(),
            //     builder: (BuildContext context, AsyncSnapshot<List<todoModel>> snapshot){
            //       if(snapshot.hasError){
            //         return Text("Error");
            //       }
            //       return snapshot.data!.isEmpty?Text("no data found"):ListView(
            //         children: snapshot.data!.map((todoModel model){
            //           return ListTile(
            //             title: Text(model.id.toString()),subtitle: Text(model.title.toString()),
            //           );
            //         }).toList()
            //       );
            //     },
            //   ),
            // )

            Expanded(child:
            Obx(()=> ListView.builder(
                itemCount: controller.todoList.value.length,
                itemBuilder: (BuildContext context ,int index){
                  return Obx(()=> ListTile(
                    leading: IconButton(icon: Icon(Icons.edit),onPressed: (){
                      controller.title.value.text=controller.todoList[index].title.toString();
                      controller.description.value.text=controller.todoList[index].description.toString();
                      controller.id.value=(controller.todoList[index].id?.toInt());
                    }),
                    title: Text(controller.todoList[index].title.toString()),
                    subtitle: Text(controller.todoList[index].description.toString()),
                    trailing: IconButton(onPressed: () async{
                      await DataBaseHelper.dbInstance.deleteTodo(controller.todoList[index].id);
                      controller.todoList.removeAt(index);
                    },icon: const Icon(Icons.delete),),
                  ));

                }),)
            ),

            ElevatedButton(onPressed: (){

            }, child: Text("Next"))

          ],
        )
    );
  }
}
