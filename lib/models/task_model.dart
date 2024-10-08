class TaskModel {
  int? id;
  String title;
  String description;
  bool isComplete;

  TaskModel(
      {this.id,
      required this.title,
      required this.description,
      required this.isComplete});

  factory TaskModel.fromJson(Map<String, dynamic> json) => TaskModel(
      id: json["id"],
      title: json["title"],
      description: json["description"],
      isComplete: json["is_complete"] == 1);

  Map<String, dynamic> toJson() => {
        "title": title,
        "description": description,
        "is_complete": isComplete ? 1 : 0,
      };
}
