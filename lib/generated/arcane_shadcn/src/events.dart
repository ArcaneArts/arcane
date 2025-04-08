import 'package:arcane/generated/arcane_shadcn/shadcn_flutter.dart';

ShadcnEvents? $shadEvent;

abstract class ShadcnEvents {
  void onTabChanged(BuildContext context);
  void onMenuOpened(BuildContext context);
  void onTooltipOpened(BuildContext context);
  void onMenuSelection(BuildContext context);
  void onButtonPressed(BuildContext context, AbstractButtonStyle style);
  void onDialogOpened(BuildContext context);
  void onToastOpened(BuildContext context);
}
