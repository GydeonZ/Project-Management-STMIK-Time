class ModelNavBar {
  String image;
  String title;

  ModelNavBar({required this.image, required this.title});
}

List<ModelNavBar> contents = [
  ModelNavBar (
    title: 'Dasboard',
    image: 'assets/dashboard.svg',
  ),
  ModelNavBar (
    title: 'Tugas',
    image: 'assets/tugas.svg',
  ),
  ModelNavBar (
    title: 'Tambah',
    image: 'assets/tambahtugas.svg',
  ),
  ModelNavBar (
    title: 'Laporan',
    image: 'assets/notifikasi.svg',
  ),
  ModelNavBar (
    title: 'Profil',
    image: 'assets/akun.svg',
  ),
];