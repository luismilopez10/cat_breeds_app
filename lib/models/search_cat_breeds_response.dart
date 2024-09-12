// To parse this JSON data, do
//
//     final searchResponse = searchResponseFromMap(jsonString);

import 'dart:convert';

import 'package:cat_breeds_app/models/models.dart';

class SearchResponse {
  int page;
  List<CatBreedResponse> results;
  int totalPages;
  int totalResults;

  SearchResponse({
    required this.page,
    required this.results,
    required this.totalPages,
    required this.totalResults,
  });

  factory SearchResponse.fromJson(String str) =>
      SearchResponse.fromMap(json.decode(str));

  factory SearchResponse.fromMap(Map<String, dynamic> json) => SearchResponse(
        page: json["page"],
        results: List<CatBreedResponse>.from(
            json["results"].map((x) => CatBreedResponse.fromMap(x))),
        totalPages: json["total_pages"],
        totalResults: json["total_results"],
      );
}
