class CompanyData {
  String name;
  String email;
  String rut;
  String address;
  String phone;
  String score;

  CompanyData({
    required this.name,
    required this.email,
    required this.rut,
    required this.address,
    required this.phone,
    required this.score,
  });

  static CompanyData empty() {
    return CompanyData(
      name: '',
      email: '',
      rut: '',
      address: '',
      phone: '',
      score: '',
    );
  }
}
