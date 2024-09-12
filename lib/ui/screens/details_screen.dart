import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:cat_breeds_app/DTOs/cat_breed_dto.dart';
import 'package:cat_breeds_app/settings/app_assets.dart';
import 'package:cat_breeds_app/ui/widgets/widgets.dart';

class DetailsScreen extends StatelessWidget {
  final CatBreedDTO catBreed;

  const DetailsScreen({
    required this.catBreed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Theme.of(context).platform == TargetPlatform.iOS
        ? CupertinoPageScaffold(
            navigationBar: CupertinoNavigationBar(
              middle: Text(catBreed.name),
            ),
            child: _buildContent(context),
          )
        : Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: Text(catBreed.name),
            ),
            body: _buildContent(context),
          );
  }

  Column _buildContent(BuildContext context) {
    return Column(
      children: [
        ConstrainedBox(
          constraints: const BoxConstraints(
            maxHeight: 500.0,
            minWidth: double.infinity,
          ),
          child: Hero(
            tag: catBreed.id,
            child: catBreed.imageUrl.isNotEmpty
                ? CustomImageContainer(imageUrl: catBreed.imageUrl)
                : Image.asset(AppAssets.imageNotFound),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 12.0, right: 8.0, bottom: 12.0),
            child: Scrollbar(
              // trackVisibility: true,
              thumbVisibility: true,
              radius: const Radius.circular(20.0),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14.0),
                child: SingleChildScrollView(
                  physics: Theme.of(context).platform == TargetPlatform.iOS
                      ? const BouncingScrollPhysics()
                      : const ClampingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InfoItem(
                        boldText: 'Description',
                        normalText: catBreed.description,
                      ),
                      const SizedBox(height: 14.0),
                      InfoItem(
                        boldText: 'Country of Origin',
                        normalText: catBreed.origin,
                      ),
                      const SizedBox(height: 14.0),
                      InfoItem(
                        boldText: 'Intelligence',
                        normalText: '${catBreed.intelligence}',
                      ),
                      const SizedBox(height: 14.0),
                      InfoItem(
                        boldText: 'Adaptability',
                        normalText: '${catBreed.adaptability}',
                      ),
                      const SizedBox(height: 14.0),
                      InfoItem(
                        boldText: 'Life Span',
                        normalText: '${catBreed.lifeSpan}  Years',
                      ),
                      const SizedBox(height: 14.0),
                      InfoItem(
                        boldText: 'Affection Level',
                        normalText: '${catBreed.affectionLevel}',
                      ),
                      const SizedBox(height: 14.0),
                      InfoItem(
                        boldText: 'Child Friendly',
                        normalText: '${catBreed.childFriendly}',
                      ),
                      const SizedBox(height: 14.0),
                      InfoItem(
                        boldText: 'Stranger Friendly',
                        normalText: '${catBreed.strangerFriendly}',
                      ),
                      const SizedBox(height: 14.0),
                      InfoItem(
                        boldText: 'Dog Friendly',
                        normalText: '${catBreed.dogFriendly}',
                      ),
                      const SizedBox(height: 14.0),
                      InfoItem(
                        boldText: 'Energy Level',
                        normalText: '${catBreed.energyLevel}',
                      ),
                      const SizedBox(height: 14.0),
                      InfoItem(
                        boldText: 'Social Needs',
                        normalText: '${catBreed.socialNeeds}',
                      ),
                      const SizedBox(height: 14.0),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
