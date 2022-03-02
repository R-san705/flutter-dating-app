import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import "package:intl/intl.dart";
import 'package:newtype_chatapp/providers/add_user_profile.dart';
import 'package:newtype_chatapp/screens/home/home_ui.dart';
import 'package:provider/provider.dart';

class InputUserInfo extends StatelessWidget {
  final User user;
  const InputUserInfo({Key? key, required this.user}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final DateFormat _format = DateFormat('yyyy年MM月dd日');
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AddUserProfile>(
          create: (_) => AddUserProfile(),
        ),
      ],
      child: Scaffold(
        body: Consumer<AddUserProfile>(
          builder: (context, AddUserProfile model, child) {
            return SingleChildScrollView(
              child: Center(
                child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(
                          height: 18,
                        ),
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
                                    child: model.imageFile1 != null
                                        ? Image.file(model.imageFile1!)
                                        : Container(
                                            color: Colors.grey,
                                          ),
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.grey),
                                      borderRadius: BorderRadius.circular(10),
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
                                    child: model.imageFile2 != null
                                        ? Image.file(model.imageFile2!)
                                        : Container(
                                            color: Colors.grey,
                                          ),
                                    decoration: BoxDecoration(
                                        border: Border.all(color: Colors.grey),
                                        borderRadius: BorderRadius.circular(10),
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
                                    child: model.imageFile3 != null
                                        ? Image.file(model.imageFile3!)
                                        : Container(
                                            color: Colors.grey,
                                          ),
                                    decoration: BoxDecoration(
                                        border: Border.all(color: Colors.grey),
                                        borderRadius: BorderRadius.circular(10),
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
                          cursorColor: Colors.green,
                          onChanged: (String value) {
                            // ignore: prefer_is_empty
                            if (value.length >= 0) {
                              model.setName(value);
                              model.nameOk = true;
                            } else {
                              model.nameOk = false;
                            }
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
                                  color:
                                      Colors.green), //border of dropdown button
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(15))),
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
                                ].map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                                onChanged: (String? value) {
                                  if (value != '選んでください') {
                                    model.setChosenValue(value!);
                                    model.setSex(value);
                                    model.sexOk = true;
                                  } else {
                                    model.sexOk = false;
                                  }
                                }),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        const Text('自己紹介'),
                        TextFormField(
                          cursorColor: Colors.green,
                          onChanged: (String value) {
                            // ignore: prefer_is_empty
                            if (value.length >= 0) {
                              model.setProfile(value);
                              model.profileOk = true;
                            } else {
                              model.profileOk = false;
                            }
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
                        Container(
                          padding: const EdgeInsets.all(8),
                          // メッセージ表示
                          child: Text(model.infoText),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                              height: 40,
                              child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    primary: Colors.green, //ボタンの背景色
                                  ),
                                  onPressed: () async {
                                    if (model.nameOk &&
                                        model.sexOk &&
                                        model.profileOk) {
                                      try {
                                        model.startLoading();
                                        await model.addUserInfo();
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  const Home(),
                                            ));
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
                                    } else {
                                      model.setInfoText('入力不足があります。');
                                    }
                                  },
                                  child: const Text('保存する'))),
                        )
                      ],
                    )),
              ),
            );
          },
        ),
      ),
    );
  }
}
