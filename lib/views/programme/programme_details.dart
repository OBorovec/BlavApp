import 'package:blavapp/bloc/programme/data_programme/programme_bloc.dart';
import 'package:blavapp/bloc/user_data/user_data/user_data_bloc.dart';
import 'package:blavapp/components/control/rating_bar.dart';
import 'package:blavapp/components/page_hierarchy/side_page.dart';
import 'package:blavapp/components/images/app_network_image.dart';
import 'package:blavapp/components/views/title_divider.dart';
import 'package:blavapp/model/programme.dart';
import 'package:blavapp/utils/app_heros.dart';
import 'package:blavapp/utils/datetime_formatter.dart';
import 'package:blavapp/utils/model_localization.dart';
import 'package:blavapp/views/maps/maps_control_widgets.dart';
import 'package:blavapp/views/programme/programme_bloc_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ProgrammeDetails extends StatelessWidget {
  final ProgEntry entry;

  const ProgrammeDetails({
    Key? key,
    required this.entry,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SidePage(
      titleText: t(entry.name, context),
      body: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: Column(
          children: [
            if (entry.images.isNotEmpty) _ProgrammeEntryHeroImage(entry: entry),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  _ProgrammeEntryBaseInfo(entry: entry),
                  if (entry.desc != null)
                    _ProgrammeEntryDescription(entry: entry),
                  _ProgrammeEntryControlBtns(entry: entry),
                  // const SizedBox(height: 32),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProgrammeEntryHeroImage extends StatelessWidget {
  final ProgEntry entry;

  const _ProgrammeEntryHeroImage({
    Key? key,
    required this.entry,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return SizedBox(
      height: height * 0.4,
      child: Hero(
        tag: programmeEntryImgHeroTag(entry),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            bottomRight: Radius.circular(64),
          ),
          child: AppNetworkImage(
            imgLocation: entry.images[0],
            asCover: true,
          ),
        ),
      ),
    );
  }
}

class _ProgrammeEntryBaseInfo extends StatelessWidget {
  final ProgEntry entry;

  const _ProgrammeEntryBaseInfo({
    Key? key,
    required this.entry,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ProgPlace? place = BlocProvider.of<ProgrammeBloc>(context)
        .state
        .programmePlaces[entry.placeRef];
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            Text(
              t(entry.name, context),
              style: Theme.of(context).textTheme.headline5,
            ),
            _buildInfoLine(
              Icons.access_time_outlined,
              '${datetimeToDateShort(entry.timestamp, context)}-${datetimeToHours(entry.timestamp, context)}',
              context,
            ),
            _buildInfoLine(
              Icons.timelapse_outlined,
              '${entry.duration} ${AppLocalizations.of(context)!.genMinutes}',
              context,
            ),
            _buildInfoLine(
              Icons.place_outlined,
              place != null ? t(place.name, context) : '?${entry.placeRef}?',
              context,
            ),
            _buildInfoLine(
              Icons.category_outlined,
              tProgEntryType(entry.type, context),
              context,
            ),
          ],
        ),
        Row(
          children: [
            Column(
              children: [
                ProgrammeEntryNotification(entryId: entry.id),
                ProgrammeEntryMyProgramme(entryId: entry.id),
              ],
            ),
            Column(
              children: [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.share),
                ),
                (place != null && place.loc != null)
                    ? IconBtnPushCustomMap(
                        mapRef: place.loc!.mapRef,
                        pointRef: place.loc!.pointRef,
                      )
                    : const Icon(Icons.location_off)
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildInfoLine(
    IconData iconData,
    String text,
    BuildContext context,
  ) {
    return IntrinsicHeight(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Icon(
            iconData,
            size: 20,
          ),
          const VerticalDivider(),
          Text(
            text,
            style: Theme.of(context).textTheme.subtitle2,
          ),
        ],
      ),
    );
  }
}

class _ProgrammeEntryDescription extends StatelessWidget {
  final ProgEntry entry;

  const _ProgrammeEntryDescription({
    Key? key,
    required this.entry,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 16),
        TitleDivider(
          title: AppLocalizations.of(context)!.genDescription,
        ),
        Text(t(entry.desc!, context))
      ],
    );
  }
}

class _ProgrammeEntryControlBtns extends StatelessWidget {
  final ProgEntry entry;

  const _ProgrammeEntryControlBtns({
    Key? key,
    required this.entry,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Column(
      children: [
        const Divider(
          height: 32,
        ),
        SizedBox(
          width: width * 0.7,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Feedback button
              _buildBtn(
                onPressed: () => showDialog(
                  context: context,
                  builder: (BuildContext context) =>
                      _ProgrammeFeedbackDialog(reference: entry.id),
                ),
                iconData: Icons.feedback,
                text: AppLocalizations.of(context)!
                    .contProgrammeDetailBtnFeedBack,
              ),
              // Sing up button
              if (entry.requireSignUp) ...[
                const SizedBox(height: 8),
                _buildBtn(
                  onPressed: () => null,
                  iconData: Icons.login,
                  text: AppLocalizations.of(context)!
                      .contProgrammeDetailBtnSignUp,
                ),
              ],
              const SizedBox(height: 8),
              // My programme button
              BlocBuilder<UserDataBloc, UserDataState>(
                builder: (context, state) {
                  final bool isIn =
                      state.userData.myProgramme.contains(entry.id);
                  return _buildBtn(
                    onPressed: () => BlocProvider.of<UserDataBloc>(context).add(
                      UserDataMyProgramme(
                        entryId: entry.id,
                      ),
                    ),
                    iconData: isIn ? Icons.bookmark_remove : Icons.bookmark_add,
                    text: isIn
                        ? AppLocalizations.of(context)!
                            .contProgrammeDetailBtnMyProgrammeRemove
                        : AppLocalizations.of(context)!
                            .contProgrammeDetailBtnMyProgramme,
                  );
                },
              ),
              const SizedBox(height: 8),
              // My notification button
              BlocBuilder<UserDataBloc, UserDataState>(
                builder: (context, state) {
                  final bool isIn =
                      state.userData.myNotifications.contains(entry.id);
                  return _buildBtn(
                    onPressed: () => BlocProvider.of<UserDataBloc>(context).add(
                      UserDataProgMyNotification(
                        entryId: entry.id,
                      ),
                    ),
                    iconData:
                        isIn ? Icons.notifications_on : Icons.notifications_off,
                    text: isIn
                        ? AppLocalizations.of(context)!
                            .contProgrammeDetailBtnNotificationRemove
                        : AppLocalizations.of(context)!
                            .contProgrammeDetailBtnNotification,
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBtn({
    required Function() onPressed,
    required IconData iconData,
    required String text,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Row(
        children: [
          Icon(iconData),
          Expanded(
            child: Text(text, textAlign: TextAlign.center),
          )
        ],
      ),
    );
  }
}

class _ProgrammeFeedbackDialog extends StatefulWidget {
  final String reference;
  const _ProgrammeFeedbackDialog({
    Key? key,
    required,
    required this.reference,
  }) : super(key: key);

  @override
  State<_ProgrammeFeedbackDialog> createState() =>
      _ProgrammeFeedbackDialogState();
}

class _ProgrammeFeedbackDialogState extends State<_ProgrammeFeedbackDialog> {
  double rating = 0;
  String message = '';
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        AppLocalizations.of(context)!.contProgrammeDetailDiagFeedback,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppRatingBar(
            onRating: (rating) => setState(() => this.rating = rating),
          ),
          const SizedBox(height: 16),
          TextField(
            onChanged: (value) => setState(() {
              message = value;
            }),
            maxLines: 10,
          ),
        ],
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            BlocProvider.of<UserDataBloc>(context).add(
              UserDataFeedBack(
                rating: rating,
                message: message,
                reference: widget.reference,
              ),
            );
            Navigator.pop(context);
          },
          child: Text(AppLocalizations.of(context)!.genSend),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(AppLocalizations.of(context)!.genDismiss),
        ),
      ],
    );
  }
}

class ProgrammeDetailsArguments {
  final ProgEntry entry;

  ProgrammeDetailsArguments({required this.entry});
}
