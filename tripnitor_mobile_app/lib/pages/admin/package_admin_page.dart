import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../core/constants/constant.dart';
import '../../models/package_model.dart';
import '../../providers/package_provider.dart';
import 'admin_drawer.dart';
import 'profile/package_admin_profile.dart';

class PackageAdminPage extends ConsumerStatefulWidget {
  const PackageAdminPage({super.key});

  @override
  ConsumerState<PackageAdminPage> createState() => _PackageAdminPageState();
}

class _PackageAdminPageState extends ConsumerState<PackageAdminPage> {
  String? _selectedVisibility;
  final List<String> _visibilityOptions = ['PRIVATE', 'JOINER'];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(packageProvider.notifier).getAllPackages();
    });
  }

  Future<void> _navigateToDetails(String packageId) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PackageAdminProfile(packageId: packageId),
      ),
    );

    if (result == true || result == null) {
      await _refreshData();
    }
  }

  Future<void> _refreshData() async {
    await ref.read(packageProvider.notifier).getAllPackages();
  }

  void _filterByVisibility(String? visibility) {
    ref.read(visibilityFilterProvider.notifier).state = visibility;
  }

  @override
  Widget build(BuildContext context) {
    final packageState = ref.watch(packageProvider);
    final filteredPackages = ref.watch(filteredPackagesProvider);

    return Scaffold(
      backgroundColor: Color(ColorConstants.BACKGROUND_COLOR),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight + 1),
        child: AppBar(
          title: Text(
            'Packages',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
          backgroundColor: Color(ColorConstants.BACKGROUND_COLOR),
          scrolledUnderElevation: 0,
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(1.0),
            child: Divider(
              color: Color(ColorConstants.PRIMARY_COLOR).withOpacity(.3),
              thickness: 1,
              height: 1,
            ),
          ),
        ),
      ),
      drawer: const AdminDrawer(),
      body: Column(
        children: [
          _buildVisibilityFilter(),
          Expanded(
            child: packageState.isLoading
                ? const Center(child: CircularProgressIndicator())
                : filteredPackages.isEmpty
                    ? const Center(child: Text('No packages found.'))
                    : RefreshIndicator(
                        onRefresh: _refreshData,
                        child: ListView.builder(
                          itemCount: filteredPackages.length,
                          itemBuilder: (context, index) {
                            final package = filteredPackages[index];
                            try {
                              return InkWell(
                                onTap: () => _navigateToDetails(package.id),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 24),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              package.packageName,
                                              style: const TextStyle(
                                                fontSize: 18,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              '${package.startLocation.name} -> '
                                              '${package.legs.length > 1 ? '${package.legs.length - 1} itineraries -> ' : ''}'
                                              '${package.finalDestination.name}',
                                              style: const TextStyle(
                                                color: Colors.black54,
                                                fontSize: 12,
                                              ),
                                            ),
                                            // const SizedBox(height: 2),
                                            // Text(
                                            //   DateFormat('d MMM yyyy, h:mm a')
                                            //       .format(
                                            //           package.localCreatedAt!),
                                            //   style: const TextStyle(
                                            //       color: Colors.black45,
                                            //       fontSize: 12),
                                            // ),
                                          ],
                                        ),
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Text(
                                            '₱${package.basePrice}',
                                            style: const TextStyle(
                                              fontSize: 18,
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            package.visibility,
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: _getVisibilityColor(
                                                  package.visibility),
                                              fontSize: 16,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            } catch (e) {
                              return ListTile(
                                  title: Text('Error displaying package'));
                            }
                          },
                        ),
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildVisibilityFilter() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.15,
      padding: const EdgeInsets.all(16),
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
      child: DropdownButtonFormField<String>(
        style: TextStyle(
          color: Colors.black87,
        ),
        isExpanded: true,
        decoration: InputDecoration(
          labelText: 'Filter by Visibility',
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
        value: _selectedVisibility,
        items: [
          DropdownMenuItem<String>(
            value: null,
            child: Text(
              'All Packages',
              style: TextStyle(color: Colors.black.withOpacity(.5)),
            ),
          ),
          ..._visibilityOptions.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(
                value,
                style: TextStyle(color: Colors.black.withOpacity(.5)),
              ),
            );
          }).toList(),
        ],
        onChanged: (String? newValue) {
          setState(() {
            _selectedVisibility = newValue;
          });
          _filterByVisibility(newValue);
        },
      ),
    );
  }

  Color _getVisibilityColor(String visibility) {
    switch (visibility.toUpperCase()) {
      case 'PRIVATE':
        return Color(ColorConstants.PRIMARY_COLOR);
      case 'JOINER':
        return Color(ColorConstants.SUCCESS_COLOR);
      default:
        return Colors.black;
    }
  }
}
