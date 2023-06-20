import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../providers/categoriesProvider.dart';
import '../providers/userProvider.dart';

import 'category_item.dart';
import 'notification_widget.dart';
import 'notifications_screen.dart';
import 'product_search_screen.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/home-screen';

  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final scrollController = ScrollController();
  String? nextUrl;
  String? previousUrl;
  dynamic categoriesProvider;

  TextEditingController searchController = TextEditingController();

  Map<String, dynamic>? filteredCategories;
  List<dynamic>? results;

  @override
  void initState() {
    scrollController.addListener(_scrollListener);
    _loadCategories();
    super.initState();
  }

  Future<void> _loadCategories({String? searchQuery}) async {
    await Provider.of<Categories>(context, listen: false)
        .getGeneralCategories(searchQuery: searchQuery);
  }

  @override
  Widget build(BuildContext context) {
    final appLocalization = AppLocalizations.of(context)!;
    final mediaquery = MediaQuery.of(context).size;
    final userData = Provider.of<UserProvider>(context).jwtUserData;
    categoriesProvider = Provider.of<Categories>(context);
    nextUrl = categoriesProvider.nextPageEndPoint;
    previousUrl = categoriesProvider.previousPageEndPoint;

    return SafeArea(
      child: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
          body: LayoutBuilder(builder: (context, constraints) {
            return SingleChildScrollView(
              controller: scrollController,
              child: Padding(
                padding: EdgeInsets.symmetric(
                  vertical: mediaquery.height * .015,
                  horizontal: mediaquery.width * 0.05,
                ),
                child: Column(
                  children: [
                    SizedBox(
                      height: mediaquery.height * 0.06,
                      child: CustomScrollView(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        slivers: [
                          SliverAppBar(
                            pinned: true,
                            title: RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text:
                                        '${appLocalization.hi} ${userData['first_name']}!\n',
                                    style: TextStyle(
                                        fontSize: mediaquery.width * 0.045,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black),
                                  ),
                                  TextSpan(
                                    text: appLocalization.howAreYouFeelingToday,
                                    style: TextStyle(
                                        fontSize: mediaquery.width * 0.035,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black38),
                                  )
                                ],
                              ),
                            ),
                            actions: [
                              GestureDetector(
                                child: NotificationIcon(),
                                onTap: () => Navigator.pushNamed(
                                  context,
                                  NotificationsScreen.routeName,
                                ),
                              ),
                            ],
                            elevation: 0,
                            backgroundColor: Colors.white10,
                            foregroundColor: Colors.black,
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: mediaquery.height * 0.02),
                    Stack(
                      alignment: AlignmentDirectional.topStart,
                      children: [
                        Transform(
                          transform: appLocalization.localeName == 'ar'
                              ? Matrix4.rotationY(math.pi)
                              : Matrix4.rotationY(0),
                          child: Image.asset(
                            'assets/images/background.png',
                            width: double.infinity,
                          ),
                        ),
                        SizedBox(
                          height: mediaquery.height * 0.3,
                          child: Column(
                            // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(
                                    left: mediaquery.height * 0.02,
                                    top: mediaquery.height * 0.03),
                                child: Text(
                                  '${appLocalization.check}\n'
                                  '${appLocalization.interactions}',
                                  style: TextStyle(
                                      fontSize: mediaquery.width *
                                          0.075 *
                                          MediaQuery.of(context)
                                              .textScaleFactor,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              SizedBox(
                                height: mediaquery.height * 0.16,
                                width: mediaquery.width * 0.5,
                                child: IconButton(
                                  onPressed: () {},
                                  icon: Stack(
                                    children: [
                                      Image.asset(
                                        'assets/images/btn.png',
                                        fit: BoxFit.cover,
                                      ),
                                      Positioned(
                                        top: mediaquery.height * 0.05,
                                        left: mediaquery.width * 0.09,
                                        child: Text(
                                          appLocalization.learnMore,
                                          softWrap: false,
                                          style: TextStyle(
                                            fontSize: mediaquery.width *
                                                0.055 *
                                                MediaQuery.of(context)
                                                    .textScaleFactor,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: mediaquery.height * 0.01),
                    Row(
                      children: [
                        Flexible(
                          flex: 1,
                          child: SizedBox(
                            height: 50,
                            child: TextFormField(
                              onTap: () {
                                Navigator.of(context)
                                    .pushNamed(ProductSearchScreen.routeName);
                              },
                              readOnly: true,
                              cursorColor: Colors.grey,
                              decoration: InputDecoration(
                                fillColor: Colors.grey.shade200,
                                filled: true,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                      mediaquery.height * 0.02),
                                  borderSide: BorderSide.none,
                                ),
                                hintText: appLocalization.search,
                                hintStyle: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: mediaquery.width * 0.05,
                                  color: Colors.grey,
                                ),
                                contentPadding:
                                    const EdgeInsets.only(top: 6, left: 10),
                                suffixIcon: Icon(
                                  Icons.search,
                                  color: Colors.grey,
                                  size: mediaquery.width * 0.06,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: mediaquery.height * 0.03),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          appLocalization.categories,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: mediaquery.width * 0.055),
                        ),
                      ],
                    ),
                    SizedBox(height: mediaquery.height * 0.03),
                    const CategoryItem(),
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  void _scrollListener() {
    if (scrollController.position.pixels ==
        scrollController.position.maxScrollExtent) {
      categoriesProvider.getNextCat(nextUrl);
    }
  }
}
