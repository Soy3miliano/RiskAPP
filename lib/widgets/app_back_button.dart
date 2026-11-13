import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riskapp/utils/constans/app_colors.dart';

/// Square outlined back button used in the screen headers.
class AppBackButton extends StatelessWidget {
  const AppBackButton({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.canPop() ? context.pop() : context.go('/'),
      borderRadius: BorderRadius.circular(10),
      child: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.borderColor),
        ),
        child: const Icon(
          CupertinoIcons.chevron_back,
          color: Colors.white,
          size: 28,
          semanticLabel: 'Back',
        ),
      ),
    );
  }
}
