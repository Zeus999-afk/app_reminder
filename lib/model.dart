//NRP: 992024006
// Nama: Masyitah Nanda Yassril
// Deskripsi kode: QUIZ
// Tanggal kode dibuat: 31 Oktober 2024a

class AppFunctionalityModel {
  final String id;
  final String title;
  final String description;
  final String tanggal_mulai;
  final String prioritas;
  final String alarm;

  AppFunctionalityModel(
      {required this.id,
      required this.title,
      required this.description,
      required this.tanggal_mulai,
      required this.prioritas,
      required this.alarm});

  factory AppFunctionalityModel.fromJson(Map data) {
    return AppFunctionalityModel(
        id: data['_id'],
        title: data['title'],
        description: data['description'],
        tanggal_mulai: data['tanggal_mulai'],
        prioritas: data['prioritas'],
        alarm: data['alarm']);
  }
}
