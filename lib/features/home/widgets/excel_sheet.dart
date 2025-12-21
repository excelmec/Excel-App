import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:excelapp2025/features/home/widgets/developer_credits_sheet.dart';

class AboutExcelPopUp extends StatelessWidget {
  const AboutExcelPopUp({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(32), topRight: Radius.circular(32)),
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 21, 21, 21),
              Color.fromARGB(255, 21, 21, 21),
            ]
          )
        ),
      child: Column(
        children: [
          SizedBox(height: 8),
          Image.asset(
            "assets/icons/divider.png",
            width: 340,
          ),
          Image.asset(
            "assets/icons/college.png",
            width: 340,
            height: 160,
          ),
          SizedBox(height: 10),
          Padding(
            padding: EdgeInsets.fromLTRB(32, 7, 32, 10),
            child: Center(
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  text: 'Inspire. Innovate. Engineer ',
                  style: GoogleFonts.mulish(
                    color: Color(0xFFD3E1E4),
                    fontWeight: FontWeight.w800,
                    fontSize: 16,
                  ),
                  children: <TextSpan>[
                    TextSpan(
                      text:
                          "\n\nExcel, the nation's second and South India's first ever techno-managerial fest of its kind was started in 2001 by the students of Govt. Model Engineering College, Kochi. Over the years, Excel has grown exponentially, consistently playing host to some of the most talented students, the most coveted guests and the most reputed companies.\nAs we gear up for our 26th edition, Excel continues to push boundaries. Join us this January and experience the magic of a legacy in the making.",
                      style: GoogleFonts.mulish(
                        color: Color(0xFFE4EDEF),
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: 20),
          Padding(
            padding: EdgeInsets.fromLTRB(32, 0, 32, 0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Center(
                  child: InkWell(
                    onTap: () {
                      launchUrl(Uri.parse('https://www.excelmec.org/'));
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(40),
                        color: Colors.black,
                      ),
                      height: 50,
                      alignment: Alignment.center,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'View Website',
                            style: GoogleFonts.mulish(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: 14),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Icon(Icons.arrow_forward,
                              size: 19, color: Colors.white)
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Center(
                  child: InkWell(
                    onTap: () {
                      Navigator.pop(context);
                      Future.delayed(const Duration(milliseconds: 100), () {
                        if (context.mounted) {
                          showModalBottomSheet<dynamic>(
                            isScrollControlled: true,
                            useRootNavigator: true,
                            backgroundColor: Colors.transparent,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(32),
                                topRight: Radius.circular(32),
                              ),
                            ),
                            constraints: BoxConstraints(
                              minWidth: MediaQuery.of(context).size.width,
                              maxHeight: MediaQuery.of(context).size.height * 0.9,
                            ),
                            context: context,
                            builder: (context) => const DeveloperCreditsSheet(),
                            isDismissible: true,
                          );
                        }
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(40),
                        color: Colors.white,
                      ),
                      height: 50,
                      alignment: Alignment.center,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Developer Credits',
                            style: GoogleFonts.mulish(
                                color: Colors.black,
                                fontWeight: FontWeight.w700,
                                fontSize: 14),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Icon(
                            Icons.arrow_forward,
                            size: 19,
                            color: Colors.black,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
              ],
            ),
          )
          /*Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Image.asset(
                      "assets/icons/meclogo.png",
                      height: 50,
                    ),
                    Image.asset(
                      "assets/icons/excel2020withtext.png",
                      height: 50,
                    ),
                  ],
                )*/
          ,
        ],
      ),
    );
  }
}