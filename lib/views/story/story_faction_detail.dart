import 'package:blavapp/bloc/story/bloc/story_bloc.dart';
import 'package:blavapp/components/images/app_network_image.dart';
import 'package:blavapp/components/page_hierarchy/detail_not_found.dart';
import 'package:blavapp/components/page_hierarchy/side_page.dart';
import 'package:blavapp/components/views/title_divider.dart';
import 'package:blavapp/model/story.dart';
import 'package:blavapp/utils/app_heros.dart';
import 'package:blavapp/utils/model_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class StoryFactionDetail extends StatelessWidget {
  final String factionRef;
  const StoryFactionDetail({
    Key? key,
    required this.factionRef,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StoryBloc, StoryState>(
      builder: (context, state) {
        final StoryFaction? faction = state.factions[factionRef];
        final StoryEntity? leader = state.entities[faction?.leaderRef];
        final List<StoryEntity?>? members = faction?.memberRef
            .map((ref) => state.entities[ref])
            .where((entity) => entity != null)
            .toList();
        if (faction != null) {
          return SidePage(
            titleText: t(faction.name, context),
            body: _FactionDetailContent(
                faction: faction, leader: leader, members: members),
          );
        } else {
          return DetailNotFoundPage(
            message: '404 - factionRef: $factionRef',
          );
        }
      },
    );
  }
}

class _FactionDetailContent extends StatelessWidget {
  final StoryFaction faction;
  final StoryEntity? leader;
  final List<StoryEntity?>? members;
  const _FactionDetailContent({
    Key? key,
    required this.faction,
    required this.leader,
    required this.members,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          _FactionHeader(faction: faction, leader: leader),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Column(
              children: [
                _FactionDescription(faction: faction),
                _FactionHighlights(faction: faction),
                if (members != null && members!.isNotEmpty)
                  _FactionMembers(members: members),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class _FactionHeader extends StatelessWidget {
  final StoryFaction faction;
  final StoryEntity? leader;

  const _FactionHeader({
    Key? key,
    required this.faction,
    required this.leader,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double flagHeight = height * 0.25;
    final double leaderHeight = flagHeight * 0.8;
    return SizedBox(
      height: flagHeight,
      child: Stack(
        children: [
          Positioned.fill(
            child: Hero(
              tag: storyFactionImgHeroTag(faction),
              child: AppNetworkImage(
                url: faction.image!,
                asCover: true,
              ),
            ),
          ),
          if (leader != null && leader!.images.isNotEmpty)
            Positioned(
              bottom: 5,
              right: 5,
              child: Hero(
                tag: storyEntityImgHeroTag(leader!),
                child: CircleAvatar(
                  radius: leaderHeight / 2,
                  backgroundImage: NetworkImage(
                    leader!.images[0],
                  ),
                ),
              ),
            ),
          if (leader != null)
            Positioned(
              bottom: 0,
              right: 0,
              child: Card(
                shape: RoundedRectangleBorder(
                  side:
                      BorderSide(color: Theme.of(context).focusColor, width: 5),
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 10,
                child: SizedBox(
                  width: leaderHeight + 10,
                  child: Column(
                    children: [
                      Text(
                        leader!.name,
                        style: Theme.of(context).textTheme.headline6,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        t(leader!.type, context),
                        style: Theme.of(context).textTheme.subtitle1,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _FactionDescription extends StatelessWidget {
  final StoryFaction faction;

  const _FactionDescription({
    Key? key,
    required this.faction,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 8),
        Text(t(faction.desc, context)),
      ],
    );
  }
}

class _FactionHighlights extends StatelessWidget {
  final StoryFaction faction;

  const _FactionHighlights({
    Key? key,
    required this.faction,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TitleDivider(
            title: AppLocalizations.of(context)!.contStoryFactionHighlights),
        Column(
          children: faction.highlights
              .map((e) => Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        '${t(e['key']!, context)}:',
                      ),
                      Text(
                        t(e['value']!, context),
                        style: Theme.of(context).textTheme.subtitle1,
                      ),
                    ],
                  ))
              .toList(),
        ),
      ],
    );
  }
}

class _FactionMembers extends StatelessWidget {
  final List<StoryEntity?>? members;

  const _FactionMembers({
    Key? key,
    required this.members,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 16),
        TitleDivider(
          title: AppLocalizations.of(context)!.contStoryFactionMembers,
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: members!.map((member) {
              return InkWell(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: 124,
                    height: 114,
                    child: Stack(
                      children: [
                        Align(
                          alignment: Alignment.topCenter,
                          child: Hero(
                            tag: storyEntityImgHeroTag(member!),
                            child: CircleAvatar(
                              radius: 57,
                              backgroundImage: NetworkImage(
                                member.images[0],
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          left: 0,
                          child: Card(
                            child: Column(
                              children: [
                                Text(
                                  member.name,
                                  style: Theme.of(context).textTheme.titleSmall,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.center,
                                ),
                                Text(
                                  t(member.type, context),
                                  style: Theme.of(context).textTheme.bodySmall,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

class StoryFactionDetailsArguments {
  final String factionRef;

  StoryFactionDetailsArguments({required this.factionRef});
}
