import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../core/constants/constant.dart';
import '../../providers/booking_provider.dart';
import 'admin_drawer.dart';
import 'profile/booking_admin_profile.dart';

enum DateFilterOption {
  all,
  lastMonth,
  last3Months,
  last6Months,
  last12Months,
}

final statusFilterProvider = StateProvider<String?>((ref) => null);
final dateFilterProvider =
    StateProvider<DateFilterOption>((ref) => DateFilterOption.all);

class BookingAdminPage extends ConsumerStatefulWidget {
  const BookingAdminPage({super.key});

  @override
  ConsumerState<BookingAdminPage> createState() => _BookingAdminPageState();
}

class _BookingAdminPageState extends ConsumerState<BookingAdminPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(bookingStateProvider.notifier).getAllBookings();
    });
  }

  Future<void> _navigateToDetails(String bookingId) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BookingAdminProfile(bookingId: bookingId),
      ),
    );

    if (result == true || result == null) {
      await _refreshData();
    }
  }

  Future<void> _refreshData() async {
    await ref.read(bookingStateProvider.notifier).getAllBookings();
  }

  List<dynamic> _getFilteredBookings(List<dynamic> bookings) {
    final currentDateFilter = ref.watch(dateFilterProvider);
    final statusFilter = ref.watch(statusFilterProvider);

    List<dynamic> dateFiltered = bookings;
    if (currentDateFilter != DateFilterOption.all) {
      final now = DateTime.now();
      DateTime cutoffDate;

      switch (currentDateFilter) {
        case DateFilterOption.lastMonth:
          cutoffDate = DateTime(now.year, now.month - 1, now.day);
          break;
        case DateFilterOption.last3Months:
          cutoffDate = DateTime(now.year, now.month - 3, now.day);
          break;
        case DateFilterOption.last6Months:
          cutoffDate = DateTime(now.year, now.month - 6, now.day);
          break;
        case DateFilterOption.last12Months:
          cutoffDate = DateTime(now.year - 1, now.month, now.day);
          break;
        default:
          cutoffDate = DateTime(1900);
      }

      dateFiltered = bookings.where((booking) {
        return booking.localCreatedAt != null &&
            booking.localCreatedAt!.isAfter(cutoffDate);
      }).toList();
    }

    if (statusFilter != null) {
      return dateFiltered
          .where((booking) =>
              booking.status.toUpperCase() == statusFilter.toUpperCase())
          .toList();
    }

    return dateFiltered;
  }

  Widget _buildFilters() {
    final double screenHeight = MediaQuery.of(context).size.height;

    return Container(
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
                child: DropdownButtonFormField<DateFilterOption>(
                  style: TextStyle(
                    color: Colors.black87,
                  ),
                  isExpanded: true,
                  decoration: InputDecoration(
                    labelText: 'Date Range',
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
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                  value: ref.watch(dateFilterProvider),
                  onChanged: (value) {
                    if (value != null) {
                      ref.read(dateFilterProvider.notifier).state = value;
                    }
                  },
                  items: [
                    DropdownMenuItem(
                        value: DateFilterOption.all, child: Text('All dates')),
                    DropdownMenuItem(
                        value: DateFilterOption.lastMonth,
                        child: Text('Last month')),
                    DropdownMenuItem(
                        value: DateFilterOption.last3Months,
                        child: Text('Last 3 months')),
                    DropdownMenuItem(
                        value: DateFilterOption.last6Months,
                        child: Text('Last 6 months')),
                    DropdownMenuItem(
                        value: DateFilterOption.last12Months,
                        child: Text('Last 12 months')),
                  ],
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: DropdownButtonFormField<String?>(
                  style: TextStyle(color: Colors.black87),
                  isExpanded: true,
                  decoration: InputDecoration(
                    labelText: 'Status',
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
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                  value: ref.watch(statusFilterProvider),
                  onChanged: (value) =>
                      ref.read(statusFilterProvider.notifier).state = value,
                  items: [
                    'PENDING',
                    'CONFIRMED',
                    'ONGOING',
                    'COMPLETED',
                    'CANCELLED',
                    null
                  ]
                      .map((status) => DropdownMenuItem(
                          value: status,
                          child: Text(
                            status ?? 'All Statuses',
                            style: TextStyle(
                                color: status != null
                                    ? _getStatusColor(status)
                                    : Colors.black.withOpacity(.5)),
                          )))
                      .toList(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bookingState = ref.watch(bookingStateProvider);
    final allBookings = bookingState.bookingList;
    final filteredBookings = _getFilteredBookings(allBookings);

    return Scaffold(
      backgroundColor: Color(ColorConstants.BACKGROUND_COLOR),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight + 1),
        child: AppBar(
          title: Text(
            'Bookings',
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
          _buildFilters(),
          Expanded(
            child: RefreshIndicator(
              triggerMode: RefreshIndicatorTriggerMode.onEdge,
              color: Color(ColorConstants.BACKGROUND_COLOR),
              backgroundColor: Color(ColorConstants.PRIMARY_COLOR),
              onRefresh: () async {
                await _refreshData();
              },
              child: bookingState.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : filteredBookings.isEmpty
                      ? Center(
                          child: Text(
                              'No bookings found with the selected filters.'))
                      : ListView.builder(
                          itemCount: filteredBookings.length,
                          itemBuilder: (context, index) {
                            final booking = filteredBookings[index];
                            try {
                              return InkWell(
                                onTap: () => _navigateToDetails(booking.id),
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
                                              booking.package.packageName,
                                              style: const TextStyle(
                                                fontSize: 18,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              '${booking.package.startLocation.name} -> '
                                              '${booking.package.legs.length - 1 > 0 ? '${booking.package.legs.length - 1} itineraries -> ' : ''}'
                                              '${booking.package.finalDestination.name}',
                                              style: const TextStyle(
                                                color: Colors.black54,
                                                fontSize: 12,
                                              ),
                                            ),
                                            const SizedBox(height: 2),
                                            Text(
                                              DateFormat('d MMM yyyy, h:mm a')
                                                  .format(
                                                      booking.localCreatedAt!),
                                              style: const TextStyle(
                                                  color: Colors.black45,
                                                  fontSize: 12),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Text(
                                            '₱${booking.totalPrice}',
                                            style: const TextStyle(
                                              fontSize: 18,
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            booking.status,
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: _getStatusColor(
                                                  booking.status),
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
                                  title: Text('Error displaying booking'));
                            }
                          },
                        ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toUpperCase()) {
      case 'PENDING':
        return Color(ColorConstants.ACCENT_COLOR);
      case 'CONFIRMED':
        return Color(ColorConstants.PRIMARY_COLOR);
      case 'ONGOING':
        return Color(ColorConstants.SUCCESS_COLOR);
      case 'CANCELLED':
        return Color(ColorConstants.ERROR_COLOR);
      case 'COMPLETED':
        return Colors.blue;
      default:
        return Colors.black;
    }
  }
}
