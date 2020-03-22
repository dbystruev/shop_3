import 'package:flutter/material.dart';


class SearchBar extends StatefulWidget {
  SearchBar({Key key, this.hint, this.onChanged}) : super(key: key);
  final void Function(TextEditingController) onChanged;
  final hint;
  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  TextEditingController _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 32.0,right:32.0, top: 16.0, bottom: 8.0),
      child: TextField(
        decoration: InputDecoration(
          hintText: widget.hint,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
          suffixIcon: Icon(Icons.search),
        ),
        controller: _controller,
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _controller.addListener(() => widget.onChanged(_controller));
  }

  @override
  void dispose() {
    this._controller.dispose();
    super.dispose();
  }
}