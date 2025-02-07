import 'package:flutter/material.dart';
import 'package:masterstudy_app/theme/app_color.dart';
import 'package:masterstudy_app/theme/const_dimensions.dart';

class AppElevatedButton extends StatelessWidget {
  const AppElevatedButton._({
    required this.onPressed,
    required this.child,
    required this.sizeConfig,
    required this.titleStyle,
    required this.disabledState,
    required this.enabledState,
  });

  factory AppElevatedButton.secondary({
    required VoidCallback? onPressed,
    required Widget child,
    AppButtonSizeConfig sizeConfig = AppButtonSizeConfig.regular,
  }) {
    return AppElevatedButton._(
      onPressed: onPressed,
      sizeConfig: sizeConfig,
      titleStyle: const TextStyle(
        fontSize: 13.0,
        fontWeight: FontWeight.w700,
      ),
      enabledState: _AppButtonState(
        titleColor: ColorApp.white,
        backgroundColor: ColorApp.secondaryColor,
      ),
      disabledState: const _AppButtonState(
        titleColor: ColorApp.white,
        backgroundColor: Color(0xFFDDE1E3),
      ),
      child: child,
    );
  }

  factory AppElevatedButton.error({
    required VoidCallback? onPressed,
    required Widget child,
    AppButtonSizeConfig sizeConfig = AppButtonSizeConfig.regular,
  }) {
    return AppElevatedButton._(
      onPressed: onPressed,
      sizeConfig: sizeConfig,
      titleStyle: const TextStyle(
        fontSize: 13.0,
        fontWeight: FontWeight.w700,
      ),
      enabledState: _AppButtonState(
        titleColor: ColorApp.white,
        backgroundColor: Colors.red,
      ),
      disabledState: const _AppButtonState(
        titleColor: ColorApp.white,
        backgroundColor: Color(0xFFDDE1E3),
      ),
      child: child,
    );
  }

  factory AppElevatedButton.primary({
    required VoidCallback? onPressed,
    required Widget child,
    AppButtonSizeConfig sizeConfig = AppButtonSizeConfig.regular,
  }) {
    return AppElevatedButton._(
      onPressed: onPressed,
      sizeConfig: sizeConfig,
      titleStyle: const TextStyle(
        fontSize: 13.0,
        fontWeight: FontWeight.w700,
      ),
      enabledState: _AppButtonState(
        titleColor: ColorApp.white,
        backgroundColor: ColorApp.mainColor,
      ),
      disabledState: const _AppButtonState(
        titleColor: ColorApp.white,
        backgroundColor: Color(0xFFDDE1E3),
      ),
      child: child,
    );
  }

  factory AppElevatedButton.white({
    required VoidCallback? onPressed,
    required Widget child,
    AppButtonSizeConfig sizeConfig = AppButtonSizeConfig.regular,
  }) {
    return AppElevatedButton._(
      onPressed: onPressed,
      sizeConfig: sizeConfig,
      titleStyle: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w700,
      ),
      enabledState: const _AppButtonState(
        elevation: 3,
        titleColor: Colors.black,
        backgroundColor: Colors.white,
        foregroundColor: Color(0xff5A5B60),
      ),
      disabledState: const _AppButtonState(
        elevation: 3,
        titleColor: Colors.black,
        backgroundColor: Color(0xFFEEEEEE),
      ),
      child: child,
    );
  }

  factory AppElevatedButton.neutral({
    required VoidCallback? onPressed,
    required Widget child,
    AppButtonSizeConfig sizeConfig = AppButtonSizeConfig.regular,
  }) {
    return AppElevatedButton._(
      onPressed: onPressed,
      sizeConfig: sizeConfig,
      titleStyle: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w700,
      ),
      enabledState: const _AppButtonState(
        titleColor: Colors.white,
        backgroundColor: Colors.transparent,
        foregroundColor: Color(0xff5A5B60),
        borderColor: Colors.white,
      ),
      disabledState: const _AppButtonState(
        titleColor: Colors.black,
        backgroundColor: Colors.transparent,
      ),
      child: child,
    );
  }

  bool get disabled => onPressed == null;

  _AppButtonState get _currentState => disabled ? disabledState : enabledState;

  final VoidCallback? onPressed;
  final Widget child;
  final AppButtonSizeConfig sizeConfig;
  final TextStyle titleStyle;

  // ignore: library_private_types_in_public_api
  final _AppButtonState enabledState;

  // ignore: library_private_types_in_public_api
  final _AppButtonState disabledState;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: kButtonHeight,
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: enabledState.backgroundColor,
          foregroundColor: enabledState.foregroundColor,
          disabledBackgroundColor: disabledState.backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(sizeConfig.radius),
            side: _currentState.borderColor != null
                ? BorderSide(
                    color: _currentState.borderColor!,
                    width: 2,
                  )
                : BorderSide.none,
          ),
        ).copyWith(
          elevation: MaterialStateProperty.resolveWith<double>((_) => _currentState.elevation ?? 0),
        ),
        child: DefaultTextStyle(
          style: titleStyle.copyWith(
            color: _currentState.titleColor,
            fontWeight: FontWeight.w500,
          ),
          child: child,
        ),
      ),
    );
  }
}

class AppButtonSizeConfig {
  const AppButtonSizeConfig({
    required this.height,
    required this.radius,
  });

  final double height;
  final double radius;

  static const regular = AppButtonSizeConfig(height: 49, radius: 7.0);
  static const small = AppButtonSizeConfig(height: 45, radius: 7.0);
}

class _AppButtonState {
  const _AppButtonState({
    required this.titleColor,
    required this.backgroundColor,
    this.borderColor,
    this.foregroundColor,
    this.elevation,
  });

  final Color titleColor;
  final Color backgroundColor;
  final Color? borderColor;
  final Color? foregroundColor;
  final double? elevation;
}
