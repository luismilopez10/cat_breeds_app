import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:async';

import 'package:http/http.dart' as http;

import 'package:cat_breeds_app/DTOs/cat_breed_dto.dart';
import 'package:cat_breeds_app/helpers/debouncer.dart';
import 'package:cat_breeds_app/models/models.dart';

class CatBreedsProvider extends ChangeNotifier {
  final String _baseUrl = 'api.thecatapi.com';

  final int _limit = 10;
  int _page = 0;
  final int _maxPage = 6;

  bool isFirstLoading = true;
  bool isLoadingNextPage = false;

  List<CatBreedDTO> catBreeds = [];

  final debouncer = Debouncer(
    duration: const Duration(milliseconds: 500),
  );

  final StreamController<List<CatBreedDTO>> _suggestionStreamController =
      StreamController.broadcast();
  Stream<List<CatBreedDTO>> get suggestionsStream =>
      _suggestionStreamController.stream;

  CatBreedsProvider() {
    _getFirstPageCatBreeds();
  }

  Future<dynamic> _getJsonData(String endpoint,
      [Map<String, String>? params]) async {
    final url = Uri.https(_baseUrl, endpoint, {
      ...?params,
    });

    final response = await http.get(url);
    return response;
  }

  Future _getCatBreeds() async {
    final response = await _getJsonData('/v1/breeds', {
      'limit': '$_limit',
      'page': '$_page',
    });

    final List<dynamic> decodedData = jsonDecode(response.body);

    for (var breedData in decodedData) {
      CatBreedResponse catBreedResponse = CatBreedResponse.fromMap(breedData);

      final imageResponse = await _getJsonData('/v1/images/search', {
        'breed_ids': catBreedResponse.id!,
      });

      final List<dynamic> imageDecodedData = jsonDecode(imageResponse.body);

      String imageUrl =
          imageDecodedData.isNotEmpty ? imageDecodedData[0]['url'] : '';

      CatBreedDTO catBreedDTO = CatBreedDTO(
        id: catBreedResponse.id ?? '',
        name: catBreedResponse.name ?? '',
        description: catBreedResponse.description ?? '',
        origin: catBreedResponse.origin ?? '',
        intelligence: catBreedResponse.intelligence ?? 0,
        adaptability: catBreedResponse.adaptability ?? 0,
        lifeSpan: catBreedResponse.lifeSpan ?? '',
        affectionLevel: catBreedResponse.affectionLevel ?? 0,
        childFriendly: catBreedResponse.childFriendly ?? 0,
        strangerFriendly: catBreedResponse.strangerFriendly ?? 0,
        dogFriendly: catBreedResponse.dogFriendly ?? 0,
        energyLevel: catBreedResponse.energyLevel ?? 0,
        socialNeeds: catBreedResponse.socialNeeds ?? 0,
        imageUrl: imageUrl,
      );

      catBreeds.add(catBreedDTO);
    }
  }

  Future _getFirstPageCatBreeds() async {
    isFirstLoading = true;
    notifyListeners();

    await _getCatBreeds();

    isFirstLoading = false;
    notifyListeners();
  }

  Future refreshCatBreeds() async {
    notifyListeners();

    _page = 0;
    catBreeds.clear();
    await _getCatBreeds();

    notifyListeners();
  }

  Future getPaginatedCatBreeds() async {
    if (_page >= _maxPage) return;

    isLoadingNextPage = true;
    notifyListeners();

    _page++;
    await _getCatBreeds();

    isLoadingNextPage = false;
    notifyListeners();
  }

  Future searchCatBreeds(String query) async {
    List<CatBreedDTO> catBreedsFiltered = [];

    final response = await _getJsonData('/v1/breeds/search', {
      'q': query,
    });

    final List<dynamic> decodedData = jsonDecode(response.body);

    for (var breedData in decodedData) {
      CatBreedResponse catBreedResponse = CatBreedResponse.fromMap(breedData);

      final imageResponse = await _getJsonData('/v1/images/search', {
        'breed_ids': catBreedResponse.id!,
      });

      final List<dynamic> imageDecodedData = jsonDecode(imageResponse.body);

      String imageUrl =
          imageDecodedData.isNotEmpty ? imageDecodedData[0]['url'] : '';

      CatBreedDTO catBreedDTO = CatBreedDTO(
        id: catBreedResponse.id ?? '',
        name: catBreedResponse.name ?? '',
        description: catBreedResponse.description ?? '',
        origin: catBreedResponse.origin ?? '',
        intelligence: catBreedResponse.intelligence ?? 0,
        adaptability: catBreedResponse.adaptability ?? 0,
        lifeSpan: catBreedResponse.lifeSpan ?? '',
        affectionLevel: catBreedResponse.affectionLevel ?? 0,
        childFriendly: catBreedResponse.childFriendly ?? 0,
        strangerFriendly: catBreedResponse.strangerFriendly ?? 0,
        dogFriendly: catBreedResponse.dogFriendly ?? 0,
        energyLevel: catBreedResponse.energyLevel ?? 0,
        socialNeeds: catBreedResponse.socialNeeds ?? 0,
        imageUrl: imageUrl,
      );

      catBreedsFiltered.add(catBreedDTO);
    }

    return catBreedsFiltered;
  }

  void searchCatBreedsByQuery(String searchTerm) {
    debouncer.value = '';
    debouncer.onValue = (value) async {
      final results = await searchCatBreeds(value);
      _suggestionStreamController.add(results);
    };

    final timer = Timer.periodic(const Duration(milliseconds: 150), (_) {
      debouncer.value = searchTerm;
    });

    Future.delayed(const Duration(milliseconds: 151))
        .then((_) => timer.cancel());
  }
}
