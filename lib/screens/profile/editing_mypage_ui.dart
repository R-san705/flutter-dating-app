import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import "package:intl/intl.dart";
import 'package:newtype_chatapp/models/profile_model.dart';
import 'package:newtype_chatapp/providers/edit_user_profile.dart';
import 'package:provider/provider.dart';

class EditingMyPage extends StatelessWidget {
  final ProfileModel myUser;
  const EditingMyPage(this.myUser, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final DateFormat _format = DateFormat('yyyy年MM月dd日');
    return ChangeNotifierProvider(
      create: (_) => EditUserProfile(myUser),
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: const Icon(
              Icons.chevron_left,
              size: 40,
              color: Colors.green,
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: Consumer<EditUserProfile>(
          builder: (context, model, child) {
            Widget showImage1() {
              if (model.imageFile1 != null) {
                return Image.file(model.imageFile1!);
              } else if (myUser.imageURL1 != null) {
                return Image.network(myUser.imageURL1!);
              } else {
                return Container(
                  color: Colors.grey,
                );
              }
            }

            Widget showImage2() {
              if (model.imageFile2 != null) {
                return Image.file(model.imageFile2!);
              } else if (myUser.imageURL2 != null) {
                return Image.network(myUser.imageURL2!);
              } else {
                return Container(
                  color: Colors.grey,
                );
              }
            }

            Widget showImage3() {
              if (model.imageFile3 != null) {
                return Image.file(model.imageFile3!);
              } else if (myUser.imageURL3 != null) {
                return Image.network(myUser.imageURL3!);
              } else {
                return Container(
                  color: Colors.grey,
                );
              }
            }

            return Stack(
              children: [
                SingleChildScrollView(
                  child: Center(
                    child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text('写真を追加'),
                            const SizedBox(
                              height: 18,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                GestureDetector(
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      const Icon(
                                        Icons.add_circle_outlined,
                                        color: Colors.grey,
                                        size: 40,
                                      ),
                                      Container(
                                        child: showImage1(),
                                        decoration: BoxDecoration(
                                          border:
                                              Border.all(color: Colors.grey),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: Colors.white10,
                                        ),
                                        height: 150,
                                        width: 100,
                                      ),
                                    ],
                                  ),
                                  onTap: () async {
                                    await model.pickImage1();
                                  },
                                ),
                                const SizedBox(
                                  width: 18,
                                ),
                                GestureDetector(
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      const Icon(
                                        Icons.add_circle_outlined,
                                        color: Colors.grey,
                                        size: 40,
                                      ),
                                      Container(
                                        child: showImage2(),
                                        decoration: BoxDecoration(
                                            border:
                                                Border.all(color: Colors.grey),
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            color: Colors.white10),
                                        height: 150,
                                        width: 100,
                                      ),
                                    ],
                                  ),
                                  onTap: () async {
                                    await model.pickImage2();
                                  },
                                ),
                                const SizedBox(
                                  width: 18,
                                ),
                                GestureDetector(
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      const Icon(
                                        Icons.add_circle_outlined,
                                        color: Colors.grey,
                                        size: 40,
                                      ),
                                      Container(
                                        child: showImage3(),
                                        decoration: BoxDecoration(
                                            border:
                                                Border.all(color: Colors.grey),
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            color: Colors.white10),
                                        height: 150,
                                        width: 100,
                                      ),
                                    ],
                                  ),
                                  onTap: () async {
                                    await model.pickImage3();
                                  },
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            const Text('お名前'),
                            TextFormField(
                              controller: model.nameController,
                              cursorColor: Colors.green,
                              onChanged: (text) {
                                model.setName(text);
                              },
                              decoration: const InputDecoration(
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.green,
                                      width: 2,
                                    ),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(15)),
                                  ),
                                  labelText: "お名前",
                                  labelStyle: TextStyle(color: Colors.green)),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            const Text('誕生日'),
                            DateTimeField(
                              controller: model.birthController,
                              onChanged: (DateTime? value) {
                                model.setBirth(_format.format(value!));
                              },
                              decoration: const InputDecoration(
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.green,
                                      width: 2,
                                    ),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(15)),
                                  ),
                                  labelText: "誕生日",
                                  labelStyle: TextStyle(color: Colors.green)),
                              format: _format,
                              onShowPicker: (context, currentValue) {
                                return showDatePicker(
                                    context: context,
                                    firstDate: DateTime(1900),
                                    initialDate: currentValue ?? DateTime.now(),
                                    lastDate: DateTime(2100));
                              },
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            const Text('性別'),
                            DecoratedBox(
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Colors
                                          .green), //border of dropdown button
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(15))),
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 30, right: 30, top: 5, bottom: 5),
                                child: DropdownButton<String>(
                                    underline: Container(),
                                    isExpanded: true,
                                    value: model.chosenValue,
                                    elevation: 16,
                                    items: <String>[
                                      '男性',
                                      '女性',
                                      'その他',
                                      '選んでください'
                                    ].map<DropdownMenuItem<String>>(
                                        (String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      );
                                    }).toList(),
                                    onChanged: (String? value) {
                                      model.setChosenValue(value!);
                                      model.setSex(value);
                                    }),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            const Text('自己紹介'),
                            TextFormField(
                              controller: model.profileController,
                              cursorColor: Colors.green,
                              onChanged: (text) {
                                model.setProfile(text);
                              },
                              decoration: const InputDecoration(
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.green,
                                      width: 2,
                                    ),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(15)),
                                  ),
                                  labelText: "自己紹介",
                                  labelStyle: TextStyle(color: Colors.green)),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            SizedBox(
                                height: 40,
                                child: ElevatedButton(
                                  child: const Text('保存する'),
                                  style: ElevatedButton.styleFrom(
                                    primary: Colors.green,
                                  ),
                                  onPressed: model.isUpdated()
                                      ? () async {
                                          try {
                                            model.startLoading();
                                            model.updateUserInfo();
                                          } catch (e) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                content: Text(e.toString()),
                                              ),
                                            );
                                          } finally {
                                            model.endLoading();
                                          }
                                        }
                                      : null,
                                )),
                          ],
                        )),
                  ),
                ),
                if (model.isLoading)
                  Container(
                    height: 500,
                    color: Colors.black54,
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}
