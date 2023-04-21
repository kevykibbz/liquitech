// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import "package:get/get.dart";
import 'package:flutter/material.dart';

class CountyData {
  final String countyName;
  final int countyNumber;
  final List indexKey;
  final int stations;
  CountyData(
      {required this.countyName,
      required this.countyNumber,
      required this.stations,
      required this.indexKey});

  toJson() {
    return {
      "CountyName": countyName,
      "CountyNumber": countyNumber,
      "Stations": stations,
      "indexKey": indexKey,
    };
  }
}

addCounties({required String collectionName}) async {
  for (var element in allCounties) {
    await FirebaseFirestore.instance
        .collection(collectionName)
        .add(element.toJson());
  }
  Get.back(closeOverlays: true);
  Get.snackbar("Success", "All counties added successfully.",
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green.withOpacity(0.1),
      colorText: Colors.green);
}

List<String> addSearchKeys({required String searchName}) {
  List<String> indexList = [];
  List<String> splitText = searchName.split(" ");
  for (int i = 0; i < splitText.length; i++) {
    for (int j = 0; j < splitText[i].length + 1; j++) {
      indexList.add(splitText[i].substring(0, j).toLowerCase());
    }
  }
  return indexList;
}

List<CountyData> allCounties = [
  CountyData(
      countyName: 'Mombasa',
      countyNumber: 1,
      stations: 0,
      indexKey: ["", "m", "mo", "mom", "momb", "momba", "mombas", "mombasa"]),
  CountyData(countyName: 'Kwale', countyNumber: 2, stations: 0, indexKey: [
    "",
    "k",
    "kw",
    "kwa",
    "kwal",
    "kwale",
  ]),
  CountyData(
      countyName: 'Kilifi',
      countyNumber: 3,
      stations: 0,
      indexKey: ["", "k", "ki", "kil", "kili", "kilif", "kilifi"]),
  CountyData(countyName: 'Tana river', countyNumber: 4, stations: 0, indexKey: [
    "",
    "t",
    "ta",
    "tan",
    "tana",
    " ",
    "r",
    "ri",
    "riv",
    "rive",
    "river"
  ]),
  CountyData(
      countyName: 'Lamu',
      countyNumber: 5,
      stations: 0,
      indexKey: ["", "l", "la", "lam", "lamu"]),
  CountyData(
      countyName: 'Taita/Taveta',
      countyNumber: 6,
      stations: 0,
      indexKey: [
        "",
        "t",
        "ta",
        "tai",
        "tait",
        "taita",
        "taita/",
        "taita/t",
        "taita/ta",
        "taita/tav",
        "taita/tave",
        "taita/tavet",
        "taita/taveta"
      ]),
  CountyData(countyName: 'Garissa', countyNumber: 7, stations: 0, indexKey: [
    "",
    "g",
    "ga",
    "gar",
    "garr",
    "garri",
    "garris",
    "garrisa",
  ]),
  CountyData(countyName: 'Wajir', countyNumber: 8, stations: 0, indexKey: [
    "",
    "w",
    "wa",
    "waj",
    "waji",
    "wajir",
  ]),
  CountyData(
      countyName: 'Mandera',
      countyNumber: 9,
      stations: 0,
      indexKey: ["", "m", "ma", "man", "mand", "mande", "mander", "mandera"]),
  CountyData(countyName: 'Marsabit', countyNumber: 10, stations: 0, indexKey: [
    "",
    "m",
    "ma",
    "mar",
    "mars",
    "marsa",
    "marsab",
    "marsabi",
    "marsabit"
  ]),
  CountyData(
      countyName: 'Isiolo',
      countyNumber: 11,
      stations: 0,
      indexKey: ["", "i", "is", "isi", "isio", "isiol", "isiolo"]),
  CountyData(countyName: 'Meru', countyNumber: 12, stations: 0, indexKey: [
    "",
    "m",
    "me",
    "mer",
    "meru",
  ]),
  CountyData(
      countyName: 'Tharaka-Nithi',
      countyNumber: 13,
      stations: 0,
      indexKey: [
        "",
        "t",
        "th",
        "tha",
        "thar",
        "thara",
        "tharak",
        "tharaka",
        "tharaka-",
        "tharaka-n",
        "tharaka-ni",
        "tharaka-nit",
        "tharaka-nith",
        "tharaka-nithi"
      ]),
  CountyData(
      countyName: 'Embu',
      countyNumber: 14,
      stations: 0,
      indexKey: ["", "e", "em", "emb", "embu"]),
  CountyData(
      countyName: 'Kitui',
      countyNumber: 15,
      stations: 0,
      indexKey: ["", "k", "ki", "kit", "kitu", "kitui"]),
  CountyData(countyName: 'Machakos', countyNumber: 16, stations: 0, indexKey: [
    "",
    "m",
    "ma",
    "mac",
    "mach",
    "macha",
    "machak",
    "machako",
    "machakos"
  ]),
  CountyData(
      countyName: 'Makueni',
      countyNumber: 17,
      stations: 0,
      indexKey: ["", "m", "ma", "mak", "maku", "makue", "makuen", "makueni"]),
  CountyData(countyName: 'Nyandarua', countyNumber: 18, stations: 0, indexKey: [
    "",
    "n",
    "ny",
    "nya",
    "nyan",
    "nyand",
    "nyanda",
    "nyandar",
    "nyandaru",
    "nyandarua"
  ]),
  CountyData(
      countyName: 'Nyeri',
      countyNumber: 19,
      stations: 0,
      indexKey: ["", "n", "ny", "nye", "nyer", "nyeri"]),
  CountyData(countyName: 'Kirinyaga', countyNumber: 20, stations: 0, indexKey: [
    "",
    "k",
    "ki",
    "kir",
    "kiri",
    "kirin",
    "kiriny",
    "kirinya",
    "kirinyag",
    "kirinyaga"
  ]),
  CountyData(
      countyName: 'Muranga',
      countyNumber: 21,
      stations: 0,
      indexKey: ["", "m", "mu", "mur", "mura", "muran", "murang", "muranga"]),
  CountyData(
      countyName: 'Kiambu',
      countyNumber: 22,
      stations: 0,
      indexKey: ["", "k", "ki", "kia", "kiam", "kiamb", "kiambu"]),
  CountyData(
      countyName: 'Turkana',
      countyNumber: 23,
      stations: 0,
      indexKey: ["", "t", "tu", "tur", "turk", "turka", "turkan", "turkana"]),
  CountyData(
      countyName: 'West Pokot',
      countyNumber: 24,
      stations: 0,
      indexKey: [
        "",
        "w",
        "we",
        "wes",
        "west",
        "west ",
        "west p",
        "west po",
        "west pok",
        "west poko",
        "west pokot"
      ]),
  CountyData(
      countyName: 'Samburu',
      countyNumber: 25,
      stations: 0,
      indexKey: ["", "s", "sa", "sam", "samb", "sambu ", "sambur", "samburu"]),
  CountyData(
      countyName: 'Trans Nzoia',
      countyNumber: 26,
      stations: 0,
      indexKey: [
        "",
        "t",
        "tr",
        "tran",
        "trans",
        "trans n",
        "trans nz",
        "trans nzo",
        "trans nzoi",
        "trans nzoia"
      ]),
  CountyData(
      countyName: 'Uasin Gishu',
      countyNumber: 27,
      stations: 0,
      indexKey: [
        "",
        "u",
        "ua",
        "uas",
        "uasi",
        "uasin",
        "uasin ",
        "uasin g",
        "uasin gi",
        "uasin gis",
        "uasin gish",
        "uasin gishu"
      ]),
  CountyData(
      countyName: 'Elgeyo/Marakwet',
      countyNumber: 28,
      stations: 0,
      indexKey: [
        "",
        "e",
        "el",
        "elg",
        "elge",
        "elgey",
        "elgeyo",
        "elgeyo/",
        "elgeyo/m",
        "elgeyo/ma",
        "elgeyo/mar",
        "elgeyo/mara",
        "elgeyo/marak",
        "elgeyo/marakw",
        "elgeyo/marakwe",
        "elgeyo/marakwet"
      ]),
  CountyData(
      countyName: 'Nandi',
      countyNumber: 29,
      stations: 0,
      indexKey: ["", "n", "na", "nan", "nand", "nandi"]),
  CountyData(
      countyName: 'Baringo',
      countyNumber: 30,
      stations: 0,
      indexKey: ["", "b", "ba", "bar", "bari", "barin", "baring", "baringo"]),
  CountyData(countyName: 'Laikipia', countyNumber: 31, stations: 0, indexKey: [
    "",
    "l",
    "la",
    "lai",
    "laik",
    "laiki",
    "laikip",
    "laikipi",
    "laikipia"
  ]),
  CountyData(
      countyName: 'Nakuru',
      countyNumber: 32,
      stations: 0,
      indexKey: ["", "n", "na", "nak", "naku", "nakur", "nakuru"]),
  CountyData(
      countyName: 'Narok',
      countyNumber: 33,
      stations: 0,
      indexKey: ["", "n", "na", "nar", "naro", "narok"]),
  CountyData(
      countyName: 'Kajiado',
      countyNumber: 34,
      stations: 0,
      indexKey: ["", "k", "ka", "kaj", "kaji", "kajia", "kajiad", "kajiado"]),
  CountyData(
      countyName: 'Kericho',
      countyNumber: 36,
      stations: 0,
      indexKey: ["", "k", "ke", "ker", "keri", "keric", "kerich", "kericho"]),
  CountyData(
      countyName: 'Bomet',
      countyNumber: 37,
      stations: 0,
      indexKey: ["", "b", "bo", "bom", "bome", "bomet"]),
  CountyData(countyName: 'Kakamega', countyNumber: 38, stations: 0, indexKey: [
    "",
    "k",
    "ka",
    "kak",
    "kaka",
    "kakam",
    "kakame",
    "kakameg",
    "kakamega"
  ]),
  CountyData(
      countyName: 'Vihiga',
      countyNumber: 39,
      stations: 0,
      indexKey: ["", "v", "vi", "vih", "vihi", "vihig", "vihiga"]),
  CountyData(
      countyName: 'Bungoma',
      countyNumber: 40,
      stations: 0,
      indexKey: ["", "b", "bu", "bun", "bung", "bungo", "bungom", "bungoma"]),
  CountyData(
      countyName: 'Siaya',
      countyNumber: 41,
      stations: 0,
      indexKey: ["", "s", "si", "sia", "siay", "siaya"]),
  CountyData(
      countyName: 'Kisumu',
      countyNumber: 42,
      stations: 0,
      indexKey: ["", "k", "ki", "kis", "kisu", "kisum", "kisumu"]),
  CountyData(countyName: 'Homa Bay', countyNumber: 43, stations: 0, indexKey: [
    "",
    "h",
    "ho",
    "hom",
    "homa",
    "homa ",
    "homa b",
    "homa ba",
    "homa bay"
  ]),
  CountyData(
      countyName: 'Migori',
      countyNumber: 44,
      stations: 0,
      indexKey: ["", "m", "mi", "mig", "migo", "migor ", "migori"]),
  CountyData(
      countyName: 'Kisii',
      countyNumber: 45,
      stations: 0,
      indexKey: ["", "k", "ki", "kis", "kisi", "kisii"]),
  CountyData(
      countyName: 'Nyamira',
      countyNumber: 46,
      stations: 0,
      indexKey: ["", "n", "ny", "nya", "nyam", "nyami", "nyamir", "nyamira"]),
  CountyData(
      countyName: 'Nairobi City',
      countyNumber: 47,
      stations: 0,
      indexKey: [
        "",
        "n",
        "na",
        "nai",
        "nair",
        "nairo",
        "nairob",
        "nairobi",
        "nairobi ",
        "nairobi c",
        "nairobi ci",
        "nairobi cit",
        "nairobi city"
      ]),
];
