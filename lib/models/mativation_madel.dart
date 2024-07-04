class MativationMadel {
  late String q;
  late String a;
  late String h;

  MativationMadel({
    required this.q,
    required this.a,
    required this.h,
  });

  factory MativationMadel.fromJson(Map<String, dynamic> json) {
    return MativationMadel(
      q: json["q"] ?? "",
      a: json["a"] ?? "",
      h: json["h"] ?? "",
    );
  }
}
