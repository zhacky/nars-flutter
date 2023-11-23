class Address {
  final String? homeNo, street;
  final String barangay, town, province;
  final bool isDefault;
  late String fullAddress = barangay + ', ' + town;
  final double? lat;
  final double? lng;

  Address({
    this.homeNo,
    this.street,
    required this.barangay,
    required this.town,
    required this.province,
    required this.isDefault,
    this.lat,
    this.lng,
  });
}

List<Address> addresses = [
  Address(
    homeNo: '#364',
    street: 'Raniag st.',
    barangay: 'Antonino',
    town: 'Alicia',
    province: 'Isabela',
    isDefault: false,
  ),
  Address(
    homeNo: '2nd flr, Kiat bldg',
    street: 'Eufracio Gaffud',
    barangay: 'Sillauan Sur',
    town: 'Echague',
    province: 'Isabela',
    isDefault: false,
  ),
  Address(
    homeNo: 'De Silverman',
    street: 'Infront Pet Avenue',
    barangay: 'Andres Bonifacio',
    town: 'Diffun',
    province: 'Quirino',
    isDefault: true,
  ),
  Address(
    homeNo: '',
    street: 'Burgos st.',
    barangay: 'District II',
    town: 'Cauayan City',
    province: 'Isabela',
    isDefault: true,
    lat: 16.936132,
    lng: 121.770432,
  ),
];
