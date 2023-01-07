import 'package:flutter/material.dart';
import 'package:markdown_widget/config/highlight_themes.dart'
    as highlight_themes;
import 'package:markdown_widget/markdown_widget.dart';

import 'domain/lint.dart';

class LintDetailsModal {
  static show(BuildContext context, Lint lint) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: 768,
            ),
            child: ListView(
              shrinkWrap: true,
              children: [
                Container(
                  color: Theme.of(context).primaryColor,
                  padding: EdgeInsets.symmetric(
                    vertical: 16,
                    horizontal: 24,
                  ),
                  child: DefaultTextStyle(
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w300,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          lint.name,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text('Group: ${lint.group}'),
                        Text('Maturity: ${lint.maturity}'),
                        Text(
                            'Dart SDK: >= ${lint.sinceDartSdk} • (Linter v${lint.sinceLinter})'),
                      ],
                    ),
                  ),
                ),
                Container(
                  color: Colors.grey.shade50,
                  padding: EdgeInsets.symmetric(
                    vertical: 8,
                  ),
                  child: MarkdownWidget(
                    shrinkWrap: true,
                    selectable: true,
                    data: lint.details,
                    padding: EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 16,
                    ),
                    styleConfig: StyleConfig(
                      preConfig: PreConfig(
                        language: 'dart',
                        decoration: BoxDecoration(
                          color: Colors.blueGrey.shade900,
                        ),
                        textStyle: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontFamily: 'Roboto Mono',
                        ),
                        theme: highlight_themes.androidstudioTheme,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
