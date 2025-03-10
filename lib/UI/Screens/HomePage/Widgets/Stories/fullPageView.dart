import 'package:cached_network_image/cached_network_image.dart';
import 'package:excelapp/Models/highlights_model.dart';
import 'package:excelapp/UI/Components/LoadingUI/loadingAnimation.dart';
import 'package:excelapp/UI/Themes/colors.dart';
import 'package:excelapp/UI/constants.dart';
import 'package:flutter/material.dart';

class FullPageView extends StatefulWidget {
  final List<Map<String, dynamic>> storiesMapList;
  final int storyNumber;
  final List<Highlights> highLightsMap;

  FullPageView(
      {Key? key, required this.storiesMapList, required this.storyNumber, required this.highLightsMap})
      : super(key: key);
  @override
  FullPageViewState createState() =>
      FullPageViewState(highLightsMap, storyNumber);
}
/*
class FullPageViewState extends State<FullPageView> {
  final List<Map<String, dynamic>> storiesMapList;
  late int storyNumber;

  FullPageViewState(
     this.storiesMapList, this.storyNumber);

 late List combinedList;
 late List listLengths;
 late int selectedIndex;
 late List<Map<String, dynamic>> newList;
 late PageController _pageController;

  nextPage(index) {
    if (index == combinedList.length - 1) {
      Navigator.pop(context);
      return;
    }
    setState(() {
      selectedIndex = index + 1;
    });

    _pageController.animateToPage(selectedIndex,
        duration: Duration(milliseconds: 100), curve: Curves.easeIn);
  }

  prevPage(index) {
    if (index == 0) return;
    setState(() {
      selectedIndex = index - 1;
    });
    _pageController.animateToPage(selectedIndex,
        duration: Duration(milliseconds: 100), curve: Curves.easeIn);
  }

  @override
  void initState() {
    newList = [];
    newList.add(storiesMapList[storyNumber]);
    combinedList = getStoryList(newList);
    listLengths = getStoryLengths(newList);
    selectedIndex = getInitialIndex(storyNumber, storiesMapList);
    selectedIndex = 0;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _pageController = PageController(initialPage: selectedIndex);
    return Scaffold(
      body: Stack(
        children: <Widget>[
          PageView(
            onPageChanged: (page) {
              setState(() {
                selectedIndex = page;
              });
            },
            controller: _pageController,
            scrollDirection: Axis.horizontal,
            children: List.generate(
              combinedList.length,
              (index) => Stack(
                children: <Widget>[
                  CachedNetworkImage(
                    imageUrl: combinedList[index],
                    fit: BoxFit.cover,
                    height: double.infinity,
                    width: double.infinity,
                    // Placeholder when it doesnt Load
                    placeholder: (context, url) => Container(
                      color: backgroundBlue,
                      height: double.infinity,
                      width: double.infinity,
                      child: Center(
                        child: LoadingAnimation(color: primaryPink),
                      ),
                    ),
                  ),

                  // Overlay to detect taps for next page & previous page
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            prevPage(index);
                          },
                          child: Center(),
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 3,
                      ),
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            nextPage(index);
                          },
                          child: Center(),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          // The progress of story indicator - Now deprecated since API gives only one img/highlight
          Column(
            children: <Widget>[
              Container(
                color: Colors.black,
                child: SafeArea(
                  child: Center(),
                ),
              ),
              // Row(
              //   children: List.generate(
              //         numOfCompleted(listLengths, selectedIndex),
              //         (index) => Expanded(
              //           child: Container(
              //             margin: EdgeInsets.all(2),
              //             height: 2.5,
              //             decoration: BoxDecoration(
              //                 color: Colors.white,
              //                 borderRadius: BorderRadius.circular(20),
              //                 boxShadow: [
              //                   BoxShadow(blurRadius: 2, color: primaryColor)
              //                 ]),
              //           ),
              //         ),
              //       ) +
              //       List.generate(
              //         (10),
              //         (index) => Expanded(
              //           child: Container(
              //             margin: EdgeInsets.all(2),
              //             height: 2.5,
              //             decoration: BoxDecoration(
              //               color: Color(0xff444444),
              //               borderRadius: BorderRadius.circular(20),
              //               boxShadow: [
              //                 BoxShadow(blurRadius: 2, color: primaryColor)
              //               ],
              //             ),
              //           ),
              //         ),
              //       ),
              // ),
              SizedBox(height: 15),
              // Story name
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  ' ' * 5 +
                      newList[0]['name'],
                  style: TextStyle(
                      color: Colors.white,
                      shadows: [Shadow(blurRadius: 10, color: Colors.black)],
                      fontFamily: pfontFamily,
                      fontSize: 16),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

List<String> getStoryList(List<Map<String, dynamic>> storiesMapList) {
  List<String> imagesList = [];
  for (int i = 0; i < storiesMapList.length; i++)
    for (int j = 0; j < storiesMapList[i]['images'].length; j++)
      imagesList.add(storiesMapList[i]['images'][j]);
  return imagesList;
}

List<int> getStoryLengths(List<Map<String, dynamic>> storiesMapList) {
  List<int> intList = [];
  int? count = 0;
  for (int i = 0; i < storiesMapList.length; i++) {
    count = (count! + i);
    intList.add(count);
  }
  return intList;
}

int getCurrentLength(listLengths, index) {
  index = index + 1;
  int val = listLengths[0];
  for (int i = 0; i < listLengths.length; i++) {
    val = i == 0 ? listLengths[0] : listLengths[i] - listLengths[i - 1];
    if (listLengths[i] >= index) break;
  }
  return val;
}

numOfCompleted(listLengths, index) {
  index = index + 1;
  int val = 0;
  for (int i = 0; i < listLengths.length; i++) {
    if (listLengths[i] >= index) break;
    val = listLengths[i];
  }
  return (index - val);
}

getInitialIndex(storyNumber, storiesMapList) {
  int total = 0;
  for (int i = 0; i < storyNumber; i++) {
    total += 1;
  }
  return total;
}

int getStoryIndex(listLengths, index, storiesMapList) {
  index = index + 1;
  int temp = 0;
  int val = 0;
  for (int i = 0; i < listLengths.length; i++) {
    if (listLengths[i] >= index) break;
    if (temp != listLengths[i]) val += 1;
    temp = listLengths[i];
  }
  return val;
}
*/

class FullPageViewState extends State<FullPageView> {
  final List<Highlights> highLightsMap; // List of all highlights (one per page)
  late int storyNumber; // The index of the currently selected highlight

  FullPageViewState(this.highLightsMap, this.storyNumber);

  late int selectedIndex;
  late PageController _pageController;

  nextPage(index) {
    if (index == highLightsMap.length - 1) {
      Navigator.pop(context);
      return;
    }
    setState(() {
      selectedIndex = index + 1;
    });
    _pageController.animateToPage(selectedIndex,
        duration: Duration(milliseconds: 300), curve: Curves.easeIn);
  }

  prevPage(index) {
    if (index == 0) return;
    setState(() {
      selectedIndex = index - 1;
    });
    _pageController.animateToPage(selectedIndex,
        duration: Duration(milliseconds: 300), curve: Curves.easeOut);
  }

  @override
  void initState() {
    super.initState();
    selectedIndex = storyNumber;
    _pageController = PageController(initialPage: selectedIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          PageView(
            onPageChanged: (page) {
              setState(() {
                selectedIndex = page;
              });
            },
            controller: _pageController,
            scrollDirection: Axis.horizontal,
            children: List.generate(
              highLightsMap.length, // Use the list of highlights directly
              (index) => GestureDetector(
                onTap: () {
                  if (index < highLightsMap.length - 1) {
                    nextPage(index);
                  } else {
                    Navigator.pop(context);
                  }
                },
                child: Stack(
                  children: <Widget>[
                    CachedNetworkImage(
                      imageUrl: highLightsMap[index].image,
                      fit: BoxFit.cover,
                      height: double.infinity,
                      width: double.infinity,
                      placeholder: (context, url) => Container(
                        color: backgroundBlue,
                        height: double.infinity,
                        width: double.infinity,
                        child: Center(
                          child: LoadingAnimation(color: primaryPink),
                        ),
                      ),
                    ),
                    // Tap area for next/previous page
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              prevPage(index);
                            },
                            child: Center(),
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 3,
                        ),
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              nextPage(index);
                            },
                            child: Center(),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          // The progress bar (now not required, as only one image per highlight)
          Column(
            children: [
              Container(
                color: Colors.black,
                child: SafeArea(
                  child: Center(),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  ' ' * 5 + highLightsMap[selectedIndex].name,
                  style: TextStyle(
                      color: Colors.white,
                      shadows: [Shadow(blurRadius: 10, color: Colors.black)],
                      fontFamily: pfontFamily,
                      fontWeight: FontWeight.bold,
                      fontSize: 16),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
