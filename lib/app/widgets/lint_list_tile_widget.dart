import 'package:flutter/material.dart';

import '../domain/lint.dart';
import 'lint_badge_widget.dart';

class LintListTile extends StatelessWidget {
  const LintListTile({
    Key? key,
    required this.lint,
    required this.showWarning,
    required this.lintsIncompatible,
    required this.onTap,
    required this.onCheckboxChanged,
  }) : super(key: key);

  final Lint lint;
  final bool showWarning;
  final List<String> lintsIncompatible;
  final VoidCallback onTap;
  final ValueChanged<bool?> onCheckboxChanged;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        lint.name,
        style: TextStyle(
          color: Colors.blue.shade900,
          fontWeight: FontWeight.bold,
          fontSize: 15,
        ),
      ),
      subtitle: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Builder(builder: (context) {
              if (lint.sets.isEmpty && lint.fixStatus != 'hasFix') {
                return const SizedBox.shrink();
              }
              final List<Widget> widgets = [];

              for (String set in lint.sets) widgets.add(BadgeLint(set: set));

              if (lint.fixStatus == 'hasFix')
                widgets.add(const BadgeLint(
                  set: 'has fix',
                ));

              return Wrap(
                spacing: 8,
                direction: Axis.horizontal,
                children: widgets,
              );
            }),
            Text(
              lint.description,
              style: TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.w300,
                fontSize: 15,
              ),
            ),
            if (showWarning)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  children: [
                    Icon(
                      Icons.warning_rounded,
                      color: Colors.red,
                    ),
                    SizedBox(width: 4),
                    Flexible(
                      child: Text(
                        "Incompatible with: ${lintsIncompatible.join(", ")}",
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.w300,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
      trailing: Checkbox(
        value: lint.isSelected,
        onChanged: onCheckboxChanged,
      ),
      onTap: onTap,
    );
  }
}
