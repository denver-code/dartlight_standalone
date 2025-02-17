import 'package:dartlight_standalone/editor.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DartLight Editor',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'JetBrainsMono',
        colorScheme: ColorScheme.dark(
          primary: Colors.blue,
          secondary: Colors.blueAccent,
          surface: const Color.fromARGB(255, 25, 25, 25),
        ),
        scaffoldBackgroundColor: const Color.fromARGB(255, 11, 11, 11),
        useMaterial3: true,
        brightness: Brightness.dark,
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1E1E1E),
          elevation: 0,
          systemOverlayStyle: SystemUiOverlayStyle.light,
        ),
      ),
      home: const EditorScreen(),
    );
  }
}

class EditorScreen extends StatefulWidget {
  const EditorScreen({super.key});

  @override
  State<EditorScreen> createState() => _EditorScreenState();
}

class _EditorScreenState extends State<EditorScreen> {
  double _leftPanelWidth = 0.5;
  final TextEditingController _editorController = TextEditingController();

  @override
  void dispose() {
    _editorController.dispose();
    super.dispose();
  }

  void _handleDrag(DragUpdateDetails details) {
    setState(() {
      final width = context.size?.width ?? 0;
      if (width > 0) {
        _leftPanelWidth += details.delta.dx / width;
        _leftPanelWidth = _leftPanelWidth.clamp(0.2, 0.8);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(builder: (context, constraints) {
        return Row(
          children: [
            SizedBox(
              width: constraints.maxWidth * _leftPanelWidth,
              child: Container(
                margin: const EdgeInsets.only(left: 8, top: 8, bottom: 8),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: LayoutBuilder(
                    builder: (context, constraints) => SizedBox(
                      width: constraints.maxWidth,
                      height: constraints.maxHeight,
                      child: CodeEditor(
                        controller: _editorController,
                        onChanged: (value) {
                          // Handle code changes here
                          // print('Code changed: $value');
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),
            MouseRegion(
              cursor: SystemMouseCursors.resizeColumn,
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onHorizontalDragUpdate: _handleDrag,
                child: Container(
                  width: 8.0,
                  color: Colors.transparent,
                ),
              ),
            ),
            Expanded(
              child: Container(
                margin: const EdgeInsets.only(right: 8, top: 8, bottom: 8),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: const Center(
                  child: Text(
                    'Right Panel',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}
