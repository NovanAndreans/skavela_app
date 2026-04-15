class AppConfig {
  final String examTitle;
  final String schoolName;
  final String year;
  final String examLink;
  final String deskTitle;

  AppConfig({
    required this.examTitle,
    required this.schoolName,
    required this.year,
    required this.examLink,
    required this.deskTitle,
  });

  Map<String, dynamic> toMap() {
    return {
      "examTitle": examTitle,
      "schoolName": schoolName,
      "year": year,
      "examLink": examLink,
      "deskTitle": deskTitle,
    };
  }

  factory AppConfig.fromMap(Map<String, dynamic> map) {
    return AppConfig(
      examTitle: map["examTitle"],
      schoolName: map["schoolName"],
      year: map["year"],
      examLink: map["examLink"],
      deskTitle: map["deskTitle"],
    );
  }
}