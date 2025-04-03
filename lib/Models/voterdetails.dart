// To parse this JSON data, do
//
//     final votersDetails = votersDetailsFromJson(jsonString);

import 'dart:convert';

VotersDetails votersDetailsFromJson(String str) => VotersDetails.fromJson(json.decode(str));

String votersDetailsToJson(VotersDetails data) => json.encode(data.toJson());

class VotersDetails {
  int status;
  String message;
  Voter voter;

  VotersDetails({
    required this.status,
    required this.message,
    required this.voter,
  });

  factory VotersDetails.fromJson(Map<String, dynamic> json) => VotersDetails(
    status: json["status"],
    message: json["message"],
    voter: Voter.fromJson(json["voter"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "voter": voter.toJson(),
  };
}

class Voter {
  int id;
  String firstName;
  String middleName;
  String surname;
  String email;
  String gender;
  int age;
  DateTime dob;
  String cast;
  String position;
  String demands;
  String voterId;
  int dead;
  int voted;
  int starVoter;
  String colourCode;
  String mobile1;
  String mobile2;
  String image;
  VoterAddress voterAddress;
  VoterInformation voterInformation;

  Voter({
    required this.id,
    required this.firstName,
    required this.middleName,
    required this.surname,
    required this.email,
    required this.gender,
    required this.age,
    required this.dob,
    required this.cast,
    required this.position,
    required this.demands,
    required this.voterId,
    required this.dead,
    required this.voted,
    required this.starVoter,
    required this.colourCode,
    required this.mobile1,
    required this.mobile2,
    required this.image,
    required this.voterAddress,
    required this.voterInformation,
  });

  factory Voter.fromJson(Map<String, dynamic> json) => Voter(
    id: json["id"],
    firstName: json["first_name"],
    middleName: json["middle_name"],
    surname: json["surname"],
    email: json["email"],
    gender: json["gender"],
    age: json["age"],
    dob: DateTime.parse(json["dob"]),
    cast: json["cast"],
    position: json["position"],
    demands: json["demands"],
    voterId: json["voter_id"],
    dead: json["dead"],
    voted: json["voted"],
    starVoter: json["star_voter"],
    colourCode: json["colour_code"],
    mobile1: json["mobile_1"],
    mobile2: json["mobile_2"],
    image: json["image"],
    voterAddress: VoterAddress.fromJson(json["voterAddress"]),
    voterInformation: VoterInformation.fromJson(json["voter_information"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "first_name": firstName,
    "middle_name": middleName,
    "surname": surname,
    "email": email,
    "gender": gender,
    "age": age,
    "dob": "${dob.year.toString().padLeft(4, '0')}-${dob.month.toString().padLeft(2, '0')}-${dob.day.toString().padLeft(2, '0')}",
    "cast": cast,
    "position": position,
    "demands": demands,
    "voter_id": voterId,
    "dead": dead,
    "voted": voted,
    "star_voter": starVoter,
    "colour_code": colourCode,
    "mobile_1": mobile1,
    "mobile_2": mobile2,
    "image": image,
    "voterAddress": voterAddress.toJson(),
    "voter_information": voterInformation.toJson(),
  };
}

class VoterAddress {
  String address;
  String society;
  String houseNo;
  String flatNo;
  String booth;
  String village;
  String partNo;
  String srn;
  String votingCentre;

  VoterAddress({
    required this.address,
    required this.society,
    required this.houseNo,
    required this.flatNo,
    required this.booth,
    required this.village,
    required this.partNo,
    required this.srn,
    required this.votingCentre,
  });

  factory VoterAddress.fromJson(Map<String, dynamic> json) => VoterAddress(
    address: json["address"],
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
    "address": address,
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

class VoterInformation {
  String extraInfo1;
  String extraInfo2;
  String extraInfo3;
  String extraInfo4;
  String extraInfo5;
  int extraCheck1;
  int extraCheck2;

  VoterInformation({
    required this.extraInfo1,
    required this.extraInfo2,
    required this.extraInfo3,
    required this.extraInfo4,
    required this.extraInfo5,
    required this.extraCheck1,
    required this.extraCheck2,
  });

  factory VoterInformation.fromJson(Map<String, dynamic> json) => VoterInformation(
    extraInfo1: json["extra_info_1"],
    extraInfo2: json["extra_info_2"],
    extraInfo3: json["extra_info_3"],
    extraInfo4: json["extra_info_4"],
    extraInfo5: json["extra_info_5"],
    extraCheck1: json["extra_check_1"],
    extraCheck2: json["extra_check_2"],
  );

  Map<String, dynamic> toJson() => {
    "extra_info_1": extraInfo1,
    "extra_info_2": extraInfo2,
    "extra_info_3": extraInfo3,
    "extra_info_4": extraInfo4,
    "extra_info_5": extraInfo5,
    "extra_check_1": extraCheck1,
    "extra_check_2": extraCheck2,
  };
}
