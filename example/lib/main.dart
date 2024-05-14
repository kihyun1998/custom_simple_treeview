import 'dart:convert';

import 'package:custom_simple_treeview/custom_simple_node_model.dart';
import 'package:custom_simple_treeview/custom_simple_treeview.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Custom Simple TreeView Example',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Node> nodes = [];
  List<ExpansionTileController> controllers = [];

  @override
  void initState() {
    super.initState();
    // JSON 데이터 예제
    String jsonString = '''
    [
      {
        "node_name": "node a",
        "node_id": 1,
        "account_id": 1,
        "account_name": "account a"
      },
      {
        "node_name": "node a",
        "node_id": 1,
        "account_id": 2,
        "account_name": "account b"
      },
      {
        "node_name": "node b",
        "node_id": 2,
        "account_id": 3,
        "account_name": "account c"
      }
    ]
    ''';

    // JSON 파싱
    List<dynamic> jsonData = jsonDecode(jsonString);
    List<Node> parsedNodes =
        jsonData.map((data) => Node.fromJson(data)).toList();

    // 트리 구조 생성
    setState(() {
      nodes = buildTree(parsedNodes);
      controllers =
          List.generate(nodes.length, (index) => ExpansionTileController());
    });
  }

  List<Node> buildTree(List<Node> nodes) {
    Map<int, Node> nodeMap = {};
    for (var node in nodes) {
      if (!nodeMap.containsKey(node.nodeId)) {
        nodeMap[node.nodeId!] = Node(
          nodeName: node.nodeName,
          nodeId: node.nodeId,
          accounts: [],
        );
      }
      nodeMap[node.nodeId]!.accounts.add(Node(
            accountId: node.accountId,
            accountName: node.accountName,
          ));
    }
    return nodeMap.values.toList();
  }

  void toggleAll() {
    bool anyExpanded = controllers.any((controller) => controller.isExpanded);
    if (anyExpanded) {
      for (var controller in controllers) {
        controller.collapse();
      }
    } else {
      for (var controller in controllers) {
        controller.expand();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Custom Simple TreeView"),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: toggleAll,
          ),
        ],
      ),
      body: CustomSimpleTreeView(nodes: nodes, controllers: controllers),
    );
  }
}
