class Settings {
  String street;
  String city;
  String state;
  String zipCode;
  String phoneNumber;
  int id;

  Settings(this.street, this.city, this.state, this.zipCode, this.phoneNumber, {this.id});

  factory Settings.fromJson(Map<String, dynamic> map) => new Settings(
    map['street'],
    map['city'],
    map['state'],
    map['zip_code'],
    map['phone_number'],
    id: map['id'],
  );

  Map<String, dynamic> toJson() => {
    'street': street,
    'city': city,
    'state': state,
    'zip_code': zipCode,
    'phone_number': phoneNumber
  };
}