import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tripnitor_mobile_app/constants/constant.dart';
import 'package:tripnitor_mobile_app/widgets/package_card.dart';
import '../providers/package_provider.dart';

class PackagePage extends ConsumerStatefulWidget {
  const PackagePage({Key? key}) : super(key: key);

  @override
  ConsumerState<PackagePage> createState() => _PackagePageState();
}

class _PackagePageState extends ConsumerState<PackagePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
        print('Fetching packages in initState...');
      ref.read(packageProvider.notifier).getAllPackages();
    });
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Color(ColorConstants.BACKGROUND_COLOR),
      appBar: AppBar(
        leading: IconButton(
            icon: FaIcon(
                FontAwesomeIcons.angleLeft, 
                color: Colors.black,
                size: 20.0,
            ),
            onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: Color(ColorConstants.BACKGROUND_COLOR),
        title: Text('Package Trips', 
          style: TextStyle(
            fontWeight: FontWeight.bold,
            ),
          ),
        centerTitle: true,
        scrolledUnderElevation: 0,
      ),
      body: Column(
        children: [
          Container(
            height: screenHeight * 0.15,
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(30.0),
                    bottomLeft: Radius.circular(30.0),
                ),
                color: Color(ColorConstants.BACKGROUND_COLOR),
                boxShadow: <BoxShadow>[
                    BoxShadow(
                        color: Color(0xFF000000).withOpacity(.1),
                        offset: Offset(0, 4),
                        blurRadius: 4,
                    ),
                ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        style: TextStyle(
                            color: Colors.black87,
                            ),
                        isExpanded: true,
                        decoration: InputDecoration(
                          labelText: 'Package Type',
                          labelStyle: TextStyle(color: Colors.black.withOpacity(.5)),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(
                                color: Color(ColorConstants.PRIMARY_COLOR),
                                ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(
                                color: Color(ColorConstants.SECONDARY_COLOR), 
                                width: 2,
                                ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(
                                color: Color(ColorConstants.PRIMARY_COLOR), 
                                width: 2,
                                ),
                          ),
                          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        ),
                        value: ref.watch(packageTypeFilterProvider),
                        onChanged: (value) => ref.read(packageTypeFilterProvider.notifier).state = value,
                        items: ['SOUTH', 'NORTH', 'CITY', null]
                            .map((type) => DropdownMenuItem(value: type, child: Text(type ?? 'All Types', style: TextStyle(color: Colors.black.withOpacity(.5)),)))
                            .toList(),
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        style: TextStyle(color: Colors.black87),
                        isExpanded: true,
                        decoration: InputDecoration(
                          labelText: 'Visibility',
                          labelStyle: TextStyle(
                            color: Colors.black.withOpacity(.5),
                            ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(
                                color: Color(ColorConstants.PRIMARY_COLOR),
                                ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(
                                color: Color(ColorConstants.SECONDARY_COLOR), 
                                width: 2,
                                ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(
                                color: Color(ColorConstants.PRIMARY_COLOR), 
                                width: 2,
                                ),
                          ),
                          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        ),
                        value: ref.watch(visibilityFilterProvider),
                        onChanged: (value) => ref.read(visibilityFilterProvider.notifier).state = value,
                        items: ['PRIVATE', 'PUBLIC', null]
                            .map((visibility) => DropdownMenuItem(value: visibility, child: Text(visibility ?? 'All Visibilities', style: TextStyle(color: Colors.black.withOpacity(.5)),)))
                            .toList(),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              triggerMode: RefreshIndicatorTriggerMode.onEdge,
              color: Color(ColorConstants.BACKGROUND_COLOR),
              backgroundColor: Color(ColorConstants.PRIMARY_COLOR),
              onRefresh: () async {
                await ref.read(packageProvider.notifier).getAllPackages();
              },
              child: PackageCard(),
            ),
          ),
        ],
      ),
    );
  }
}