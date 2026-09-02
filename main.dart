import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const NovaApp());
}

class NovaApp extends StatelessWidget {
  const NovaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Nova Video Editor',
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF08090D),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF7C5CFF),
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      home: const NovaHome(),
    );
  }
}

class NovaHome extends StatefulWidget {
  const NovaHome({super.key});

  @override
  State<NovaHome> createState() => _NovaHomeState();
}

class _NovaHomeState extends State<NovaHome> {
  int tab = 0;

  Future<void> _newProject() async {
    final result = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: const Color(0xFF15171F),
      showDragHandle: true,
      builder: (_) => const _ImportSheet(),
    );
    if (!mounted || result == null) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => NovaEditor(projectType: result),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      _HomePage(onNewProject: _newProject),
      const _ProjectsPage(),
      const _TemplatesPage(),
      const _SettingsPage(),
    ];

    return Scaffold(
      body: SafeArea(child: pages[tab]),
      bottomNavigationBar: NavigationBar(
        selectedIndex: tab,
        onDestinationSelected: (i) => setState(() => tab = i),
        backgroundColor: const Color(0xFF0D0F15),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.folder_outlined), selectedIcon: Icon(Icons.folder), label: 'Projects'),
          NavigationDestination(icon: Icon(Icons.auto_awesome_outlined), selectedIcon: Icon(Icons.auto_awesome), label: 'Templates'),
          NavigationDestination(icon: Icon(Icons.settings_outlined), selectedIcon: Icon(Icons.settings), label: 'Settings'),
        ],
      ),
    );
  }
}

class _HomePage extends StatelessWidget {
  final VoidCallback onNewProject;
  const _HomePage({required this.onNewProject});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(20, 22, 20, 0),
          sliver: SliverToBoxAdapter(
            child: Row(
              children: [
                Container(
                  width: 44, height: 44,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    gradient: const LinearGradient(colors: [Color(0xFF8B6CFF), Color(0xFF5B3DDB)]),
                  ),
                  child: const Icon(Icons.bolt_rounded, color: Colors.white),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('NOVA', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, letterSpacing: 2)),
                      Text('Video Editor', style: TextStyle(fontSize: 21, fontWeight: FontWeight.w800)),
                    ],
                  ),
                ),
                IconButton(onPressed: () {}, icon: const Icon(Icons.notifications_none_rounded)),
              ],
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(20, 26, 20, 0),
          sliver: SliverToBoxAdapter(
            child: GestureDetector(
              onTap: onNewProject,
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft, end: Alignment.bottomRight,
                    colors: [Color(0xFF20164A), Color(0xFF11131C)],
                  ),
                  border: Border.all(color: const Color(0xFF4B3B86)),
                ),
                child: const Row(
                  children: [
                    CircleAvatar(
                      radius: 28,
                      backgroundColor: Color(0xFF7C5CFF),
                      child: Icon(Icons.add_rounded, size: 30),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Create New Project', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
                          SizedBox(height: 4),
                          Text('Video • Photo • PDF • Audio', style: TextStyle(color: Colors.white60)),
                        ],
                      ),
                    ),
                    Icon(Icons.chevron_right_rounded, color: Colors.white54),
                  ],
                ),
              ),
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(20, 26, 20, 10),
          sliver: SliverToBoxAdapter(
            child: Text('Quick Tools', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800)),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          sliver: SliverGrid.count(
            crossAxisCount: 4,
            mainAxisSpacing: 10,
            crossAxisSpacing: 8,
            childAspectRatio: .88,
            children: const [
              _QuickTool(Icons.content_cut_rounded, 'Trim'),
              _QuickTool(Icons.call_split_rounded, 'Split'),
              _QuickTool(Icons.speed_rounded, 'Speed'),
              _QuickTool(Icons.music_note_rounded, 'Music'),
              _QuickTool(Icons.text_fields_rounded, 'Text'),
              _QuickTool(Icons.auto_awesome_rounded, 'Effects'),
              _QuickTool(Icons.filter_vintage_rounded, 'Filters'),
              _QuickTool(Icons.crop_rounded, 'Crop'),
            ],
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 10),
          sliver: SliverToBoxAdapter(
            child: Row(
              children: [
                Text('Recent Projects', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800)),
                const Spacer(),
                TextButton(onPressed: () {}, child: const Text('See all')),
              ],
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          sliver: SliverToBoxAdapter(
            child: Container(
              height: 120,
              decoration: BoxDecoration(
                color: const Color(0xFF11131A),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.movie_creation_outlined, size: 30, color: Colors.white38),
                    SizedBox(height: 8),
                    Text('No projects yet', style: TextStyle(color: Colors.white54)),
                  ],
                ),
              ),
            ),
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 24)),
      ],
    );
  }
}

class _QuickTool extends StatelessWidget {
  final IconData icon;
  final String label;
  const _QuickTool(this.icon, this.label);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 58, height: 58,
          decoration: BoxDecoration(
            color: const Color(0xFF151821),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: Colors.white10),
          ),
          child: Icon(icon, size: 25),
        ),
        const SizedBox(height: 7),
        Text(label, style: const TextStyle(fontSize: 11, color: Colors.white70)),
      ],
    );
  }
}

class _ImportSheet extends StatelessWidget {
  const _ImportSheet();

  Future<void> _pick(BuildContext context, String type) async {
    Navigator.pop(context, type);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 30),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Start a project', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
          const SizedBox(height: 18),
          Wrap(
            spacing: 12, runSpacing: 12,
            children: [
              _ImportButton(Icons.videocam_rounded, 'Video', () => _pick(context, 'Video')),
              _ImportButton(Icons.photo_rounded, 'Photo', () => _pick(context, 'Photo')),
              _ImportButton(Icons.picture_as_pdf_rounded, 'PDF', () => _pick(context, 'PDF')),
              _ImportButton(Icons.audiotrack_rounded, 'Audio', () => _pick(context, 'Audio')),
            ],
          ),
        ],
      ),
    );
  }
}

class _ImportButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _ImportButton(this.icon, this.label, this.onTap);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        width: 145, height: 88,
        decoration: BoxDecoration(
          color: const Color(0xFF20232E),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: const Color(0xFF9A82FF)),
            const SizedBox(height: 6),
            Text(label, style: const TextStyle(fontWeight: FontWeight.w700)),
          ],
        ),
      ),
    );
  }
}

class NovaEditor extends StatefulWidget {
  final String projectType;
  const NovaEditor({super.key, required this.projectType});

  @override
  State<NovaEditor> createState() => _NovaEditorState();
}

class _NovaEditorState extends State<NovaEditor> {
  String selected = 'Trim';

  final tools = const [
    ['Trim', Icons.content_cut_rounded],
    ['Split', Icons.call_split_rounded],
    ['Text', Icons.text_fields_rounded],
    ['Music', Icons.music_note_rounded],
    ['Filter', Icons.filter_vintage_rounded],
    ['Effects', Icons.auto_awesome_rounded],
    ['Crop', Icons.crop_rounded],
    ['Speed', Icons.speed_rounded],
    ['Volume', Icons.volume_up_rounded],
    ['Overlay', Icons.layers_rounded],
  ];

  Future<void> importFile() async {
    if (widget.projectType == 'Photo') {
      await ImagePicker().pickImage(source: ImageSource.gallery);
    } else if (widget.projectType == 'Video') {
      await ImagePicker().pickVideo(source: ImageSource.gallery);
    } else {
      await FilePicker.platform.pickFiles(allowMultiple: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF08090D),
      appBar: AppBar(
        backgroundColor: const Color(0xFF08090D),
        title: Text(widget.projectType == 'PDF' ? 'PDF Project' : 'Untitled Project'),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.undo_rounded)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.redo_rounded)),
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: FilledButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.ios_share_rounded, size: 18),
              label: const Text('Export'),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            flex: 5,
            child: Container(
              margin: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFF11131A),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: Colors.white10),
              ),
              child: Stack(
                children: [
                  const Center(child: Icon(Icons.play_circle_fill_rounded, size: 66, color: Colors.white24)),
                  Positioned(
                    left: 12, right: 12, bottom: 12,
                    child: Row(
                      children: const [
                        Text('00:00', style: TextStyle(fontSize: 11)),
                        Expanded(child: Slider(value: .15, onChanged: null)),
                        Text('00:15', style: TextStyle(fontSize: 11)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            height: 104,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 6,
              itemBuilder: (_, i) => Container(
                width: 92, margin: const EdgeInsets.only(right: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFF1A1C24),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: i == 0 ? const Color(0xFF7C5CFF) : Colors.white10, width: i == 0 ? 2 : 1),
                ),
                child: Center(child: Icon(i == 0 ? Icons.video_file_rounded : Icons.image_outlined, color: Colors.white38)),
              ),
            ),
          ),
          const Divider(height: 1, color: Colors.white10),
          SizedBox(
            height: 102,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              scrollDirection: Axis.horizontal,
              itemCount: tools.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (_, i) {
                final t = tools[i];
                final active = selected == t[0];
                return GestureDetector(
                  onTap: () => setState(() => selected = t[0] as String),
                  child: Container(
                    width: 70,
                    decoration: BoxDecoration(
                      color: active ? const Color(0xFF241A4E) : const Color(0xFF13151C),
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: active ? const Color(0xFF7C5CFF) : Colors.white10),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(t[1] as IconData, size: 23),
                        const SizedBox(height: 7),
                        Text(t[0] as String, style: const TextStyle(fontSize: 10)),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(14, 2, 14, 10),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: importFile,
                      icon: const Icon(Icons.add_rounded),
                      label: const Text('Add Media'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  FilledButton(
                    onPressed: () {},
                    child: const Icon(Icons.play_arrow_rounded),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProjectsPage extends StatelessWidget {
  const _ProjectsPage();
  @override
  Widget build(BuildContext context) => const Center(child: Text('Projects'));
}

class _TemplatesPage extends StatelessWidget {
  const _TemplatesPage();
  @override
  Widget build(BuildContext context) => const Center(child: Text('Templates'));
}

class _SettingsPage extends StatelessWidget {
  const _SettingsPage();
  @override
  Widget build(BuildContext context) => const Center(child: Text('Settings'));
}
