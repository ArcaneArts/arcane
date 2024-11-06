import 'package:arcane/arcane.dart';

abstract class ArcaneShowcase {
  final String name;
  final String? description;
  final IconData? icon;

  const ArcaneShowcase({
    required this.name,
    this.description,
    this.icon,
  });

  bool matches(String query) =>
      name.toLowerCase().contains(query.toLowerCase()) ||
      (description?.toLowerCase().contains(query.toLowerCase()) ?? false);

  String get id => "$runtimeType:$name";

  Widget buildCard(BuildContext context) => Stack(
        children: [
          Card(
              filled: true,
              onPressed: () => Arcane.push(context, buildScreen(context)),
              child: Basic(
                leading: icon != null ? Icon(icon) : null,
                title: Text(name),
                subtitle: this is StaticArcaneShowcase
                    ? Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (description != null) Text(description!),
                          buildPreview(context),
                        ],
                      )
                    : description != null
                        ? Text(description!)
                        : null,
              ))
        ],
      );

  Widget buildPreview(BuildContext context);

  Widget buildScreen(BuildContext context);
}

abstract class ScreenArcaneShowcase extends ArcaneShowcase {
  const ScreenArcaneShowcase(
      {required super.name, super.description, super.icon});

  @override
  Widget buildPreview(BuildContext context) => const SizedBox.shrink();
}

abstract class SliverScreenArcaneShowcase extends ScreenArcaneShowcase {
  const SliverScreenArcaneShowcase(
      {required super.name, super.description, super.icon});

  @override
  Widget buildPreview(BuildContext context) => const SizedBox.shrink();

  Widget buildSliver(BuildContext context);

  @override
  Widget buildScreen(BuildContext context) => SliverScreen(
      header: Bar(
        title: Text(name),
      ),
      sliver: buildSliver(context));
}

abstract class FillScreenArcaneShowcase extends ScreenArcaneShowcase {
  const FillScreenArcaneShowcase(
      {required super.name, super.description, super.icon});

  @override
  Widget buildPreview(BuildContext context) => const SizedBox.shrink();

  Widget buildFill(BuildContext context);

  @override
  Widget buildScreen(BuildContext context) => FillScreen(
      header: Bar(
        title: Text(name),
      ),
      child: buildFill(context));
}

abstract class StaticArcaneShowcase extends ArcaneShowcase {
  const StaticArcaneShowcase(
      {required super.name, super.description, super.icon});

  @override
  Widget buildPreview(BuildContext context);

  @override
  Widget buildScreen(BuildContext context) => FillScreen(
      header: Bar(
        title: Text(name),
      ),
      child: Center(child: buildPreview(context)));
}
