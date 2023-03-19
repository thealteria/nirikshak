import 'package:flutter/material.dart';

import '../../nirikshak.dart';

class NirikshakCallsListScreen extends StatefulWidget {
  final NirikshakCore _nirikshakCore;

  const NirikshakCallsListScreen(
    this._nirikshakCore, {
    super.key,
  });

  @override
  State<NirikshakCallsListScreen> createState() =>
      _NirikshakCallsListScreenState();
}

class _NirikshakCallsListScreenState extends State<NirikshakCallsListScreen> {
  NirikshakCore get nirikshakCore => widget._nirikshakCore;
  bool _searchEnabled = false;
  TextEditingController? _queryTextEditingController = TextEditingController();
  final List<NirikshakMenuItem> _menuItems = [];

  _NirikshakCallsListScreenState() {
    _menuItems.add(const NirikshakMenuItem(
      NirikshakStrings.delete,
      Icons.delete,
    ));
    _menuItems.add(const NirikshakMenuItem(
      NirikshakStrings.stats,
      Icons.insert_chart,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _searchEnabled ? _buildSearchField() : _buildTitleWidget(),
        actions: nirikshakCore.httpCalls.isEmpty
            ? []
            : [
                _buildSearchButton(),
                _buildMenuButton(),
              ],
      ),
      body: _buildCallsListWrapper(),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _queryTextEditingController?.dispose();
    _queryTextEditingController = null;
  }

  Widget _buildSearchButton() {
    return IconButton(
      icon: const Icon(Icons.search),
      onPressed: _onSearchClicked,
    );
  }

  void _onSearchClicked() {
    setState(() {
      _searchEnabled = !_searchEnabled;
      if (!_searchEnabled) {
        _queryTextEditingController?.text = "";
        _queryTextEditingController?.clear();
      }
    });
  }

  Widget _buildMenuButton() {
    return PopupMenuButton<NirikshakMenuItem>(
      onSelected: (NirikshakMenuItem item) => _onMenuItemSelected(item),
      itemBuilder: (BuildContext context) {
        return _menuItems.map((NirikshakMenuItem item) {
          return PopupMenuItem<NirikshakMenuItem>(
            value: item,
            child: Row(children: [
              Icon(
                item.iconData,
              ),
              const Padding(
                padding: EdgeInsets.only(left: 10),
              ),
              Text(item.title)
            ]),
          );
        }).toList();
      },
    );
  }

  Widget _buildTitleWidget() {
    return const Text(NirikshakStrings.httpInspector);
  }

  Widget _buildSearchField() {
    return TextField(
      controller: _queryTextEditingController,
      autofocus: true,
      decoration: InputDecoration(
        hintText: NirikshakStrings.searchHttpRequest,
        hintStyle: const TextStyle(fontSize: 16.0, color: Colors.grey),
        border: InputBorder.none,
        suffixIcon: IconButton(
          onPressed: () {
            _queryTextEditingController?.clear();
            setState(() {});
          },
          icon: const Icon(Icons.clear),
        ),
      ),
      style: const TextStyle(fontSize: 16.0),
      onChanged: _updateSearchQuery,
    );
  }

  void _onMenuItemSelected(NirikshakMenuItem menuItem) {
    if (menuItem.title == NirikshakStrings.delete) {
      _showRemoveDialog();
    }
    if (menuItem.title == NirikshakStrings.stats) {
      _showStatsScreen();
    }
  }

  Widget _buildCallsListWrapper() {
    List<NirikshakHttpCall> calls = nirikshakCore.httpCalls;
    final String query = _queryTextEditingController?.text.trim() ?? '';
    if (query.isNotEmpty) {
      calls = calls.where(
        (call) {
          final containsServer =
              call.server.toLowerCase().contains(query.toLowerCase());
          final containsEndPoint =
              call.endpoint.toLowerCase().contains(query.toLowerCase());

          return containsServer || containsEndPoint;
        },
      ).toList();
    }
    if (calls.isNotEmpty) {
      return _NirikshakListWidget(core: nirikshakCore, calls: calls);
    } else {
      return const _NirikshakEmptyWidget();
    }
  }

  void _showRemoveDialog() {
    NirikshakAlertHelper.showAlert(
      context,
      NirikshakStrings.deleteCalls,
      NirikshakStrings.deleteCallsQues,
      firstButtonTitle: NirikshakStrings.no,
      firstButtonAction: () => {},
      secondButtonTitle: NirikshakStrings.yes,
      secondButtonAction: _removeCalls,
    );
  }

  void _removeCalls() {
    nirikshakCore.removeCalls();
    setState(() {});
  }

  void _showStatsScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NirikshakStatsScreen(
          widget._nirikshakCore,
        ),
      ),
    );
  }

  void _updateSearchQuery(String query) {
    setState(() {});
  }
}

class _NirikshakListWidget extends StatelessWidget {
  final NirikshakCore core;
  final List<NirikshakHttpCall> calls;

  const _NirikshakListWidget({
    required this.core,
    required this.calls,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      separatorBuilder: (_, i) => const Divider(
        color: Colors.grey,
      ),
      itemCount: calls.length,
      itemBuilder: (context, index) {
        return NirikshakCallListItemWidget(
          calls[index],
          _onListItemClicked,
        );
      },
    );
  }

  void _onListItemClicked(BuildContext context, NirikshakHttpCall call) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NirikshakCallDetailsScreen(
          call: call,
          core: core,
        ),
      ),
    );
  }
}

class _NirikshakEmptyWidget extends StatelessWidget {
  const _NirikshakEmptyWidget();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 32),
      child: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          const Icon(
            Icons.error_outline,
            color: Colors.orange,
          ),
          const SizedBox(height: 6),
          const Text(
            NirikshakStrings.noCallsToShow,
            style: TextStyle(fontSize: 18),
          ),
          const SizedBox(height: 12),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: const [
            Text(
              '• ${NirikshakStrings.checkHttpRequest}',
              style: TextStyle(fontSize: 12),
              textAlign: TextAlign.center,
            ),
            Text(
              '• ${NirikshakStrings.checkConfig}',
              style: TextStyle(fontSize: 12),
              textAlign: TextAlign.center,
            ),
            Text(
              '• ${NirikshakStrings.checkSearchFilter}',
              style: TextStyle(fontSize: 12),
              textAlign: TextAlign.center,
            )
          ])
        ]),
      ),
    );
  }
}
