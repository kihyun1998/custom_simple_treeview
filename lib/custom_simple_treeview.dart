// ignore_for_file: public_member_api_docs, sort_constructors_first
library custom_simple_treeview;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'custom_simple_node_model.dart';

class CustomSimpleTreeView extends StatefulWidget {
  final List<Node> nodes;
  final List<ExpansionTileController> controllers;

  const CustomSimpleTreeView({
    super.key,
    required this.nodes,
    required this.controllers,
  });

  @override
  State<CustomSimpleTreeView> createState() => _CustomSimpleTreeViewState();
}

class _CustomSimpleTreeViewState extends State<CustomSimpleTreeView> {
  Set<int> selectedFiles = <int>{}; // 선택된 파일의 ID를 저장

  @override
  void initState() {
    super.initState();
  }

  void toggleSelection(Node account) {
    setState(() {
      if (selectedFiles.contains(account.accountId)) {
        selectedFiles.remove(account.accountId);
      } else {
        selectedFiles.add(account.accountId!);
      }
    });
  }

  void clearSelectionsForNode(Node node) {
    setState(() {
      for (var account in node.accounts) {
        selectedFiles.remove(account.accountId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: widget.nodes.length,
            itemBuilder: (context, index) {
              return buildNode(widget.nodes[index], widget.controllers[index]);
            },
          ),
        ),
      ],
    );
  }

  Widget buildNode(Node node, ExpansionTileController controller,
      {double padding = 0.0}) {
    return Padding(
      padding: EdgeInsets.only(left: padding),
      child: Theme(
        data: ThemeData(
          dividerColor: Colors.transparent, // ExpansionTile 밑줄 제거
        ),
        child: ExpansionTile(
          controlAffinity: ListTileControlAffinity.leading,
          title: Row(
            children: [
              const Padding(
                  padding: EdgeInsets.only(right: 15),
                  child: Icon(Icons.folder, color: Colors.black)),
              Text(node.nodeName ?? '',
                  style: const TextStyle(color: Colors.black)),
            ],
          ),
          onExpansionChanged: (isExpanded) {
            if (!isExpanded) {
              clearSelectionsForNode(node);
            }
          },
          controller: controller,
          children: node.accounts
              .map((account) => buildAccount(account, padding: padding + 60.0))
              .toList(),
        ),
      ),
    );
  }

  Widget buildAccount(Node account, {double padding = 0.0}) {
    return Padding(
      padding: EdgeInsets.only(left: padding),
      child: GestureDetector(
        onSecondaryTapDown: (details) {
          setState(() {
            if (!selectedFiles.contains(account.accountId)) {
              selectedFiles.clear();
              selectedFiles.add(account.accountId!);
            }
          });
          showContextMenu(context, details.globalPosition);
        },
        onTap: () {
          if (HardwareKeyboard.instance
                  .isLogicalKeyPressed(LogicalKeyboardKey.controlLeft) ||
              HardwareKeyboard.instance
                  .isLogicalKeyPressed(LogicalKeyboardKey.controlRight)) {
            toggleSelection(account);
          } else {
            setState(() {
              if (selectedFiles.contains(account.accountId)) {
                selectedFiles.remove(account.accountId);
              } else {
                selectedFiles.clear();
                selectedFiles.add(account.accountId!);
              }
            });
          }
        },
        child: Container(
          color: selectedFiles.contains(account.accountId)
              ? Colors.blue.withOpacity(0.3)
              : Colors.transparent,
          child: ListTile(
            leading: const Icon(Icons.insert_drive_file, color: Colors.black),
            title: Text(account.accountName ?? '',
                style: const TextStyle(color: Colors.black)),
          ),
        ),
      ),
    );
  }

  void showContextMenu(BuildContext context, Offset position) {
    final RenderBox overlay =
        Overlay.of(context).context.findRenderObject() as RenderBox;

    showMenu(
      context: context,
      position: RelativeRect.fromRect(
          position & const Size(40, 40), Offset.zero & overlay.size),
      items: [
        PopupMenuItem(
          child: const Text('Print'),
          onTap: () {
            printSelectedAccounts();
          },
        ),
      ],
    );
  }

  void printSelectedAccounts() {
    for (var accountId in selectedFiles) {
      Node? account = findAccountById(accountId);
      if (account != null) {
        print('Account ID: ${account.accountId}');
        print('Account Name: ${account.accountName}');
      }
    }
  }

  Node? findAccountById(int accountId) {
    for (var node in widget.nodes) {
      for (var account in node.accounts) {
        if (account.accountId == accountId) {
          return account;
        }
      }
    }
    return null;
  }
}
