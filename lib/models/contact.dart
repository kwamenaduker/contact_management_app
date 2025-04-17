class Contact {
  final String? pid;
  final String pname;
  final String pphone;

  Contact({
    this.pid,
    required this.pname,
    required this.pphone,
  });

  factory Contact.fromJson(Map<String, dynamic> json) {
    return Contact(
      pid: json['pid']?.toString(),
      pname: json['pname'] as String,
      pphone: json['pphone'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'pid': pid,
      'pname': pname,
      'pphone': pphone,
    };
  }

  Contact copyWith({
    String? pid,
    String? pname,
    String? pphone,
  }) {
    return Contact(
      pid: pid ?? this.pid,
      pname: pname ?? this.pname,
      pphone: pphone ?? this.pphone,
    );
  }
}