library animation_search_bar;

import 'package:fiboutiquesv1/widgets/custom_btn_serach.dart';
import 'package:fiboutiquesv1/widgets/custom_search_bar.dart';
import 'package:flutter/cupertino.dart' show CupertinoPageRoute;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'
    show ProviderScope, StateProvider, Consumer;

final searchingProvider = StateProvider.autoDispose((ref) => false);

// ignore: must_be_immutable
class AnimationSearchBar extends StatelessWidget {
  AnimationSearchBar({
    Key? key,
    this.searchBarWidth,
    this.searchBarHeight,
    this.previousScreen,
    this.backIconColor,
    this.closeIconColor,
    this.searchIconColor,
    this.centerTitle,
    this.centerTitleStyle,
    this.searchFieldHeight,
    this.searchFieldDecoration,
    this.cursorColor,
    this.textStyle,
    this.hintText,
    this.hintStyle,
    required this.onChanged,
    required this.searchTextEditingController,
    this.horizontalPadding,
    this.verticalPadding,
    this.isBackButtonVisible,
    this.backIcon,
    this.duration,
  }) : super(key: key);

  ///
  final double? searchBarWidth;
  final double? searchBarHeight;
  final double? searchFieldHeight;
  final double? horizontalPadding;
  final double? verticalPadding;
  final Widget? previousScreen;
  final Color? backIconColor;
  final Color? closeIconColor;
  final Color? searchIconColor;
  final Color? cursorColor;
  final String? centerTitle;
  final String? hintText;
  final bool? isBackButtonVisible;
  final IconData? backIcon;
  final TextStyle? centerTitleStyle;
  final TextStyle? textStyle;
  final TextStyle? hintStyle;
  final Decoration? searchFieldDecoration;
  late Duration? duration;
  final TextEditingController searchTextEditingController;
  final Function(String) onChanged;

  @override
  Widget build(BuildContext context) {
    final _duration = duration ?? const Duration(milliseconds: 500);
    final _searchFieldHeight = searchFieldHeight ?? 40;
    final _hPadding = horizontalPadding != null ? horizontalPadding! * 2 : 0;
    final _searchBarWidth =
        searchBarWidth ?? MediaQuery.of(context).size.width - _hPadding;
    final _isBackButtonVisible = isBackButtonVisible ?? true;
    return ProviderScope(
      child: Consumer(builder: (context, ref, __) {
        final _isSearching = ref.watch(searchingProvider);
        final _searchNotifier = ref.watch(searchingProvider.notifier);
        return Padding(
          padding: EdgeInsets.symmetric(
              horizontal: horizontalPadding ?? 0,
              vertical: verticalPadding ?? 0),
          child: SizedBox(
            width: _searchBarWidth,
            height: searchBarHeight ?? 50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                /// back Button
                _isBackButtonVisible
                    ? AnimatedOpacity(
                        opacity: _isSearching ? 0 : 1,
                        duration: _duration,
                        child: AnimatedContainer(
                            curve: Curves.easeInOutCirc,
                            width: _isSearching ? 0 : 35,
                            height: _isSearching ? 0 : 35,
                            duration: _duration,
                            child: FittedBox(
                                child: KBackButton(
                                    icon: backIcon,
                                    iconColor: backIconColor,
                                    previousScreen: previousScreen))))
                    : AnimatedContainer(
                        curve: Curves.easeInOutCirc,
                        width: _isSearching ? 0 : 35,
                        height: _isSearching ? 0 : 35,
                        duration: _duration),

                /// text
                AnimatedOpacity(
                  opacity: _isSearching ? 0 : 1,
                  duration: _duration,
                  child: AnimatedContainer(
                    curve: Curves.easeInOutCirc,
                    width: _isSearching ? 0 : _searchBarWidth - 100,
                    duration: _duration,
                    alignment: Alignment.center,
                    child: FittedBox(
                      child: Text(
                        centerTitle ?? 'Title',
                        textAlign: TextAlign.center,
                        style: centerTitleStyle ??
                            const TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                              fontSize: 20,
                            ),
                      ),
                    ),
                  ),
                ),

                /// close search
                AnimatedOpacity(
                  opacity: _isSearching ? 1 : 0,
                  duration: _duration,
                  child: AnimatedContainer(
                    curve: Curves.easeInOutCirc,
                    width: _isSearching ? 35 : 0,
                    height: _isSearching ? 35 : 0,
                    duration: _duration,
                    child: FittedBox(
                      child: KCustomButton(
                        widget: Padding(
                            padding: const EdgeInsets.all(3),
                            child: Icon(Icons.close,
                                color: closeIconColor ??
                                    Colors.black.withOpacity(.7))),
                        onPressed: () {
                          _searchNotifier.state = false;
                          searchTextEditingController.clear();
                        },
                      ),
                    ),
                  ),
                ),

                /// input panel
                AnimatedOpacity(
                  opacity: _isSearching ? 1 : 0,
                  duration: _duration,
                  child: AnimatedContainer(
                    curve: Curves.easeInOutCirc,
                    duration: _duration,
                    width: _isSearching
                        ? _searchBarWidth - 55 - (horizontalPadding ?? 0 * 2)
                        : 0,
                    height: _isSearching ? _searchFieldHeight : 20,
                    margin: EdgeInsets.only(
                        left: _isSearching ? 5 : 0,
                        right: _isSearching ? 10 : 0),
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    alignment: Alignment.center,
                    decoration: searchFieldDecoration ??
                        BoxDecoration(
                            color: Colors.black.withOpacity(.05),
                            border: Border.all(
                                color: Colors.black.withOpacity(.2), width: .5),
                            borderRadius: BorderRadius.circular(15)),
                    child: TextField(
                      controller: searchTextEditingController,
                      cursorColor: cursorColor ?? Colors.lightBlue,
                      style: textStyle ??
                          const TextStyle(
                              color: Colors.black, fontWeight: FontWeight.w300),
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.zero,
                        hintText: hintText ?? 'Search here...',
                        hintStyle: hintStyle ??
                            const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w300),
                        disabledBorder: const OutlineInputBorder(
                            borderSide: BorderSide.none),
                        focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide.none),
                        enabledBorder: const OutlineInputBorder(
                            borderSide: BorderSide.none),
                        border: const OutlineInputBorder(
                            borderSide: BorderSide.none),
                      ),
                      onChanged: onChanged,
                    ),
                  ),
                ),

                ///  search button
                AnimatedOpacity(
                  opacity: _isSearching ? 0 : 1,
                  duration: _duration,
                  child: AnimatedContainer(
                    curve: Curves.easeInOutCirc,
                    duration: _duration,
                    width: _isSearching ? 0 : 35,
                    height: _isSearching ? 0 : 35,
                    child: FittedBox(
                      child: KCustomButton(
                          widget: Padding(
                              padding: const EdgeInsets.all(5),
                              child: Icon(Icons.search,
                                  size: 35,
                                  color: searchIconColor ??
                                      Colors.black.withOpacity(.7))),
                          onPressed: () => _searchNotifier.state = true),
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      }),
    );
  }
}


