// ignore_for_file: public_member_api_docs, sort_constructors_first
class CustomSimpleNode {
  final String id;
  final String name;
  final dynamic data;
  CustomSimpleNode({
    required this.id,
    required this.name,
    required this.data,
  });

  CustomSimpleNode copyWith({
    String? id,
    String? name,
    dynamic data,
  }) {
    return CustomSimpleNode(
      id: id ?? this.id,
      name: name ?? this.name,
      data: data ?? this.data,
    );
  }
}

class Node {
  final String? nodeName;
  final int? nodeId;
  final int? accountId;
  final String? accountName;
  final List<Node> accounts;

  Node({
    this.nodeName,
    this.nodeId,
    this.accountId,
    this.accountName,
    this.accounts = const [],
  });

  factory Node.fromJson(Map<String, dynamic> json) {
    return Node(
      nodeName: json['node_name'],
      nodeId: json['node_id'],
      accountId: json['account_id'],
      accountName: json['account_name'],
    );
  }
}
