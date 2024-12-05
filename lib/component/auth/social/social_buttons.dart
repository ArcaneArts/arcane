import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

enum Buttons {
  email,
  google,
  facebook,
  gitHub,
  apple,
  linkedIn,
  pinterest,
  tumblr,
  twitter,
  reddit,
  quora,
  yahoo,
  hotmail,
  xbox,
  microsoft,
  anonymous,
}

@immutable
class SignInButtonBuilder extends StatelessWidget {
  /// This is a builder class for signin button
  ///
  /// Icon can be used to define the signin method
  /// User can use Flutter built-in Icons or font-awesome flutter's Icon
  final IconData? icon;

  /// Override the icon section with a image logo
  /// For example, Google requires a colorized logo,
  /// which FontAwesome cannot display. If both image
  /// and icon are provided, image will take precedence
  final Widget? image;

  /// `mini` tag is used to switch from a full-width signin button to
  final bool mini;

  /// the button's text
  final String text;

  /// Buttons's text style.
  ///
  /// This field is optional
  final TextStyle? textStyle;

  /// The size of the label font
  ///
  /// This field will be overridden if [textStyle] is not null.
  final double fontSize;

  /// backgroundColor is required but textColor is default to `Colors.white`
  /// splashColor is default to `Colors.white30`
  ///
  /// [textColor] field will be overridden if [textStyle] is not null.
  final Color textColor;
  final Color iconColor;
  final Color backgroundColor;
  final Color splashColor;
  final Color highlightColor;

  /// onPressed should be specified as a required field to indicate the callback.
  final Function onPressed;

  /// padding is default to `EdgeInsets.all(3.0)`
  final EdgeInsets? padding;
  final EdgeInsets? innerPadding;

  /// shape is to specify the custom shape of the widget.
  /// However the flutter widgets contains restriction or bug
  /// on material button, hence, comment out.
  final ShapeBorder? shape;

  /// elevation has default value of 2.0
  final double elevation;

  /// the height of the button
  final double? height;

  /// width is default to be 1/1.5 of the screen
  final double? width;

  /// {@macro flutter.material.Material.clipBehavior}
  ///
  /// Defaults to [Clip.none], and must not be null.
  final Clip clipBehavior;

  /// The constructor is self-explanatory.
  const SignInButtonBuilder({
    Key? key,
    required this.backgroundColor,
    required this.onPressed,
    required this.text,
    this.icon,
    this.image,
    this.fontSize = 14.0,
    this.textColor = Colors.white,
    this.iconColor = Colors.white,
    this.splashColor = Colors.white30,
    this.highlightColor = Colors.white30,
    this.padding,
    this.innerPadding,
    this.mini = false,
    this.elevation = 2.0,
    this.shape,
    this.height,
    this.width,
    this.clipBehavior = Clip.none,
    this.textStyle,
  }) : super(key: key);

  /// The build function will be help user to build the signin button widget.
  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      key: key,
      minWidth: mini ? width ?? 35.0 : null,
      height: height,
      elevation: elevation,
      padding: padding ?? EdgeInsets.zero,
      color: backgroundColor,
      onPressed: onPressed as void Function()?,
      splashColor: splashColor,
      highlightColor: highlightColor,
      shape: shape ?? ButtonTheme.of(context).shape,
      clipBehavior: clipBehavior,
      child: _getButtonChild(context),
    );
  }

  /// Get the inner content of a button
  Widget _getButtonChild(BuildContext context) {
    if (mini) {
      return SizedBox(
        width: height ?? 35.0,
        height: width ?? 35.0,
        child: _getIconOrImage(),
      );
    }

    final double buttonWidth = width ?? 220;

    return Container(
      constraints: BoxConstraints(maxWidth: buttonWidth),
      child: Center(
        child: Row(
          children: <Widget>[
            Padding(
              padding: innerPadding ??
                  const EdgeInsets.symmetric(
                    horizontal: 13,
                  ),
              child: _getIconOrImage(),
            ),
            Container(
              constraints: BoxConstraints(
                maxWidth: buttonWidth - 50,
              ),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  text,
                  style: textStyle ??
                      TextStyle(
                        color: textColor,
                        fontSize: fontSize,
                        backgroundColor: const Color.fromRGBO(0, 0, 0, 0),
                      ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Get the icon or image widget
  Widget _getIconOrImage() {
    if (image != null) {
      return image!;
    }
    return Icon(
      icon,
      size: 20,
      color: iconColor,
    );
  }
}

class SignInButton extends StatelessWidget {
  /// Here are the buttons builder which integrate with button builder
  /// and the buttons list.
  ///
  /// The `SignInButton` class already contains general used buttons.
  /// In case of other buttons, user can always use `SignInButtonBuilder`
  /// to build the sign in button.

  /// onPressed function should be passed in as a required field.
  final Function onPressed;

  /// button should be used from the enum class `Buttons`
  final Buttons button;

  /// mini is a boolean field which specify whether to use a square mini button.
  final bool mini;

  /// shape is to specify the custom shape of the widget.
  final ShapeBorder? shape;

  /// overrides the default button text
  final String? text;

  /// overrides the default button padding
  final EdgeInsets padding;

  // overrides the default button elevation
  final double elevation;

  /// buttons's text style.
  final TextStyle? textStyle;

  /// {@macro flutter.material.Material.clipBehavior}
  ///
  /// Defaults to [Clip.none], and must not be null.
  final Clip clipBehavior;

  /// The constructor is fairly self-explanatory.
  const SignInButton(
    this.button, {
    Key? key,
    required this.onPressed,
    this.mini = false,
    this.padding = EdgeInsets.zero,
    this.shape,
    this.text,
    this.elevation = 2.0,
    this.clipBehavior = Clip.none,
    this.textStyle,
  }) : super(key: key);

  /// The build function is used to build the widget which will switch to
  /// desired widget based on the enum class `Buttons`
  @override
  Widget build(BuildContext context) {
    switch (button) {
      case Buttons.google:
        return SignInButtonBuilder(
          elevation: elevation,
          key: const ValueKey('Google'),
          text: text ?? 'Sign in with Google',
          textStyle: textStyle,
          textColor: const Color(0xFF1F1F1F),
          icon: FontAwesomeIcons.google,
          backgroundColor: const Color(0xFFFFFFFF),
          onPressed: onPressed,
          padding: padding,
          innerPadding: EdgeInsets.zero,
          shape: shape,
          height: 36.0,
          clipBehavior: clipBehavior,
        );
      case Buttons.facebook:
        return SignInButtonBuilder(
          elevation: elevation,
          key: const ValueKey('Facebook'),
          mini: mini,
          text: text ?? 'Sign in with Facebook',
          textStyle: textStyle,
          icon: FontAwesomeIcons.facebookF,
          backgroundColor: const Color(0xFF1877f2),
          onPressed: onPressed,
          padding: padding,
          shape: shape,
          clipBehavior: clipBehavior,
        );
      case Buttons.gitHub:
        return SignInButtonBuilder(
          elevation: elevation,
          key: const ValueKey('GitHub'),
          mini: mini,
          text: text ?? 'Sign in with GitHub',
          textStyle: textStyle,
          icon: FontAwesomeIcons.github,
          backgroundColor: const Color(0xFF444444),
          onPressed: onPressed,
          padding: padding,
          shape: shape,
          clipBehavior: clipBehavior,
        );
      case Buttons.apple:
      case Buttons.appleDark:
        return SignInButtonBuilder(
          elevation: elevation,
          key: const ValueKey('Apple'),
          mini: mini,
          text: text ?? 'Sign in with Apple',
          textStyle: textStyle,
          textColor: button == Buttons.apple
              ? const Color.fromRGBO(0, 0, 0, 0.9)
              : Colors.white,
          icon: FontAwesomeIcons.apple,
          iconColor: button == Buttons.apple ? Colors.black : Colors.white,
          backgroundColor: button == Buttons.apple
              ? const Color(0xFFFFFFFF)
              : const Color(0xFF000000),
          onPressed: onPressed,
          padding: padding,
          shape: shape,
          clipBehavior: clipBehavior,
        );
      case Buttons.linkedIn:
        return SignInButtonBuilder(
          elevation: elevation,
          key: const ValueKey('LinkedIn'),
          mini: mini,
          text: text ?? 'Sign in with LinkedIn',
          textStyle: textStyle,
          icon: FontAwesomeIcons.linkedinIn,
          backgroundColor: const Color(0xFF007BB6),
          onPressed: onPressed,
          padding: padding,
          shape: shape,
          clipBehavior: clipBehavior,
        );
      case Buttons.pinterest:
        return SignInButtonBuilder(
          elevation: elevation,
          key: const ValueKey('Pinterest'),
          mini: mini,
          text: text ?? 'Sign in with Pinterest',
          textStyle: textStyle,
          icon: FontAwesomeIcons.pinterest,
          backgroundColor: const Color(0xFFCB2027),
          onPressed: onPressed,
          padding: padding,
          shape: shape,
          clipBehavior: clipBehavior,
        );
      case Buttons.tumblr:
        return SignInButtonBuilder(
          elevation: elevation,
          key: const ValueKey('Tumblr'),
          mini: mini,
          text: text ?? 'Sign in with Tumblr',
          textStyle: textStyle,
          icon: FontAwesomeIcons.tumblr,
          backgroundColor: const Color(0xFF34526f),
          onPressed: onPressed,
          padding: padding,
          shape: shape,
          clipBehavior: clipBehavior,
        );
      case Buttons.twitter:
        return SignInButtonBuilder(
          elevation: elevation,
          key: const ValueKey('Twitter'),
          mini: mini,
          text: text ?? 'Sign in with Twitter',
          textStyle: textStyle,
          icon: FontAwesomeIcons.twitter,
          backgroundColor: const Color(0xFF1DA1F2),
          onPressed: onPressed,
          padding: padding,
          shape: shape,
          clipBehavior: clipBehavior,
        );
      case Buttons.reddit:
        return SignInButtonBuilder(
          elevation: elevation,
          key: const ValueKey('Reddit'),
          mini: mini,
          text: text ?? 'Sign in with Reddit',
          textStyle: textStyle,
          icon: FontAwesomeIcons.reddit,
          backgroundColor: const Color(0xFFFF4500),
          onPressed: onPressed,
          padding: padding,
          shape: shape,
          clipBehavior: clipBehavior,
        );
      case Buttons.quora:
        return SignInButtonBuilder(
          key: const ValueKey('Quora'),
          mini: mini,
          text: text ?? 'Sign in with Quora',
          textStyle: textStyle,
          icon: FontAwesomeIcons.quora,
          backgroundColor: const Color(0x00a40a00),
          onPressed: onPressed,
          padding: padding,
          shape: shape,
          clipBehavior: clipBehavior,
        );
      case Buttons.yahoo:
        return SignInButtonBuilder(
          key: const ValueKey('Yahoo'),
          mini: mini,
          text: text ?? 'Sign in with Yahoo',
          textStyle: textStyle,
          icon: FontAwesomeIcons.yahoo,
          backgroundColor: const Color(0x006001d2),
          onPressed: onPressed,
          padding: padding,
          shape: shape,
          clipBehavior: clipBehavior,
        );
      case Buttons.hotmail:
        return SignInButtonBuilder(
          key: const ValueKey('Hotmail'),
          mini: mini,
          text: text ?? 'Sign in with Hotmail',
          textStyle: textStyle,
          icon: FontAwesomeIcons.commentSms,
          backgroundColor: const Color(0x000072c6),
          onPressed: onPressed,
          padding: padding,
          shape: shape,
          clipBehavior: clipBehavior,
        );
      case Buttons.xbox:
        return SignInButtonBuilder(
          key: const ValueKey('Xbox'),
          mini: mini,
          text: text ?? 'Sign in with Xbox',
          textStyle: textStyle,
          icon: FontAwesomeIcons.xbox,
          backgroundColor: const Color(0x00107c0f),
          onPressed: onPressed,
          padding: padding,
          shape: shape,
          clipBehavior: clipBehavior,
        );
      case Buttons.microsoft:
        return SignInButtonBuilder(
          key: const ValueKey('Microsoft'),
          mini: mini,
          text: text ?? 'Sign in with Microsoft',
          textStyle: textStyle,
          icon: FontAwesomeIcons.microsoft,
          backgroundColor: const Color(0xff235A9F),
          onPressed: onPressed,
          padding: padding,
          shape: shape,
          clipBehavior: clipBehavior,
        );
      case Buttons.anonymous:
        return SignInButtonBuilder(
          elevation: elevation,
          key: const ValueKey('Anonymous'),
          mini: mini,
          text: text ?? 'Anonymous',
          textStyle: textStyle,
          textColor: const Color.fromRGBO(0, 0, 0, 0.9),
          icon: Icons.account_circle,
          iconColor: Colors.grey,
          backgroundColor: const Color(0xFFFFFFFF),
          onPressed: onPressed,
          padding: padding,
          shape: shape,
          height: 36.0,
          clipBehavior: clipBehavior,
        );
      case Buttons.email:
      default:
        return SignInButtonBuilder(
          elevation: elevation,
          key: const ValueKey('Email'),
          mini: mini,
          text: text ?? 'Sign in with Email',
          textStyle: textStyle,
          icon: Icons.email,
          onPressed: onPressed,
          padding: padding,
          backgroundColor: Colors.grey[700]!,
          shape: shape,
          clipBehavior: clipBehavior,
        );
    }
  }
}
