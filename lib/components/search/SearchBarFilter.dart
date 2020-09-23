import 'package:artsideout_app/theme.dart';
import 'package:flutter/material.dart';
import 'package:artsideout_app/components/search/FilterDropdown.dart';

class SearchBarFilter extends StatefulWidget {
  final Function handleTextChange;
  final Function handleTextClear;
  final bool isLoading;
  final Map<String, bool> optionsMap;
  final TextEditingController searchQueryController;

  SearchBarFilter(this.handleTextChange, this.handleTextClear, this.isLoading,
      this.optionsMap, this.searchQueryController);

  _SearchBarFilterState createState() => _SearchBarFilterState();
}

class _SearchBarFilterState extends State<SearchBarFilter> {
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 10,
          child: TextField(
            controller: widget.searchQueryController,
            autofocus: true,
            decoration: InputDecoration(
              prefixIcon: IconButton(
                icon: Icon(Icons.search),
                color: asoPrimary,
                onPressed: widget.handleTextChange,
              ),
              suffix: SizedBox(
                height: 26,
                width: 26,
                child: widget.isLoading
                    ? CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation(asoPrimary),
                        backgroundColor: Colors.white,
                      )
                    : GestureDetector(
                        child: Icon(
                          Icons.close,
                          size: 26,
                        ),
                        onTap: widget.handleTextClear,
                      ),
              ),
              hintText: "Search installations, activities, artists...",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              hintStyle: TextStyle(color: Colors.black),
            ),
            style: TextStyle(color: Colors.black, fontSize: 22.0),
            onEditingComplete: widget.handleTextChange,
          ),
        ),
        SizedBox(
          width: 5,
        ),
        Container(
          width: 130,
          child: FilterDropdown(
            onFilterChange: (String value) {
              setState(() {
                widget.optionsMap[value] = !widget.optionsMap[value];
              });
            },
            optionsMap: widget.optionsMap,
          ),
        )
      ],
    );
  }
}
