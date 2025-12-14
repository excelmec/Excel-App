import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// TODO : Actually liquid glass

class DialogueSheet extends StatelessWidget {
  DialogueSheet({
    super.key,
    required this.title,
    required this.description,
    required this.primaryActionText,
    required this.secondaryActionText,
    required this.onPrimaryAction,
    required this.onSecondaryAction,
  });

  final String title;
  final String description;
  final String primaryActionText;
  final String secondaryActionText;

  final VoidCallback onPrimaryAction;
  final VoidCallback onSecondaryAction;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
      padding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 20.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
        gradient: LinearGradient(
          // use 0x33 according to figma design
          colors: [Color(0xDD651F00), Color(0xDD000000)],
          begin: Alignment.bottomLeft,
          end: Alignment.topRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.min,
        spacing: 10.0,
        children: [
          Divider(
            color: Colors.white,
            thickness: 5.0,
            indent: MediaQuery.of(context).size.width * 0.3,
            endIndent: MediaQuery.of(context).size.width * 0.3,
            radius: BorderRadius.circular(2e5),
          ),
          Text(
            title,
            style: GoogleFonts.mulish(
              fontSize: 20.0,
              fontWeight: FontWeight.w700,
            ),
          ),
          Text(
            description,
            style: GoogleFonts.mulish(
              fontSize: 18.0,
              fontWeight: FontWeight.w500,
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: TextButton(
                  onPressed: onPrimaryAction,
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                    ),
                  ),
                  child: Text(
                    primaryActionText,
                    style: GoogleFonts.mulish(
                      fontSize: 20.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 20.0),
              Expanded(
                child: TextButton(
                  onPressed: onSecondaryAction,
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.black,
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                    ),
                  ),
                  child: Text(
                    secondaryActionText,
                    style: GoogleFonts.mulish(
                      fontSize: 20.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
