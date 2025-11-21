class RatingModel {
  final String id;
  final String orderId;
  final String reviewerId;
  final String reviewerName;
  final String revieweeId;
  final String revieweeType; // 'seller' or 'rider'
  final int rating;
  final String? comment;
  final DateTime createdAt;

  RatingModel({
    required this.id,
    required this.orderId,
    required this.reviewerId,
    required this.reviewerName,
    required this.revieweeId,
    required this.revieweeType,
    required this.rating,
    this.comment,
    required this.createdAt,
  });

  factory RatingModel.fromJson(Map<String, dynamic> json) {
    return RatingModel(
      id: json['_id'] ?? json['id'] ?? '',
      orderId: json['orderId'] ?? '',
      reviewerId: json['reviewerId'] ?? '',
      reviewerName: json['reviewerName'] ?? '',
      revieweeId: json['revieweeId'] ?? '',
      revieweeType: json['revieweeType'] ?? '',
      rating: json['rating'] ?? 0,
      comment: json['comment'],
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'orderId': orderId,
      'reviewerId': reviewerId,
      'reviewerName': reviewerName,
      'revieweeId': revieweeId,
      'revieweeType': revieweeType,
      'rating': rating,
      'comment': comment,
    };
  }
}

class DisputeModel {
  final String id;
  final String orderId;
  final String reporterId;
  final String reporterName;
  final String disputeType; // 'delayed', 'failed', 'damaged', 'other'
  final String description;
  final String status; // 'pending', 'resolved', 'rejected'
  final DateTime createdAt;
  final DateTime? resolvedAt;

  DisputeModel({
    required this.id,
    required this.orderId,
    required this.reporterId,
    required this.reporterName,
    required this.disputeType,
    required this.description,
    required this.status,
    required this.createdAt,
    this.resolvedAt,
  });

  factory DisputeModel.fromJson(Map<String, dynamic> json) {
    return DisputeModel(
      id: json['_id'] ?? json['id'] ?? '',
      orderId: json['orderId'] ?? '',
      reporterId: json['reporterId'] ?? '',
      reporterName: json['reporterName'] ?? '',
      disputeType: json['disputeType'] ?? '',
      description: json['description'] ?? '',
      status: json['status'] ?? 'pending',
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      resolvedAt: json['resolvedAt'] != null
          ? DateTime.parse(json['resolvedAt'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'orderId': orderId,
      'reporterId': reporterId,
      'reporterName': reporterName,
      'disputeType': disputeType,
      'description': description,
      'status': status,
    };
  }
}
