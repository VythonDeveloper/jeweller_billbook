import 'package:flutter/material.dart';
import 'package:jeweller_stockbook/utils/components.dart';
import '../Helper/sdp.dart';
import 'colors.dart';

class KScaffold extends StatefulWidget {
  final bool? isLoading;
  final String? loadingText;
  final PreferredSizeWidget? appBar;
  final Widget body;
  final Widget? bottomNavigationBar;
  final Widget? floatingActionButton;
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  const KScaffold(
      {super.key,
      this.isLoading,
      this.appBar,
      required this.body,
      this.bottomNavigationBar,
      this.loadingText,
      this.floatingActionButton,
      this.floatingActionButtonLocation});

  @override
  State<KScaffold> createState() => _KScaffoldState();
}

class _KScaffoldState extends State<KScaffold> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.appBar,
      body: Stack(
        children: [
          widget.body,
          AnimatedSwitcher(
            duration: Duration(milliseconds: 250),
            child: widget.isLoading ?? false
                ? kFullLoading(context, loadingText: widget.loadingText)
                : SizedBox(),
          ),
        ],
      ),
      floatingActionButton: widget.floatingActionButton,
      floatingActionButtonLocation: widget.floatingActionButtonLocation,
      bottomNavigationBar: widget.bottomNavigationBar,
    );
  }
}

AppBar KAppBar(
  BuildContext context, {
  required String title,
  bool? isLoading,
  bool? showBack,
  List<Widget>? actions,
}) {
  return AppBar(
    title: Text(title),
    automaticallyImplyLeading: showBack ?? false,
    actions: actions,
    titleTextStyle: TextStyle(
      fontSize: sdp(context, 12),
      fontWeight: FontWeight.w500,
      fontFamily: 'Poppins',
      letterSpacing: .5,
    ),
    bottom: PreferredSize(
      preferredSize: Size.fromHeight(1),
      child: isLoading ?? false
          ? LinearProgressIndicator(
              minHeight: 2,
              color: kPrimaryColor,
              backgroundColor: Colors.white,
            )
          : SizedBox.shrink(),
    ),
  );
}

Container kFullLoading(BuildContext context, {String? loadingText}) {
  return Container(
    height: double.infinity,
    width: double.infinity,
    alignment: Alignment.center,
    color: Colors.white.withOpacity(0.9),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          loadingText ?? "Please Wait...",
          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                fontWeight: FontWeight.w500,
                letterSpacing: .7,
              ),
        ),
        height10,
        SizedBox(
          width: sdp(context, 60),
          child: LinearProgressIndicator(
            backgroundColor: kColor(context).primaryContainer,
            color: kColor(context).primary,
            minHeight: 6,
          ),
        ),
      ],
    ),
  );
}
