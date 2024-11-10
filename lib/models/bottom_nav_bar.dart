import 'package:flutter/material.dart';

/// A beautiful and animated bottom navigation that paints a rounded shape
/// around its [items] to provide a wonderful look.
///
/// Update [selectedIndex] to change the selected item.
/// [selectedIndex] is required and must not be null.
class BottomNavyBar extends StatelessWidget {
  const BottomNavyBar({
    Key? key,
    this.selectedIndex = 0,
    this.backgroundColor,
    this.itemCornerRadius = 24,
    this.containerHeight = 56,
    required this.items,
    required this.onItemSelected,
    this.curve = Curves.easeInOut,
  })  : assert(items.length >= 2 && items.length <= 5),
        super(key: key);

  final int selectedIndex;
  final Color? backgroundColor;
  final double itemCornerRadius;
  final double containerHeight;
  final List<BottomNavyBarItem> items;
  final ValueChanged<int> onItemSelected;
  final Curve curve;

  @override
  Widget build(BuildContext context) {
    final bgColor = backgroundColor ??
        Theme.of(context).bottomAppBarTheme.color ??
        Colors.white;

    return Container(
      decoration: BoxDecoration(
        color: bgColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Container(
          width: double.infinity,
          height: containerHeight,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: items.map((item) {
              var index = items.indexOf(item);
              return GestureDetector(
                onTap: () => onItemSelected(index),
                child: _ItemWidget(
                  item: item,
                  isSelected: index == selectedIndex,
                  backgroundColor: bgColor,
                  itemCornerRadius: itemCornerRadius,
                  animationDuration: const Duration(milliseconds: 270),
                  itemPadding: const EdgeInsets.symmetric(horizontal: 4),
                  curve: curve,
                  showInactiveTitle: false,
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}

class _ItemWidget extends StatelessWidget {
  final bool isSelected;
  final BottomNavyBarItem item;
  final Color backgroundColor;
  final double itemCornerRadius;
  final Duration animationDuration;
  final EdgeInsets itemPadding;
  final Curve curve;
  final bool showInactiveTitle;

  const _ItemWidget({
    Key? key,
    required this.isSelected,
    required this.item,
    required this.backgroundColor,
    required this.itemCornerRadius,
    required this.animationDuration,
    required this.itemPadding,
    required this.showInactiveTitle,
    this.curve = Curves.linear,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Semantics semantic = Semantics(
      container: true,
      selected: isSelected,
      child: AnimatedContainer(
        width: (showInactiveTitle)
            ? ((isSelected)
                ? MediaQuery.of(context).size.width * 0.25
                : MediaQuery.of(context).size.width * 0.2)
            : ((isSelected)
                ? MediaQuery.of(context).size.width * 0.3
                : MediaQuery.of(context).size.width * 0.1),
        height: double.maxFinite,
        duration: animationDuration,
        curve: curve,
        decoration: BoxDecoration(
          color: isSelected
              ? (item.activeBackgroundColor ??
                  item.activeColor.withOpacity(0.2))
              : backgroundColor,
          borderRadius: BorderRadius.circular(itemCornerRadius),
        ),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: NeverScrollableScrollPhysics(),
          child: Container(
            width: (showInactiveTitle)
                ? ((isSelected)
                    ? MediaQuery.of(context).size.width * 0.25
                    : MediaQuery.of(context).size.width * 0.2)
                : ((isSelected)
                    ? MediaQuery.of(context).size.width * 0.3
                    : MediaQuery.of(context).size.width * 0.1),
            padding: EdgeInsets.symmetric(horizontal: 4),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                IconTheme(
                  data: IconThemeData(
                    size: 24,
                    color: isSelected
                        ? item.activeColor.withOpacity(1)
                        : item.inactiveColor == null
                            ? item.activeColor
                            : item.inactiveColor,
                  ),
                  child: item.icon,
                ),
                if (showInactiveTitle)
                  Flexible(
                    child: Container(
                      padding: itemPadding,
                      child: DefaultTextStyle.merge(
                        style: TextStyle(
                          color: item.activeTextColor ?? item.activeColor,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        textAlign: item.textAlign,
                        overflow: TextOverflow.ellipsis,
                        child: item.title,
                      ),
                    ),
                  )
                else if (isSelected)
                  Flexible(
                    child: Container(
                      padding: itemPadding,
                      child: DefaultTextStyle.merge(
                        style: TextStyle(
                          color: item.activeColor,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        textAlign: item.textAlign,
                        overflow: TextOverflow.ellipsis,
                        child: item.title,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
    return item.tooltipText == null
        ? semantic
        : Tooltip(
            message: item.tooltipText!,
            child: semantic,
          );
  }
}

/// The [BottomNavyBar.items] definition.
class BottomNavyBarItem {
  BottomNavyBarItem({
    required this.icon,
    required this.title,
    this.activeColor = Colors.blue,
    this.textAlign,
    this.inactiveColor,
    this.activeTextColor,
    this.activeBackgroundColor,
    this.tooltipText,
  });

  /// Defines this item's icon which is placed in the right side of the [title].
  final Widget icon;

  /// Defines this item's title which placed in the left side of the [icon].
  final Widget title;

  /// The [icon] and [title] color defined when this item is selected. Defaults
  /// to [Colors.blue].
  final Color activeColor;

  /// The [icon] and [title] color defined when this item is not selected.
  final Color? inactiveColor;

  /// The alignment for the [title].
  ///
  /// This will take effect only if [title] it a [Text] widget.
  final TextAlign? textAlign;

  /// The [title] color with higher priority than [activeColor]
  ///
  /// Will fallback to [activeColor] when null
  final Color? activeTextColor;

  /// The [BottomNavyBarItem] background color when active.
  ///
  /// Will fallback to [activeColor] with opacity 0.2 when null
  final Color? activeBackgroundColor;

  /// Will show a tooltip for the item if provided.
  final String? tooltipText;
}
