import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tripnitor_mobile_app/models/van_model.dart';
import 'package:tripnitor_mobile_app/pages/admin/forms/van_form.dart';
import 'package:tripnitor_mobile_app/pages/admin/profile/van_admin_profile.dart';
import 'package:tripnitor_mobile_app/providers/van_provider.dart';
import '../../core/constants/constant.dart';
import 'admin_drawer.dart';

class CustomModalDialog extends StatelessWidget {
  final String title;
  final String content;
  final VoidCallback onConfirm;
  final Color? color;
  final String buttonText;

  const CustomModalDialog({
    super.key,
    required this.title,
    required this.content,
    required this.onConfirm,
    this.color,
    this.buttonText = 'OK',
  });

  @override
  Widget build(BuildContext context) {
    final dialogColor = color ?? Theme.of(context).colorScheme.primary;

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 0,
      backgroundColor: Color(ColorConstants.BACKGROUND_COLOR),
      child: contentBox(context, dialogColor),
    );
  }

  Widget contentBox(BuildContext context, Color dialogColor) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        color: Color(ColorConstants.BACKGROUND_COLOR),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10.0,
            offset: Offset(0.0, 10.0),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: dialogColor,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 15),
          Text(
            content,
            style: TextStyle(
              fontSize: 14,
              color: Colors.black,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 22),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                style: TextButton.styleFrom(
                  foregroundColor: Colors.grey[600],
                ),
                child: Text(
                  "Cancel",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              SizedBox(width: 8),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  onConfirm();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: dialogColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                ),
                child: Text(
                  buttonText,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class VanAdminPage extends ConsumerStatefulWidget {
  const VanAdminPage({super.key});

  @override
  ConsumerState<VanAdminPage> createState() => _VanAdminPageState();
}

class _VanAdminPageState extends ConsumerState<VanAdminPage> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadVans();
    });
  }

  Future<void> _loadVans() async {
    setState(() {
      _isLoading = true;
    });
    try {
      await ref.read(vanStateProvider.notifier).getAllVans();
    } catch (e) {
      if (mounted) {
        _showSnackBar('Failed to load vans: ${e.toString()}', isError: true);
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        margin: EdgeInsets.all(15),
        duration: Duration(seconds: isError ? 4 : 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final vanState = ref.watch(vanStateProvider);
    final double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Color(ColorConstants.BACKGROUND_COLOR),
      appBar: _buildAppBar(),
      drawer: const AdminDrawer(),
      body: Column(
        children: [
          Expanded(
            child: _isLoading
                ? Center(
                    child: CircularProgressIndicator(
                      color: Color(ColorConstants.PRIMARY_COLOR),
                    ),
                  )
                : _buildVanList(vanState),
          ),
        ],
      ),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  PreferredSize _buildAppBar() {
    return PreferredSize(
      preferredSize: Size.fromHeight(kToolbarHeight + 1),
      child: AppBar(
        title: Text(
          'Vans',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        centerTitle: true,
        backgroundColor: Color(ColorConstants.BACKGROUND_COLOR),
        elevation: 0,
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
    );
  }

  FloatingActionButton _buildFloatingActionButton() {
    return FloatingActionButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => VanForm(isEditMode: false),
          ),
        ).then((_) => _loadVans());
      },
      child: Icon(
        Icons.add,
        color: Color(ColorConstants.BACKGROUND_COLOR),
      ),
      backgroundColor: Color(ColorConstants.PRIMARY_COLOR),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    );
  }

  Widget _buildVanList(vanState) {
    // Check if the list is empty
    if (vanState.vanList == null || vanState.vanList!.isEmpty) {
      return _buildEmptyState();
    }

    return RefreshIndicator(
      onRefresh: _loadVans,
      color: Color(ColorConstants.PRIMARY_COLOR),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(24.0, 16.0, 24.0, 8.0),
            child: Text(
              "Van's List",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(ColorConstants.PRIMARY_COLOR),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: ListView.builder(
                physics: AlwaysScrollableScrollPhysics(),
                itemCount: vanState.vanList?.length ?? 0,
                itemBuilder: (context, index) {
                  return _buildVanCard(context, vanState.vanList![index]);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.directions_car,
            size: 80,
            color: Color(ColorConstants.PRIMARY_COLOR).withOpacity(0.5),
          ),
          SizedBox(height: 16),
          Text(
            'No vans found',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Add a new van using the + button',
            style: TextStyle(
              color: Colors.grey[500],
            ),
          ),
          SizedBox(height: 24),
          ElevatedButton(
            onPressed: _loadVans,
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(ColorConstants.PRIMARY_COLOR),
              foregroundColor: Color(ColorConstants.BACKGROUND_COLOR),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: Text('Refresh'),
          ),
        ],
      ),
    );
  }

  Widget _buildVanCard(BuildContext context, Van van) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Color(ColorConstants.TERTIARY_COLOR),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            offset: Offset(0, 4),
            blurRadius: 12,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => VanAdminProfile(van: van),
              ),
            ).then((_) => _loadVans());
          },
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      backgroundColor:
                          Color(ColorConstants.PRIMARY_COLOR).withOpacity(0.2),
                      radius: 24,
                      child: Icon(
                        Icons.directions_car,
                        color: Color(ColorConstants.PRIMARY_COLOR),
                        size: 24,
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            van.model,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Plate Number: ${van.plateNumber}',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 14,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Color(ColorConstants.PRIMARY_COLOR).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.local_gas_station,
                        color: Colors.black.withOpacity(0.5),
                        size: 16,
                      ),
                      SizedBox(width: 4),
                      Text(
                        '${van.gas?.gasName ?? "N/A"} - ₱${van.gas?.gasPrice ?? "0"}/liter',
                        style: TextStyle(
                          color: Colors.black.withOpacity(0.5),
                          fontWeight: FontWeight.w500,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16),
                Divider(
                  color: Colors.grey[300],
                  thickness: 1,
                ),
                SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    _buildActionButton(
                      icon: Icons.visibility,
                      color: Colors.blue,
                      label: 'View',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => VanAdminProfile(van: van),
                          ),
                        ).then((_) => _loadVans());
                      },
                    ),
                    SizedBox(width: 8),
                    _buildActionButton(
                      icon: Icons.edit,
                      color: Colors.green,
                      label: 'Edit',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => VanForm(
                              van: van,
                              isEditMode: true,
                            ),
                          ),
                        ).then((_) => _loadVans());
                      },
                    ),
                    SizedBox(width: 8),
                    _buildActionButton(
                      icon: Icons.delete,
                      color: Color(ColorConstants.CANCEL_COLOR),
                      label: 'Delete',
                      onTap: () => _showDeleteConfirmation(van),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required Color color,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 16),
            SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showDeleteConfirmation(Van van) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CustomModalDialog(
          title: "Delete Van",
          content:
              "Are you sure you want to delete ${van.model} with plate ${van.plateNumber}?",
          buttonText: "Delete",
          color: Color(ColorConstants.CANCEL_COLOR),
          onConfirm: () async {
            try {
              await ref.read(vanStateProvider.notifier).deleteVan(van.id);
              _showSnackBar('Van deleted successfully');
              _loadVans();
            } catch (error) {
              _showSnackBar('Failed to delete van. Please try again later.',
                  isError: true);
            }
          },
        );
      },
    );
  }
}
