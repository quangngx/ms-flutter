import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:masterstudy_app/data/models/account/account.dart';
import 'package:masterstudy_app/presentation/bloc/profile/profile_bloc.dart';
import 'package:masterstudy_app/presentation/screens/detail_profile/detail_profile_screen.dart';
import 'package:masterstudy_app/presentation/widgets/loader_widget.dart';
import 'package:masterstudy_app/theme/app_color.dart';

class ProfileWidget extends StatelessWidget {
  const ProfileWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        Account? account;

        if (state is LoadedProfileState) {
          account = state.account;
        }

        return InkWell(
          onTap: () {
            Navigator.pushNamed(
              context,
              DetailProfileScreen.routeName,
              arguments: DetailProfileScreenArgs(),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: <Widget>[
                ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(30.0)),
                  child: CachedNetworkImage(
                    width: 50.0,
                    fit: BoxFit.fill,
                    imageUrl: account?.avatarUrl ?? '',
                    placeholder: (context, url) => Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: LoaderWidget(
                        loaderColor: ColorApp.mainColor,
                      ),
                    ),
                    errorWidget: (context, url, error) {
                      return SizedBox(
                        child: Icon(
                          Icons.person,
                          size: 50,
                          color: Colors.grey,
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'greeting_user'.tr(),
                        style: Theme.of(context).primaryTextTheme.titleSmall!.copyWith(
                              color: ColorApp.kDarkGray,
                            ),
                      ),
                      Container(
                        width: double.infinity,
                        height: 28,
                        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width - 110),
                        child: Text(
                          account?.meta?.firstName != '' && account?.meta?.lastName != ''
                              ? '${account?.meta?.firstName} ${account?.meta?.lastName}'
                              : account?.login ?? '',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          softWrap: false,
                          style: Theme.of(context).primaryTextTheme.headlineSmall!.copyWith(
                                color: ColorApp.dark,
                              ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
