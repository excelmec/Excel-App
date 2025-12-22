import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'detail_popup.dart';

class EventDetailCard extends StatelessWidget {
  final String iconPath;
  final String label;
  final String value;

  const EventDetailCard({
    super.key,
    required this.iconPath,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => DetailPopup.show(context, iconPath, label, value),
      child: Container(
        height: MediaQuery.of(context).size.width > 600 ? 80 : 60,
        decoration: BoxDecoration(
          color: const Color(0xFF691701),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.white, width: 1),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          children: [
            _buildIcon(iconPath),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    label,
                    style: GoogleFonts.mulish(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Expanded(
                    child: Text(
                      value,
                      style: GoogleFonts.mulish(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIcon(String iconPath) {
    final colorFilter = const ColorFilter.mode(Colors.white, BlendMode.srcIn);
    return iconPath.endsWith('.png')
        ? ColorFiltered(
            colorFilter: colorFilter,
            child: Image.asset(iconPath, width: 24, height: 24, fit: BoxFit.contain),
          )
        : SvgPicture.asset(iconPath, width: 24, height: 24, colorFilter: colorFilter);
  }
}

