class ModelNavBar {
  String image;
  String title;

  ModelNavBar({required this.image, required this.title});
}

List<ModelNavBar> contents = [
  ModelNavBar(
    title: 'Board',
    image: 'assets/dashboard.svg',
  ),
  ModelNavBar(
    title: 'Notifikasi',
    image: 'assets/notifikasi.svg',
  ),
  ModelNavBar(
    title: 'Profil',
    image: 'assets/akun.svg',
  ),
];
