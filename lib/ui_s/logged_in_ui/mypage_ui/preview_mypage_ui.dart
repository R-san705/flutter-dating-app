import 'package:flutter/material.dart';
import 'package:newtype_chatapp/model_s/tomato_structure/age_calc_model.dart';
import 'package:newtype_chatapp/model_s/tomato_structure/preview_page_model.dart';
import 'package:newtype_chatapp/models/profile_model.dart';
import 'package:newtype_chatapp/providers/profile_provider.dart';
import 'package:provider/provider.dart';

class PreviewMyPage extends StatelessWidget {
  final String uid;
  const PreviewMyPage({Key? key, required this.uid}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (_) => ProfileProvider(uid)..fetchMyUser()),
        ChangeNotifierProvider(create: (_) => PreviewPageModel()),
      ],
      child: Consumer<ProfileProvider>(
          builder: (context, ProfileProvider model, child) {
        return Scaffold(
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
          body: Consumer<ProfileProvider>(
            builder: (context, model, child) {
              final ProfileModel? myUser = model.myProfile;
              if (myUser == null) {
                return const Center(child: CircularProgressIndicator());
              }
              var _age = AgeCalcModel().ageCalc(myUser.birth);
              List<String> imgList = [
                myUser.imageURL1!,
                myUser.imageURL2!,
                myUser.imageURL3!
              ];
              return Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Container(
                    alignment: Alignment.topCenter,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white,
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.grey,
                          spreadRadius: 5,
                          blurRadius: 5,
                          offset: Offset(1, 1),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Stack(
                              children: [
                                SizedBox(
                                  height: 400,
                                  child: PageView.builder(
                                      itemCount: 3,
                                      itemBuilder: (context, pagePosition) {
                                        return Image.network(
                                            imgList[pagePosition],
                                            fit: BoxFit.fill);
                                      },
                                      pageSnapping: true,
                                      onPageChanged: (page) {
                                        context
                                            .read<PreviewPageModel>()
                                            .setActivePage(page);
                                      }),
                                ),
                                Positioned.fill(
                                  child: Align(
                                    alignment: Alignment.bottomCenter,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: context
                                              .watch<PreviewPageModel>()
                                              .indicators(
                                                  imgList.length,
                                                  context
                                                      .watch<PreviewPageModel>()
                                                      .activePage)),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              alignment: Alignment.topLeft,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(9),
                                child: Column(
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.baseline,
                                      textBaseline: TextBaseline.alphabetic,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            myUser.name,
                                            style: const TextStyle(
                                                fontWeight: FontWeight.w600,
                                                color: Colors.black,
                                                fontSize: 30),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          _age,
                                          style: const TextStyle(
                                              color: Colors.black45,
                                              fontSize: 20),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: const [
                                        Icon(
                                          Icons.favorite,
                                          color: Colors.black45,
                                          size: 20,
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text('238'),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Icon(
                                          Icons.contact_page,
                                          color: Colors.black45,
                                          size: 20,
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        Expanded(
                                          child: Text(
                                            myUser.profile,
                                            style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 15,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Icon(
                                          Icons.psychology,
                                          color: Colors.black45,
                                          size: 20,
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        Expanded(
                                          child: Text(
                                            myUser.profile,
                                            style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 15,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ));
            },
          ),
        );
      }),
    );
  }
}
