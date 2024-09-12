import 'package:flutter/material.dart';

import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:provider/provider.dart';

import 'package:cat_breeds_app/helpers/search_delegate.dart';
import 'package:cat_breeds_app/services/services.dart';
import 'package:cat_breeds_app/settings/app_assets.dart';
import 'package:cat_breeds_app/ui/screens/details_screen.dart';
import 'package:cat_breeds_app/ui/widgets/widgets.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController scrollController = ScrollController();
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  @override
  void initState() {
    super.initState();

    final catBreedsProvider =
        Provider.of<CatBreedsProvider>(context, listen: false);

    scrollController.addListener(() {
      if (scrollController.position.pixels >=
              scrollController.position.maxScrollExtent - 500 &&
          !catBreedsProvider.isLoadingNextPage) {
        catBreedsProvider.getPaginatedCatBreeds();
      }
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    _refreshController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Cat Breeds'),
        actions: [
          IconButton(
              onPressed: () => showSearch(
                  context: context, delegate: CatBreedSearchDelegate()),
              icon: const Icon(Icons.search_outlined)),
        ],
      ),
      body: _buildContent(context),
    );
  }

  Widget _buildContent(BuildContext context) {
    final catBreedsProvider = Provider.of<CatBreedsProvider>(context);

    final catBreeds = catBreedsProvider.catBreeds;

    return catBreedsProvider.isFirstLoading
        ? const Center(child: CircularProgressIndicator())
        : SmartRefresher(
            controller: _refreshController,
            enablePullDown: true,
            onRefresh: _loadCatBreeds,
            header: const WaterDropHeader(
              complete: Icon(
                Icons.check,
                color: Colors.indigo,
              ),
              waterDropColor: Color(0xFF939BCC),
            ),
            child: ListView.builder(
              controller: scrollController,
              itemCount: catBreeds.length,
              itemBuilder: (_, index) {
                final currentCatBreed = catBreeds[index];
                final isLastCatBreed = index == catBreeds.length - 1;

                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 8.0),
                      child: GestureDetector(
                        onTap: () =>
                            Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) =>
                              DetailsScreen(catBreed: catBreeds[index]),
                        )),
                        child: Card(
                          margin: EdgeInsets.zero,
                          elevation: 5.0,
                          color: const Color(0xFFE4E6F3),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    currentCatBreed.name,
                                    style: const TextStyle(
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 250.0,
                                width: double.infinity,
                                child: Hero(
                                  tag: currentCatBreed.id,
                                  child: currentCatBreed.imageUrl.isNotEmpty
                                      ? CustomImageContainer(
                                          imageUrl: currentCatBreed.imageUrl)
                                      : Image.asset(AppAssets.imageNotFound),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(currentCatBreed.origin),
                                    Text(
                                        'Intelligence: ${currentCatBreed.intelligence}'),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    if (catBreedsProvider.isLoadingNextPage && isLastCatBreed)
                      const Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      ),
                  ],
                );
              },
            ),
          );
  }

  void _loadCatBreeds() async {
    final catBreedsProvider =
        Provider.of<CatBreedsProvider>(context, listen: false);
    await catBreedsProvider.refreshCatBreeds();
    _refreshController.refreshCompleted();
  }
}
