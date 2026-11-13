import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';

class CollapsibleSidebar extends StatefulWidget {
  final Color? backgroundColor;
  final List<CollapsibleSidebarItem?>? children;
  final Widget? footer;
  final Widget? header;
  final Color? itemColor;
  final EdgeInsets? padding;

  const CollapsibleSidebar({
    super.key,
    this.backgroundColor,
    this.footer,
    this.header,
    this.itemColor,
    this.padding,
    this.children,
  });

  @override
  State<StatefulWidget> createState() => _CollapsibleSidebarState();
}

class _CollapsibleSidebarState extends State<CollapsibleSidebar> {
  @override
  Widget build(BuildContext context) => Container(
        color: widget.backgroundColor,
        padding: widget.padding,
        child: Stack(
          children: [
            ListView(
              padding: widget.footer == null
                  ? EdgeInsets.zero
                  : const EdgeInsets.only(bottom: 100),
              shrinkWrap: true,
              physics: const ScrollPhysics(),
              children: List.castFrom<Widget?, Widget>([
                widget.header ?? Container(),
                ...widget.children ?? [],
              ]),
            ),
            widget.footer == null
                ? Container()
                : Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      alignment: Alignment.center,
                      color: widget.backgroundColor,
                      height: 80,
                      child: widget.footer ?? Container(),
                    ),
                  ),
          ],
        ),
      );
}

class CollapsibleSidebarItem extends StatefulWidget {
  final double? arrowSize;
  final Widget? icon;
  final VoidCallback? onSelected;
  final EdgeInsets padding;
  final bool selected;
  final Color? selectedColor;
  final Widget? title;
  final CollapsibleSidebar? list;

  const CollapsibleSidebarItem({
    super.key,
    this.arrowSize,
    this.icon,
    this.onSelected,
    this.padding = const EdgeInsets.fromLTRB(20, 10, 20, 10),
    this.selected = false,
    this.selectedColor,
    this.title,
    this.list,
  });

  @override
  State<StatefulWidget> createState() => _CollapsibleSidebarItemState();
}

class _CollapsibleSidebarItemState extends State<CollapsibleSidebarItem> {
  bool _collapsed = false;

  @override
  Widget build(BuildContext context) => Column(
        children: [
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: widget.onSelected == null
                  ? null
                  : () => setState(() {
                        _collapsed = !_collapsed;

                        widget.onSelected!();
                      }),
              child: AnimatedContainer(
                color: widget.selected
                    ? (widget.selectedColor ?? Colors.grey.withOpacity(0.1))
                    : Colors.transparent,
                curve: Curves.fastOutSlowIn,
                duration: const Duration(seconds: 3),
                padding: widget.padding,
                child: Stack(
                  alignment: Alignment.centerLeft,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        widget.icon ?? Container(width: 20),
                        const SizedBox(width: 10),
                        widget.title!,
                      ],
                    ),
                    Container(
                      alignment: Alignment.centerRight,
                      child: widget.list!.children!.isEmpty
                          ? Container()
                          : Icon(
                              widget.selected
                                  ? SimpleLineIcons.arrow_down
                                  : SimpleLineIcons.arrow_right,
                              color:
                                  widget.selected ? Colors.white : Colors.grey,
                              size: widget.arrowSize,
                            ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(left: 0),
            child: widget.selected ? widget.list : Container(),
          ),
        ],
      );
}
