import 'package:arcane/arcane.dart';

class NavigationSidebarExample1 extends StatefulWidget {
  const NavigationSidebarExample1({super.key});

  @override
  State<NavigationSidebarExample1> createState() =>
      _NavigationSidebarExample1State();
}

class _NavigationSidebarExample1State extends State<NavigationSidebarExample1> {
  int selected = 0;

  NavigationBarItem buildButton(String label, IconData icon) {
    return NavigationButton(
      label: Text(label),
      child: Icon(icon),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 400,
      child: OutlinedContainer(
        child: NavigationSidebar(
          index: selected,
          onSelected: (index) {
            setState(() {
              selected = index;
            });
          },
          children: [
            const NavigationLabel(child: Text('Discovery')),
            buildButton('Listen Now', Icons.play),
            buildButton('Browse', Icons.grid_four),
            buildButton('Radio', Icons.broadcast),
            const NavigationGap(24),
            const NavigationDivider(),
            const NavigationLabel(child: Text('Library')),
            buildButton('Playlist', Icons.music_note),
            buildButton('Songs', Icons.music_note_simple),
            buildButton('For You', Icons.person),
            buildButton('Artists', Icons.microphone),
            buildButton('Albums', Icons.record),
            const NavigationGap(24),
            const NavigationDivider(),
            const NavigationLabel(child: Text('Playlists')),
            buildButton('Recently Added', Icons.music_notes),
            buildButton('Recently Played', Icons.music_notes),
            buildButton('Top Songs', Icons.music_notes),
            buildButton('Top Albums', Icons.music_notes),
            buildButton('Top Artists', Icons.music_notes),
            buildButton('Logic Discography With Some Spice', Icons.music_notes),
            buildButton('Bedtime Beats', Icons.music_notes),
            buildButton('Feeling Happy', Icons.music_notes),
            buildButton('I miss Y2K Pop', Icons.music_notes),
            buildButton('Runtober', Icons.music_notes),
          ],
        ),
      ),
    );
  }
}
