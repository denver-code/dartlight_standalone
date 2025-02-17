import 'package:flutter/material.dart';
import 'package:flutter_highlight/flutter_highlight.dart';
import 'package:flutter_highlight/themes/atom-one-dark.dart';

class CodeEditor extends StatefulWidget {
  final TextEditingController controller;
  final Function(String)? onChanged;

  const CodeEditor({super.key, required this.controller, this.onChanged});

  @override
  State<CodeEditor> createState() => _CodeEditorState();
}

class _CodeEditorState extends State<CodeEditor> {
  final FocusNode _focusNode = FocusNode();
  String _code = '';

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onTextChanged);
    _focusNode.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    setState(() {
      _code = widget.controller.text;
    });

    if (widget.onChanged != null) {
      widget.onChanged!(_code);
    }
  }

  @override
  Widget build(BuildContext context) {
    final lines = _code.split('\n').length;
    return Container(
        color: Theme.of(context).colorScheme.surface,
        child: Row(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          // Line Numbers
          Container(
            width: 40,
            color: const Color.fromARGB(255, 30, 30, 30),
            padding: const EdgeInsets.fromLTRB(0, 12, 0, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: List.generate(
                lines,
                (index) => Text(
                  '${index + 1}',
                  style: const TextStyle(
                    fontFamily: 'JetBrainsMono',
                    fontSize: 14.0,
                    height: 1.5,
                    letterSpacing: 0.5,
                    color: Color.fromARGB(255, 100, 100, 100),
                  ),
                ),
              ),
            ),
          ),
          // Editor Content
          Expanded(
            child: Stack(
              children: [
                // Syntax Highlighting
                Positioned.fill(
                  child: HighlightView(
                    _code.isEmpty
                        ? '// Start typing your Dart code here...'
                        : _code,
                    language: 'dart',
                    theme: Map<String, TextStyle>.from(atomOneDarkTheme)
                      ..addAll({
                        'root': const TextStyle(
                          backgroundColor: Colors.transparent,
                          color: Colors.white,
                        ),
                      }),
                    padding: const EdgeInsets.fromLTRB(5, 12, 16, 12),
                    textStyle: const TextStyle(
                      fontFamily: 'JetBrainsMono',
                      fontSize: 14.0,
                      height: 1.5,
                      letterSpacing: 0.5,
                      color: Colors.white,
                    ),
                  ),
                ),
                // Editable Text Overlay
                Positioned.fill(
                  child: TextField(
                    controller: widget.controller,
                    focusNode: _focusNode,
                    style: const TextStyle(
                      fontFamily: 'JetBrainsMono',
                      fontSize: 14.0,
                      height: 1.5,
                      letterSpacing: 0.5,
                      color: Colors.transparent,
                    ),
                    cursorColor: Colors.white,
                    cursorWidth: 2,
                    cursorHeight: 18,
                    maxLines: null,
                    expands: true,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.fromLTRB(5, 16, 16, 12),
                      isCollapsed: true,
                    ),
                    onChanged: (text) {
                      setState(() {
                        _code = text;
                      });
                      if (widget.onChanged != null) {
                        widget.onChanged!(text);
                      }
                    },
                  ),
                ),
              ],
            ),
          )
        ]));
  }
}
