import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:cat_breeds_app/DTOs/cat_breed_dto.dart';
import 'package:cat_breeds_app/services/cat_breeds_provider.dart';
import 'package:cat_breeds_app/settings/app_assets.dart';
import 'package:cat_breeds_app/ui/screens/details_screen.dart';
import 'package:cat_breeds_app/ui/widgets/widgets.dart';

class CatBreedSearchDelegate extends SearchDelegate {
  @override
  String? get searchFieldLabel => 'Search breed';

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(onPressed: () => query = '', icon: const Icon(Icons.clear))
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () => close(context, null),
        icon: const Icon(Icons.arrow_back));
  }

  @override
  Widget buildResults(BuildContext context) {
    return buildSuggestions(context);
  }

  Widget _emptyContainer() {
    return Center(
      child: Image.asset(AppAssets.searchEmptyGif),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isEmpty) {
      return _emptyContainer();
    }

    final catBreedsProvider = Provider.of<CatBreedsProvider>(context);

    catBreedsProvider.searchCatBreedsByQuery(query);

    return StreamBuilder(
      stream: catBreedsProvider.suggestionsStream,
      builder: (_, AsyncSnapshot<List<CatBreedDTO>> snapshot) {
        if (!snapshot.hasData) {
          return _emptyContainer();
        }

        final catBreeds = snapshot.data!;

        return ListView.builder(
          itemCount: catBreeds.length,
          itemBuilder: (_, index) => Column(
            children: [
              _CatBreedItem(catBreed: catBreeds[index]),
              const Divider(
                height: 0,
                thickness: 0.3,
              ),
            ],
          ),
        );
      },
    );
  }
}

class _CatBreedItem extends StatelessWidget {
  final CatBreedDTO catBreed;

  const _CatBreedItem({
    required this.catBreed,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: ConstrainedBox(
        constraints: const BoxConstraints(
          minWidth: 100.0,
          maxWidth: 100.0,
        ),
        child: Hero(
          tag: catBreed.id,
          child: CustomImageContainer(imageUrl: catBreed.imageUrl),
        ),
      ),
      title: Text(catBreed.name),
      subtitle: Text(catBreed.origin),
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(
            builder: (context) => DetailsScreen(catBreed: catBreed)),
      ),
    );
  }
}
