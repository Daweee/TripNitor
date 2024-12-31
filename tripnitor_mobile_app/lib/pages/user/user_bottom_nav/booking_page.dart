import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/constant.dart';
import '../../../providers/booking_provider.dart';
import '../booking_detail_page.dart';
import '../user_booking_detail_page.dart';

class BookingPage extends ConsumerStatefulWidget {
  const BookingPage({super.key});

  @override
  ConsumerState<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends ConsumerState<BookingPage> {
  String _selectedFilter = 'ALL';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(bookingStateProvider.notifier).getUserBookings(_selectedFilter);
    });
  }

  @override
  Widget build(BuildContext context) {
    final bookingState = ref.watch(bookingStateProvider);

    final bookings = bookingState.bookingList;

    return Scaffold(
      backgroundColor: Color(ColorConstants.BACKGROUND_COLOR),
      appBar: AppBar(
        backgroundColor: Color(ColorConstants.BACKGROUND_COLOR),
        title: const Text(
          'Your Bookings',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        scrolledUnderElevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(100.0),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
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
                labelText: 'Filter Status',
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
              value: _selectedFilter,
              onChanged: (String? newValue) {
                setState(() {
                  _selectedFilter = newValue!;
                });
                ref
                    .read(bookingStateProvider.notifier)
                    .getUserBookings(_selectedFilter);
              },
              items: const <String>[
                'ALL',
                'PENDING',
                'CONFIRMED',
                'ONGOING',
              ].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(
                    value,
                    style: TextStyle(color: Colors.black.withOpacity(.5)),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ),
      body: bookingState.isLoading
          ? const Center(child: CircularProgressIndicator())
          : bookings.isEmpty
              ? const Center(child: Text('No bookings found.'))
              : ListView.builder(
                  itemCount: bookings.length,
                  itemBuilder: (context, index) {
                    final booking = bookings[index];
                    try {
                      return InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  UserBookingDetailPage(bookingId: booking.id),
                            ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 24),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${booking.package.packageName}',
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
                                          .format(booking.createdAt),
                                      style: const TextStyle(
                                          color: Colors.black45, fontSize: 12),
                                    ),
                                  ],
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
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
                                      color: _getStatusColor(booking.status),
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
                      return ListTile(title: Text('Error displaying booking'));
                    }
                  },
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
