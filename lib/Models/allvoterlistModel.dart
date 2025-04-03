// To parse this JSON data, do
//
//     final allVotersList = allVotersListFromJson(jsonString);

import 'dart:convert';

AllVotersList allVotersListFromJson(String str) => AllVotersList.fromJson(json.decode(str));

String allVotersListToJson(AllVotersList data) => json.encode(data.toJson());

class AllVotersList {
  int? status;
  String? message;
  List<Voter>? voters;

  AllVotersList({
    this.status,
    this.message,
    this.voters,
  });

  factory AllVotersList.fromJson(Map<String, dynamic> json) => AllVotersList(
    status: json["status"],
    message: json["message"],
    voters: json["voters"] == null ? [] : List<Voter>.from(json["voters"]!.map((x) => Voter.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "voters": voters == null ? [] : List<dynamic>.from(voters!.map((x) => x.toJson())),
  };
}

class Voter {
  int? id;
  String? firstName;
  String? middleName;
  String? surname;
  String? email;
  String? gender;
  int? age;
  DateTime? dob;
  String? cast;
  String? position;
  String? voterId;
  int? dead;
  int? voted;
  int? starVoter;
  String? colourCode;
  String? mobile1;
  String? mobile2;
  String? image;
  VoterAddress? voterAddress;

  Voter({
    this.id,
    this.firstName,
    this.middleName,
    this.surname,
    this.email,
    this.gender,
    this.age,
    this.dob,
    this.cast,
    this.position,
    this.voterId,
    this.dead,
    this.voted,
    this.starVoter,
    this.colourCode,
    this.mobile1,
    this.mobile2,
    this.image,
    this.voterAddress,
  });

  factory Voter.fromJson(Map<String, dynamic> json) => Voter(
    id: json["id"],
    firstName: json["first_name"],
    middleName: json["middle_name"],
    surname: json["surname"],
    email: json["email"],
    gender: json["gender"],
    age: json["age"],
    dob: json["dob"] == null ? null : DateTime.parse(json["dob"]),
    cast: json["cast"],
    position: json["position"],
    voterId: json["voter_id"],
    dead: json["dead"],
    voted: json["voted"],
    starVoter: json["star_voter"],
    colourCode: json["colour_code"],
    mobile1: json["mobile_1"],
    mobile2: json["mobile_2"],
    image: json["image"],
    voterAddress: json["voter_address"] == null ? null : VoterAddress.fromJson(json["voter_address"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "first_name": firstName,
    "middle_name": middleName,
    "surname": surname,
    "email": email,
    "gender": gender,
    "age": age,
    "dob": "${dob!.year.toString().padLeft(4, '0')}-${dob!.month.toString().padLeft(2, '0')}-${dob!.day.toString().padLeft(2, '0')}",
    "cast": cast,
    "position": position,
    "voter_id": voterId,
    "dead": dead,
    "voted": voted,
    "star_voter": starVoter,
    "colour_code": colourCode,
    "mobile_1": mobile1,
    "mobile_2": mobile2,
    "image": image,
    "voter_address": voterAddress?.toJson(),
  };
}

class VoterAddress {
  String? society;
  String? houseNo;
  String? flatNo;
  String? booth;
  String? village;
  String? partNo;
  String? srn;
  String? votingCentre;

  VoterAddress({
    this.society,
    this.houseNo,
    this.flatNo,
    this.booth,
    this.village,
    this.partNo,
    this.srn,
    this.votingCentre,
  });

  factory VoterAddress.fromJson(Map<String, dynamic> json) => VoterAddress(
    society: json["society"],
    houseNo: json["house_no"],
    flatNo: json["flat_no"],
    booth: json["booth"],
    village: json["village"],
    partNo: json["part_no"],
    srn: json["srn"],
    votingCentre: json["voting_centre"],
  );

  Map<String, dynamic> toJson() => {
    "society": society,
    "house_no": houseNo,
    "flat_no": flatNo,
    "booth": booth,
    "village": village,
    "part_no": partNo,
    "srn": srn,
    "voting_centre": votingCentre,
  };
}
