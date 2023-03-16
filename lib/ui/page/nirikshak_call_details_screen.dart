import 'package:flutter/material.dart';
import 'package:nirikshak/nirikshak.dart';

class NirikshakCallDetailsScreen extends StatefulWidget {
  final NirikshakHttpCall call;
  final NirikshakCore core;

  const NirikshakCallDetailsScreen({
    super.key,
    required this.call,
    required this.core,
  });

  @override
  State<NirikshakCallDetailsScreen> createState() =>
      _NirikshakCallDetailsScreenState();
}

class _NirikshakCallDetailsScreenState
    extends State<NirikshakCallDetailsScreen> {
  NirikshakHttpCall get call => widget.call;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final call = widget.core.httpCalls.firstWhere(
        (snapshotCall) => snapshotCall.id == widget.call.id,
        orElse: () => NirikshakHttpCall(-1));

    return Theme(
      data: ThemeData(
        useMaterial3: true,
        brightness: widget.core.brightness,
        colorSchemeSeed: widget.core.colorSchemeSeed,
      ),
      child: call.id != -1 ? _buildMainWidget() : _buildErrorWidget(),
    );
  }

  Widget _buildMainWidget() {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          bottom: TabBar(
            tabs: _getTabBars(),
          ),
          title: const Text(NirikshakStrings.httpCallDetails),
        ),
        body: TabBarView(
          children: _getTabBarViewList(),
        ),
      ),
    );
  }

  Widget _buildErrorWidget() {
    return const Center(child: Text(NirikshakStrings.failedToLoadData));
  }

  List<Widget> _getTabBars() {
    List<Widget> widgets = [];
    widgets.add(const Tab(
      icon: Icon(Icons.info_outline),
      text: NirikshakStrings.overview,
    ));
    widgets.add(const Tab(
      icon: Icon(Icons.arrow_upward),
      text: NirikshakStrings.requests,
    ));
    widgets.add(const Tab(
      icon: Icon(Icons.arrow_downward),
      text: NirikshakStrings.response,
    ));
    widgets.add(const Tab(
      icon: Icon(Icons.warning),
      text: NirikshakStrings.error,
    ));
    return widgets;
  }

  List<Widget> _getTabBarViewList() {
    List<Widget> widgets = [];
    widgets.add(NirikshakCallOverviewWidget(widget.call));
    widgets.add(NirikshakCallRequestWidget(widget.call));
    widgets.add(NirikshakCallResponseWidget(widget.call));
    widgets.add(NirikshakCallErrorWidget(widget.call));
    return widgets;
  }
}
