// To parse this JSON data, do
//
//     final studentModel = studentModelFromJson(jsonString);

import 'dart:convert';

StudentModel studentModelFromJson(String str) => StudentModel.fromJson(json.decode(str));

// Datum datumFromJson(String str) => Datum.fromJson(json.decode(str));

String studentModelToJson(StudentModel data) => json.encode(data.toJson());

class StudentModel {
    int currentPage;
    List<Datum> data;
    String firstPageUrl;
    int from;
    int lastPage;
    String lastPageUrl;
    List<Link> links;
    String? nextPageUrl;
    String path;
    int perPage;
    String? prevPageUrl;
    int to;
    int total;

    StudentModel({
        required this.currentPage,
        required this.data,
        required this.firstPageUrl,
        required this.from,
        required this.lastPage,
        required this.lastPageUrl,
        required this.links,
        this.nextPageUrl,
        required this.path,
        required this.perPage,
        this.prevPageUrl,
        required this.to,
        required this.total,
    });

    factory StudentModel.fromJson(Map<String, dynamic> json) => StudentModel(
        currentPage: json["current_page"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
        firstPageUrl: json["first_page_url"],
        from: json["from"],
        lastPage: json["last_page"],
        lastPageUrl: json["last_page_url"],
        links: List<Link>.from(json["links"].map((x) => Link.fromJson(x))),
        nextPageUrl: json["next_page_url"].toString(),
        path: json["path"],
        perPage: json["per_page"],
        prevPageUrl: json["prev_page_url"].toString(),
        to: json["to"],
        total: json["total"],
    );

    Map<String, dynamic> toJson() => {
        "current_page": currentPage,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "first_page_url": firstPageUrl,
        "from": from,
        "last_page": lastPage,
        "last_page_url": lastPageUrl,
        "links": List<dynamic>.from(links.map((x) => x.toJson())),
        "next_page_url": nextPageUrl,
        "path": path,
        "per_page": perPage,
        "prev_page_url": prevPageUrl,
        "to": to,
        "total": total,
    };
}

class Datum {
  int id;
  String khmer_name;
  String latin_name;
  String gender;
  String dob;
  String tel;
  String address;
  String createdAt;
  String updatedAt;

  Datum({
    required this.id,
    required this.khmer_name,
    required this.latin_name,
    required this.gender,
    required this.dob,
    required this.tel,
    required this.address,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        khmer_name: json["khmer_name"] ?? "",
        latin_name: json["latin_name"] ?? "",
        gender: json["gender"] ?? "",
        dob: json["dob"] ?? "",
        tel: json["tel"] ?? "",
        address: json["address"] ?? "",
        createdAt: json["created_at"] ?? "",
        updatedAt: json["updated_at"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "khmer_name": khmer_name,
        "latin_name": latin_name,
        "gender": gender,
        "dob": dob,
        "tel": tel,
        "address": address,
        "created_at": createdAt,
        "updated_at": updatedAt,
      };
}


class Link {
    String? url;
    String label;
    bool active;

    Link({
        this.url,
        required this.label,
        required this.active,
    });

    factory Link.fromJson(Map<String, dynamic> json) => Link(
        url: json["url"].toString(),
        label: json["label"],
        active: json["active"],
    );

    Map<String, dynamic> toJson() => {
        "url": url,
        "label": label,
        "active": active,
    };
}
