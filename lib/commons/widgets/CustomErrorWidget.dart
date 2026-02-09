import 'package:expenseapp/core/app/all_import_file.dart';
import 'package:flutter/material.dart';

enum CustomErrorType {
  //noInternet(AppImages.noInternet),
  noDataFound(AppImages.noDataFound),
  generalError(AppImages.generalError),
  noImageError(null)
  ;

  final String? imagePath;

  const CustomErrorType(this.imagePath);
}

class CustomErrorWidget extends StatelessWidget {
  const CustomErrorWidget({
    required this.errorMessage,
    super.key,
    this.onRetry,
    this.retryButtonText,
    this.errorType = CustomErrorType.generalError,
    this.errorTitle,
    this.errorMessageColor,
    this.errorMessageFontSize,
    this.retryButtonBackgroundColor,
    this.retryButtonTextColor,
    this.showRetryButton = true,
    this.retryButtonWidth,
  });

  /// Core fields
  final String errorMessage;
  final String? errorTitle;
  final VoidCallback? onRetry;
  final String? retryButtonText;
  final CustomErrorType errorType;

  /// Styling
  final Color? errorMessageColor;
  final double? errorMessageFontSize;
  final Color? retryButtonBackgroundColor;
  final Color? retryButtonTextColor;
  final bool showRetryButton;
  final double? retryButtonWidth;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsetsDirectional.symmetric(vertical: 5),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: 16,
          children: [
            if (errorType.imagePath != null)
              QImage(
                imageUrl: errorType.imagePath!,
                width: MediaQuery.of(context).size.width * 0.9,
                height: MediaQuery.of(context).size.width * 0.5,
                fit: BoxFit.contain,
              ),

            Text(
              context.tr(errorMessage),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: errorMessageFontSize ?? 20.sp(context),
                fontWeight: FontWeight.w400,
                color: errorMessageColor ?? context.colorScheme.onSurface,
              ),
              // TextStyle(
              //   fontSize: errorMessageFontSize ?? 14,
              //   color: errorMessageColor ?? context.colorScheme.onSurface,
              // ),
            ),
            if (showRetryButton && onRetry != null)
              CustomRoundedButton(
                height: 35,
                width: MediaQuery.of(context).size.width * 0.8,
                backgroundColor: colorScheme.primary,
                onPressed: onRetry,

                text: retryButtonText ?? 'Retry',
                borderRadius: BorderRadius.circular(10),

                child: Text(
                  retryButtonText ?? 'Retry',
                  style: TextStyle(color: Colors.white, fontSize: 15.sp(context)),
                ),
              ),
          ],
        ),
      ),
    );
  }

  String _getDefaultTitle(CustomErrorType type) {
    switch (type) {
      case CustomErrorType.noDataFound:
        return 'noDataFoundTitle';
      case CustomErrorType.generalError:
        return 'somethingWentWrongTitle';
      case CustomErrorType.noImageError:
        return 'errorTitle';
    }
  }
}
