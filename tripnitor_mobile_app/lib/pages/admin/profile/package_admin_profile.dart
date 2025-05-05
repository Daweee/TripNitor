import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../core/constants/constant.dart';
import '../../../models/package_model.dart';
import '../../../models/package_user_model.dart';
import '../../../providers/package_provider.dart';
import '../../../widgets/custom_modal_dialogue.dart';

class PackageAdminProfile extends ConsumerStatefulWidget {
  final String packageId;

  PackageAdminProfile({
    super.key,
    required this.packageId,
  });

  @override
  ConsumerState<PackageAdminProfile> createState() =>
      _PackageAdminProfileState();
}

class _PackageAdminProfileState extends ConsumerState<PackageAdminProfile> {
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    Future.microtask(() => _loadPackageDetails());
  }

  Future<void> _loadPackageDetails() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await ref
          .read(packageProvider.notifier)
          .getPackageDetails(widget.packageId);
      if (mounted) {
        await ref
            .read(packageProvider.notifier)
            .getJoinerUsers(widget.packageId);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load package details: $e')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final packageState = ref.watch(packageProvider);
    final package = packageState.selectedPackage;
    final joiners = packageState.packageJoiners;

    return Scaffold(
      backgroundColor: Color(ColorConstants.BACKGROUND_COLOR),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight + 1),
        child: AppBar(
          title: Text(
            'Package Details',
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
      body: _isLoading || package == null
          ? Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadPackageDetails,
              child: SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildPackageHeader(package),
                      const SizedBox(height: 24),
                      _buildInfoCard(
                        title: 'Package Information',
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildInfoRow('Name', package.packageName),
                            _buildInfoRow('Type', package.packageType),
                            _buildInfoRow('Visibility', package.visibility),
                            _buildInfoRow('Price', '₱${package.basePrice}'),
                            if (package.currentParticipants != null)
                              _buildInfoRow('Current Joiners',
                                  '${package.currentParticipants}'),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildInfoCard(
                        title: 'Travel Details',
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildInfoRow(
                                'Start Location', package.startLocation.name),
                            _buildInfoRow('Final Destination',
                                package.finalDestination.name),
                            _buildInfoRow(
                              'Itineraries',
                              package.legs.length > 1
                                  ? '${package.legs.length - 1} stops'
                                  : 'Direct trip',
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildItineraries(package),
                      const SizedBox(height: 16),
                      if (package.visibility.toUpperCase() == 'JOINER' &&
                          joiners != null)
                        _buildJoiners(joiners),
                      const SizedBox(height: 40),
                      if (package.visibility.toUpperCase() == 'JOINER' &&
                          !package.isConfirmed)
                        _confirmPackageButton(package),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  Widget _confirmPackageButton(Package package) {
    void _showConfirmationDialog(BuildContext context) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return CustomModalDialog(
            title: 'Confirm Package',
            content:
                'Are you sure you want to confirm all bookings for this package?',
            onConfirm: () async {
              // provider method

              // reload after call
              if (mounted) {
                _loadPackageDetails();
              }
            },
            color: Color(ColorConstants.PRIMARY_COLOR),
            buttonText: 'Confirm',
          );
        },
      );
    }

    return SizedBox(
      width: double.infinity,
      height: 45,
      child: ElevatedButton(
        onPressed: () => _showConfirmationDialog(context),
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(ColorConstants.PRIMARY_COLOR),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
        child: Text(
          'Confirm all bookings',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  Widget _buildPackageHeader(Package package) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  package.packageName,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color:
                      _getVisibilityColor(package.visibility).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  package.visibility,
                  style: TextStyle(
                    color: _getVisibilityColor(package.visibility),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          if (package.description != null &&
              package.description!.isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(
              package.description!,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[700],
              ),
            ),
          ],
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (package.visibility.toUpperCase() == 'JOINER' &&
                  package.startDate != null &&
                  package.endDate != null)
                Expanded(
                  child: Row(
                    children: [
                      Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                      const SizedBox(width: 4),
                      Flexible(
                        child: Text(
                          '${DateFormat('d MMM yyyy').format(package.startDate!)} - ${DateFormat('d MMM yyyy').format(package.endDate!)}',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[700],
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                )
              else
                Spacer(),
              if (package.isConfirmed)
                Text(
                  'Confirmed',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(ColorConstants.PRIMARY_COLOR),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard({required String title, required Widget child}) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItineraries(Package package) {
    return _buildInfoCard(
      title: 'Itineraries',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(ColorConstants.PRIMARY_COLOR),
                  ),
                  child: Center(
                    child: Text(
                      '1',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        package.startLocation.name,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        'Starting Point',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[700],
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: package.legs.length,
            itemBuilder: (context, index) {
              final leg = package.legs[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(ColorConstants.PRIMARY_COLOR),
                      ),
                      child: Center(
                        child: Text(
                          '${index + 2}',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            leg.endLocation.name,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          if (index == package.legs.length - 1)
                            Text(
                              'Final Destination',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[700],
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildJoiners(List<PackageUser> joiners) {
    return _buildInfoCard(
      title: 'Joiners',
      child: joiners.isEmpty
          ? Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Center(
                child: Text(
                  'No joiners yet',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            )
          : ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: joiners.length,
              itemBuilder: (context, index) {
                final joiner = joiners[index];
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: CircleAvatar(
                    backgroundColor:
                        Color(ColorConstants.PRIMARY_COLOR).withOpacity(0.2),
                    child: Text(
                      joiner.user.name.substring(0, 1).toUpperCase(),
                      style: TextStyle(
                        color: Color(ColorConstants.PRIMARY_COLOR),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  title: Text(
                    joiner.user.name,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  subtitle: Text(
                    'Joined on ${DateFormat('d MMM yyyy').format(joiner.localCreatedAt!)}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                  trailing: Text(
                    joiner.numberOfPassengers > 1
                        ? '${joiner.numberOfPassengers} people'
                        : '1 person',
                    style: TextStyle(
                      color: Color(ColorConstants.PRIMARY_COLOR),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                );
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
