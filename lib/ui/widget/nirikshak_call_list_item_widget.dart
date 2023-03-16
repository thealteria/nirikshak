import 'package:flutter/material.dart';

import '../../model/nirikshak_http_call.dart';
import '../../utils/nirikshak_extension.dart';

class NirikshakCallListItemWidget extends StatelessWidget {
  final NirikshakHttpCall call;
  final Function itemClickAction;

  const NirikshakCallListItemWidget(
    this.call,
    this.itemClickAction, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => itemClickAction(context, call),
      child: Container(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildMethodAndEndpointRow(),
            const SizedBox(height: 4),
            _buildServerRow(),
            const SizedBox(height: 5),
            _buildStatsRow(),
          ],
        ),
      ),
    );
  }

  Widget _buildMethodAndEndpointRow() {
    final textColor = call.response?.status.getStatusTextColor();
    return Row(
      children: [
        Text(
          call.method,
          style: TextStyle(fontSize: 16, color: textColor),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            call.endpoint,
            overflow: TextOverflow.visible,
            style: TextStyle(
              fontSize: 16,
              color: textColor,
            ),
          ),
        ),
        const SizedBox(width: 10),
        _buildStatusCodeMessage(),
      ],
    );
  }

  Widget _buildServerRow() {
    return Row(
      children: [
        _getSecuredConnectionIcon(call.secure),
        Expanded(
          child: Text(
            call.server,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            style: const TextStyle(
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatsRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          flex: 2,
          child: Text(
            call.request?.time.toStringDateTime() ?? '',
            style: const TextStyle(fontSize: 12),
          ),
        ),
        Flexible(
          flex: 1,
          child: Text(
            call.duration.formatTime(),
            style: const TextStyle(fontSize: 12),
          ),
        ),
        Flexible(
          flex: 1,
          child: Text(
            "${(call.request?.size ?? 0).formatBytes()} / "
            "${(call.response?.size ?? 0).formatBytes()}",
            style: const TextStyle(fontSize: 12),
          ),
        )
      ],
    );
  }

  Widget _buildStatusCodeMessage() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 5,
      ),
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        color: call.response?.status.getStatusTextColor(),
        borderRadius: BorderRadius.circular(7),
      ),
      child: Text(
        call.response?.statusCodeMessage ?? 'N/A',
        style: const TextStyle(
          fontSize: 14,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _getSecuredConnectionIcon(bool secure) {
    IconData iconData;
    Color iconColor;
    if (secure) {
      iconData = Icons.lock_outline;
      iconColor = Colors.green;
    } else {
      iconData = Icons.lock_open;
      iconColor = Colors.red;
    }
    return Padding(
      padding: const EdgeInsets.only(right: 3),
      child: Icon(
        iconData,
        color: iconColor,
        size: 12,
      ),
    );
  }
}
