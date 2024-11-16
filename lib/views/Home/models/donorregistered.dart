class DonorRegisterData {
  String name;
  String agecategory;
  String gender;
  String bloodtype;
  String address;
  String phonenumber;
  String email;
  String date;
  String month;
  String year;
  String status;

  DonorRegisterData(
      {required this.name,
      required this.agecategory,
      required this.gender,
      required this.bloodtype,
      required this.address,
      required this.phonenumber,
      required this.email,
      required this.date,
      required this.month,
      required this.year,
      required this.status
      });

  factory DonorRegisterData.fromJson(Map<String, dynamic> json) {
    return DonorRegisterData(
        name: json['name'],
        agecategory: json['agecategory'],
        gender: json['gender'],
        bloodtype: json['bloodtype'].toString(),
        address: json['address'],
        phonenumber: json['phonenumber'].toString(),
        email: json['email'].toString(),
        status: json['status'].toString(),
        date: json['patientId'].toString(),
        month: json['month'].toString(),
        year: json['year'].toString());
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'agecategory': agecategory,
        'gender': gender,
        'bloodtype': bloodtype,
        'address': address,
        'phonenumber': phonenumber,
        'email': email,
        'status': status,
        'date': date,
        'month': month,
        'year': year,
      };
}