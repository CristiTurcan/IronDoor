import 'package:flutter/material.dart';

class HistoryContent extends StatefulWidget {
  final List<String> items;
  const HistoryContent({super.key, required this.items});

  @override
  State<HistoryContent> createState() => _HistoryContentState();
}

class _HistoryContentState extends State<HistoryContent> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
          itemCount: widget.items.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(
                widget.items[index],
                textAlign: TextAlign.center,
              ),
            );
          }),
    );
  }
}
