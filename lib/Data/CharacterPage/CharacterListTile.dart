import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../Domain/Models/CharacterAppModel.dart';

class CharacterListTile extends StatelessWidget {
  final CharacterAppModel character;
  final VoidCallback onTap;

  const CharacterListTile(
      {super.key, required this.character, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
        leading: CachedNetworkImage(
          imageUrl: character.image,
          imageBuilder: (context, imageProvider) => CircleAvatar(
            radius: 24,
            backgroundImage: imageProvider,
          ),
          placeholder: (context, url) => const CircleAvatar(
            radius: 24,
            backgroundColor: Colors.blue,
          ),
          errorWidget: (context, url, error) => const CircleAvatar(
            radius: 24,
            backgroundColor: Colors.blue,
          ),
        ),
        title:
        Text(character.name, style: Theme.of(context).textTheme.bodyLarge),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              character.species,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            Text(character.status,
                style: Theme.of(context).textTheme.bodyMedium),
          ],
        ),
        onTap: onTap);
  }
}
