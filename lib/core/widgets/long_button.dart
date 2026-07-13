import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ipsum_user/core/theme/app_colors.dart';

typedef AsyncCallback = Future<void> Function();

class LongButton extends StatelessWidget {
  const LongButton({
    super.key,
    required this.label,
    this.onTap,
    this.enabled = true,
    this.isLoading = false,
  });

  final String label;
  final AsyncCallback? onTap;
  final bool enabled;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () async {
                await onTap!();
              },
        child: Ink(
          width: double.infinity,
          height: 56,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: const Color(0xFFE6ECF0),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 10,
                offset: const Offset(0, 4),
              )
            ],
          ),
          child: Center(
            child: isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : Text(
                    label,
                    style: GoogleFonts.roboto(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}