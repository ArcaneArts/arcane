import 'package:arcane/arcane.dart';
import 'package:icon_designer/model/icon_proxy.dart';

void main() async {
  await init();
  runApp(const ArcaneApp(
    title: "Icon Designer",
    home: Home(),
  ));
}

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) => SliverScreen(
          sliver: MultiSliver(
        children: [
          ...IconProxySrc.values.map((e) => BarSection(
              titleText: e.name,
              sliver: SGridView.builder(
                  maxCrossAxisExtent: 50,
                  builder: (context, i) =>
                      ProxyIcon(icon: mappings[e]!.icons[i]),
                  childCount: mappings[e]!.icons.length)))
        ],
      ));
}

class ProxyIcon extends StatelessWidget {
  final MappedIcon icon;

  const ProxyIcon({super.key, required this.icon});

  @override
  Widget build(BuildContext context) => HoverCard(
      hoverBuilder: (context) => SurfaceCard(
              child: Basic(
            leading: Icon(icon.iconData),
            title: Text(icon.name),
            subtitle: icon.variants != null
                ? Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ...icon.variants!.map((e) => ProxyIcon(icon: e)),
                    ],
                  )
                : const Text("No Variants"),
          )),
      child: Icon(
        icon.iconData,
        size: 36,
      ));
}
