import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

// a text field that suggests the allowed values while you type
class ChoiceField extends StatefulWidget {
  final String label;
  final List<String> options;
  final TextEditingController controller;

  const ChoiceField({super.key, required this.label, required this.options, required this.controller});

  @override
  State<ChoiceField> createState() => _ChoiceFieldState();
}

class _ChoiceFieldState extends State<ChoiceField> {
  final _focus = FocusNode();

  @override
  void dispose() {
    _focus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, box) {
      return RawAutocomplete<String>(
        textEditingController: widget.controller,
        focusNode: _focus,
        optionsBuilder: (value) =>
            widget.options.where((o) => o.toLowerCase().contains(value.text.toLowerCase())),
        fieldViewBuilder: (context, controller, focusNode, onSubmit) {
          return TextField(
            controller: controller,
            focusNode: focusNode,
            style: const TextStyle(color: ink),
            decoration: fieldDecoration(widget.label, 'Start typing...').copyWith(
              suffixIcon: const Icon(Icons.arrow_drop_down, color: muted),
            ),
          );
        },
        optionsViewBuilder: (context, onSelected, options) {
          return Align(
            alignment: Alignment.topLeft,
            child: Material(
              elevation: 4,
              color: paper,
              child: SizedBox(
                width: box.maxWidth,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxHeight: 240),
                  child: ListView(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    children: [
                      for (final option in options)
                        ListTile(
                          dense: true,
                          title: Text(option, style: const TextStyle(color: ink)),
                          onTap: () => onSelected(option),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      );
    });
  }
}
