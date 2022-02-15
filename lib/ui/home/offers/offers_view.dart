// ignore_for_file: avoid_print

import 'dart:developer';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:intersmeet/core/constants/colorsz.dart';
import 'package:intersmeet/core/models/degree/company.dart';
import 'package:intersmeet/core/models/degree/degree.dart';
import 'package:intersmeet/core/models/degree/family.dart';
import 'package:intersmeet/core/models/degree/level.dart';
import 'package:intersmeet/core/models/offer/application.dart';
import 'package:intersmeet/core/models/offer/offer.dart';
import 'package:intersmeet/core/models/offer/pagination_options.dart';
import 'package:intersmeet/core/services/user_service.dart';
import 'package:intersmeet/main.dart';
import 'package:intersmeet/ui/home/home_scaffold.dart';
import 'package:intersmeet/ui/home/offers/offer_item.dart';
import 'package:intersmeet/ui/shared/br.dart';
import 'package:intersmeet/ui/shared/dropdown_search_imp.dart';
import 'package:intersmeet/ui/shared/spash_screen.dart';
import 'package:rxdart/rxdart.dart';

class OffersView extends StatefulWidget {
  final String? message;
  const OffersView({Key? key, this.message}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _OffersViewState();
}

class _OffersViewState extends State<OffersView> {
  final userService = getIt<UserService>();
  final authService = getIt<UserService>();

  // @ Key/State management
  final _drawerKey = GlobalKey<ScaffoldState>();
  final pagination = BehaviorSubject<PaginationOptions>();
  int total = 0;

  Company? _selectedCompany;
  Degree? _selectedDegree;
  Family? _selectedFamily;
  Level? _selectedLevel;

  bool _familiesEnabled = true;
  bool _levelsEnabled = true;

  var _salaryRangeValues = const RangeValues(0, 10000);

  // @ Async Data
  late List<Application> applications;
  final List<Offer> offers = [];
  final List<Company> companies = [];
  final List<Degree> degrees = [];
  final List<Family> families = [];
  final List<Level> levels = [];
  // @ Data
  late List<DropdownMenuItem<int>> sizes;

  @override
  void initState() {
    pagination.stream.listen((options) async {
      var o = await userService.findAllOffers(options);
      setState(() {
        _selectedCompany =
            companies.firstWhereOrNull((c) => c.companyId == pagination.value.companyId);
        _selectedDegree = degrees.firstWhereOrNull((d) => d.degreeId == pagination.value.degreeId);
        _selectedFamily = families.firstWhereOrNull((f) => f.familyId == options.familyId);
        _selectedLevel = levels.firstWhereOrNull((l) => l.levelId == options.levelId);
        _familiesEnabled = options.degreeId == null;
        _levelsEnabled = options.degreeId == null;
        offers.clear();
        offers.addAll(o.results);
        total = o.total;
      });
    });
    pagination.add(PaginationOptions(page: 0, size: 15));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Future.wait([
        userService.findAllCompanies(),
        userService.findAllDegrees(),
        userService.findAllFamilies(),
        userService.findAllLevels(),
        userService.findAllApplications(null),
      ]),
      builder: (_context, AsyncSnapshot<List<dynamic>> snapshot) {
        // @ Splash screen
        if (!snapshot.hasData) return const Center(child: SpashScreen());

        // @ Load data
        if (snapshot.data != null &&
            snapshot.data![0] is List<Company> &&
            snapshot.data![1] is List<Degree> &&
            snapshot.data![2] is List<Family> &&
            snapshot.data![3] is List<Level> &&
            snapshot.data![4] is List<Application>) {
          companies.addAll(snapshot.data![0]);
          degrees.addAll(snapshot.data![1]);
          families.addAll(snapshot.data![2]);
          levels.addAll(snapshot.data![3]);
          applications = snapshot.data![4];
          sizes = List.from(
            [15, 30, 50, 100].map((e) => DropdownMenuItem<int>(
                  child: Text("$e"),
                  value: e,
                )),
          );
        }

        // @ Build UI
        return HomeScaffold(
          drawerKey: _drawerKey,
          title: searchBar(),
          endDrawer: filterDrawer(),
          body: SafeArea(
            child: Container(
              color: Colorz.complexDrawerBlack,
              child: Column(
                children: [
                  filterBar(_context),
                  Expanded(
                    child: ListView.builder(
                      itemCount: offers.length,
                      itemBuilder: (BuildContext context, int index) {
                        var offer = offers.elementAt(index);
                        var application =
                            applications.firstWhereOrNull((a) => a.offerId == offer.offerId);
                        return OffersItemComponent(
                            offer: offers.elementAt(index),
                            background:
                                index % 2 == 0 ? const Color(0xFF0D1117) : const Color(0xFF161B22),
                            status: application?.status,
                            index: index);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget searchBar() {
    return TextFormField(
      decoration:
          const InputDecoration(suffixIcon: Icon(Icons.search), hintText: 'Search offers...'),
      onChanged: (value) {
        if (value.isNotEmpty) {
          setState(() {
            pagination.add(pagination.value..search = value);
          });
        }
      },
    );
  }

  Widget filterBar(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colorz.complexDrawerBlueGrey,
        boxShadow: [BoxShadow(color: Colors.white10, offset: Offset(2, 2))],
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
      ),
      height: 60,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          MaterialButton(
            height: 20,
            shape: const CircleBorder(),
            highlightColor: Colors.white24,
            minWidth: 34,
            onPressed: () {
              if (pagination.value.page > 0) {
                pagination.add(pagination.value..page = pagination.value.page - 1);
              }
            },
            child: const Icon(
              Icons.arrow_back_ios,
              size: 20,
            ),
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: MaterialButton(
                    height: 20,
                    shape: const CircleBorder(),
                    highlightColor: Colors.white24,
                    minWidth: 34,
                    onPressed: () {
                      _drawerKey.currentState!.openEndDrawer(); // 782322411
                    },
                    child: const Icon(
                      Icons.settings_input_composite_outlined,
                      size: 20,
                    ),
                  ),
                ),
                Expanded(
                  child: Row(
                    children: [
                      const Text('Page size'),
                      Container(
                        margin: const EdgeInsets.only(left: 5),
                        child: DropdownButton<int>(
                          items: sizes,
                          value: pagination.value.size,
                          onChanged: (value) {
                            pagination.add(pagination.value..size = value ?? 15);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          MaterialButton(
            height: 20,
            shape: const CircleBorder(),
            highlightColor: Colors.white24,
            minWidth: 34,
            onPressed: () {
              if ((pagination.value.page + 1) < (total / pagination.value.size)) {
                pagination.add(pagination.value..page = pagination.value.page + 1);
              }
            },
            child: const Icon(
              Icons.arrow_forward_ios,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }

  Widget filterDrawer() {
    return SafeArea(
      child: Drawer(
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Column(
            children: [
              const Text('Offer filters', style: TextStyle(fontSize: 20)),
              const Divider(color: Colorz.accountPurple),
              br(20),
              customCheckbox(
                labelText: 'Skip expired',
                value: pagination.value.skipExpired,
                onChanged: (value) {
                  pagination.add(pagination.value..skipExpired = value);
                },
              ),
              br(20),
              DropdownSearchImp<Company>(
                labelText: 'Company',
                hintText: 'Search a company',
                items: companies,
                selectedItem: _selectedCompany,
                itemAsString: (company) => company?.companyName ?? '',
                onChanged: (company) {
                  pagination.add(pagination.value..companyId = company?.companyId);
                },
              ),
              DropdownSearchImp<Degree>(
                labelText: 'Degree',
                hintText: 'Search a degree',
                items: degrees,
                selectedItem: _selectedDegree,
                itemAsString: (degree) => degree?.name ?? '',
                onChanged: (degree) {
                  pagination.value.familyId = null;
                  pagination.value.levelId = null;
                  pagination.add(pagination.value..degreeId = degree?.degreeId);
                  if (degree != null) {
                    setState(() {
                      _familiesEnabled = false;
                      _levelsEnabled = false;
                    });
                  } else {
                    setState(() {
                      _familiesEnabled = true;
                      _levelsEnabled = true;
                      _selectedDegree = null;
                    });
                  }
                },
              ),
              DropdownSearchImp<Family>(
                enabled: _familiesEnabled,
                labelText: 'Family',
                hintText: 'Search a family',
                items: families,
                selectedItem: _selectedFamily,
                itemAsString: (family) => family?.name ?? '',
                onChanged: (familu) {
                  pagination.add(pagination.value..familyId = familu?.familyId);
                },
              ),
              DropdownSearchImp<Level>(
                enabled: _levelsEnabled,
                labelText: 'Level',
                hintText: 'Search a level',
                items: levels,
                selectedItem: _selectedLevel,
                itemAsString: (level) => level?.name ?? '',
                onChanged: (level) {
                  pagination.add(pagination.value..levelId = level?.levelId);
                },
              ),
              Row(
                children: [
                  const Text('€0', style: TextStyle(fontSize: 12)),
                  RangeSlider(
                    values: _salaryRangeValues,
                    max: 10000,
                    divisions: 300,
                    labels: RangeLabels(
                      _salaryRangeValues.start.round().toString(),
                      _salaryRangeValues.end.round().toString(),
                    ),
                    onChanged: (RangeValues values) {
                      setState(() {
                        _salaryRangeValues = values;
                      });
                    },
                  ),
                  const Text('€10k', style: TextStyle(fontSize: 12)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget customCheckbox({
    required String labelText,
    required void Function(bool? value) onChanged,
    bool? value,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white10,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(labelText), //Text
          Checkbox(
            activeColor: Colorz.timerBlue,
            value: value,
            onChanged: onChanged,
          )
        ],
      ),
    );
  }
}
