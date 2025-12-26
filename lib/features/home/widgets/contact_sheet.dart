import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

Widget contactUsModal(context) {
  return Container(
    decoration: BoxDecoration(
      image: DecorationImage(
        image: AssetImage('assets/images/contact_card_bg.png'),
        fit: BoxFit.cover,
      ),
    ),
    child: Column(
      children: [
        SizedBox(height: 8),
        Image.asset('assets/icons/divider.png', width: 340),
        SizedBox(height: 20),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
              child: Text(
                "Stay In Touch",
                style: GoogleFonts.mulish(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () {
                      launchUrl(Uri.parse('tel:+919961343102'));
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: Colors.black,
                      ),
                      width: MediaQuery.of(context).size.width * 0.4,
                      height: 60,
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(20, 0, 10, 0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Image.asset(
                              "assets/icons/phone.png",
                              width: 20,
                              height: 20,
                            ),
                            SizedBox(width: 9),
                            Text(
                              "Call Us",
                              style: GoogleFonts.mulish(
                                fontSize: 14,
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      launchUrl(Uri.parse("https://excelmec.org"));
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: Colors.black,
                      ),
                      width: MediaQuery.of(context).size.width * 0.4,
                      height: 60,
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(15, 0, 10, 0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Image.asset(
                              "assets/icons/website.png",
                              width: 20,
                              height: 20,
                            ),
                            SizedBox(width: 9),
                            Text(
                              "Visit Website",
                              style: GoogleFonts.mulish(
                                fontSize: 14,
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(20, 20, 0, 0),
              child: Text(
                "Our Socials",
                style: GoogleFonts.mulish(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () {
                      launchUrl(
                        Uri.parse('https://www.instagram.com/excelmec/'),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: Colors.black,
                      ),
                      width: MediaQuery.of(context).size.width * 0.4,
                      height: 60,
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(18, 0, 10, 0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Image.asset(
                              "assets/icons/insta.png",
                              width: 30,
                              height: 30,
                            ),
                            SizedBox(width: 5),
                            Text(
                              "Instagram",
                              style: GoogleFonts.mulish(
                                fontSize: 14,
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      launchUrl(
                        Uri.parse('https://www.facebook.com/excelmec/'),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: Colors.black,
                      ),
                      width: MediaQuery.of(context).size.width * 0.4,
                      height: 60,
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(18, 0, 10, 0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Image.asset(
                              "assets/icons/facebook.png",
                              width: 30,
                              height: 30,
                            ),
                            SizedBox(width: 5),
                            Text(
                              "Facebook",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () {
                      launchUrl(
                        Uri.parse('https://www.linkedin.com/company/excelmec/'),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: Colors.black,
                      ),
                      width: MediaQuery.of(context).size.width * 0.4,
                      height: 60,
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(18, 0, 10, 0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Image.asset(
                              "assets/icons/linkedin.png",
                              width: 30,
                              height: 30,
                            ),
                            SizedBox(width: 7),
                            Text(
                              "Linkedin",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      launchUrl(Uri.parse('https://twitter.com/excelmec/'));
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: Colors.black,
                      ),
                      width: MediaQuery.of(context).size.width * 0.4,
                      height: 60,
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(18, 0, 10, 0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Image.asset(
                              "assets/icons/x.png",
                              width: 30,
                              height: 30,
                            ),
                            SizedBox(width: 7),
                            Text(
                              "X",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 40),
          ],
        ),
      ],
    ),
  );
}
