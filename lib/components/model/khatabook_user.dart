// ignore_for_file: non_constant_identifier_names

import 'dart:typed_data';

class KhatabookUserClass {
  // Class fields
  final int? id; // Unique identifier
  final String name;
  final String village;
  final String phone_number; // Follow Dart naming conventions
  final String? address; // Make address optional
  final Uint8List? photo; // Optional photo as Uint8List

  // Constructor
  KhatabookUserClass({
    this.id,
    required this.name,
    required this.village,
    required this.phone_number,
    this.address,
    this.photo,
  });

  // Getters
  int? get getId => id;
  String get getName => name;
  String get getVillage => village;
  String get getPhoneNumber => phone_number;
  String? get getAddress => address;
  Uint8List? get getPhoto => photo;

  // Override toString
  @override
  String toString() {
    return 'KhatabookUserClass(id: $id, name: $name, village: $village, phoneNumber: $phone_number, address: $address)';
  }

  // Override == operator and hashCode
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is KhatabookUserClass &&
        other.id == id &&
        other.name == name &&
        other.village == village &&
        other.phone_number == phone_number &&
        other.address == address;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        village.hashCode ^
        phone_number.hashCode ^
        (address?.hashCode ?? 0); // Handle nullable address
  }

  // Copy with method for creating modified copies of the instance
  KhatabookUserClass copyWith({
    int? id,
    String? name,
    String? village,
    String? phoneNumber,
    String? address,
    Uint8List? photo,
  }) {
    return KhatabookUserClass(
      id: id ?? this.id,
      name: name ?? this.name,
      village: village ?? this.village,
      phone_number: phoneNumber ?? phone_number,
      address: address ?? this.address,
      photo: photo ?? this.photo,
    );
  }
}
