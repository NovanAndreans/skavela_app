class StudentModel {
  final String name;
  final String username;
  final String password;
  final String jurusan;
  final String waktu1;
  final String waktu2;
  final String kelas;
  final String noUrut;
  final String ruang;

  StudentModel({
    required this.name,
    required this.username,
    required this.password,
    required this.jurusan,
    required this.waktu1,
    required this.waktu2,
    required this.kelas,
    required this.noUrut,
    required this.ruang,
  });

  Map<String, dynamic> toMap() {
    return {
      "name": name,
      "username": username,
      "password": password,
      "jurusan": jurusan,
      "kelas": kelas,
      "noUrut": noUrut,
      "ruang": ruang,
      "waktu1": waktu1,
      "waktu2": waktu2,
    };
  }

  factory StudentModel.fromMap(Map<String, dynamic> map) {
    return StudentModel(
      name: map["name"],
      username: map["username"],
      password: map["password"],
      jurusan: map["jurusan"],
      kelas: map["kelas"],
      noUrut: map["noUrut"],
      ruang: map["ruang"],
      waktu1: map["waktu1"],
      waktu2: map["waktu2"],
    );
  }
}