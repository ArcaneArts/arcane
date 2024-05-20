import 'package:arcane/arcane.dart';
import 'package:arcane/feature/service/window_service.dart';

class ArcaneTitleBar extends StatelessWidget {
  final Widget title;
  final Widget? leading;
  final Color? color;
  final Color? surfaceColor;
  final PlatformTheme? theme;

  const ArcaneTitleBar(
      {super.key,
      required this.title,
      this.leading,
      this.color,
      this.surfaceColor,
      this.theme});

  @override
  Widget build(BuildContext context) => TitleBar(
        title: title,
        leading: leading,
        color: color,
        surfaceColor: surfaceColor,
        theme: theme,
        onUnMaximize: () => svc<WindowService>().onUnMaximize(),
        onStartDragging: () => svc<WindowService>().onStartDragging(),
        isMaximized: () => svc<WindowService>().isMaximized,
        onMaximize: () => svc<WindowService>().onMaximize(),
        onClose: () => svc<WindowService>().onClose(),
        onMinimize: () => svc<WindowService>().onMaximize(),
      );
}
