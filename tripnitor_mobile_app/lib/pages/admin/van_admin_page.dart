import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tripnitor_mobile_app/models/gas_model.dart';
import 'package:tripnitor_mobile_app/models/van_model.dart';
import 'package:tripnitor_mobile_app/pages/admin/forms/van_form.dart';
import 'package:tripnitor_mobile_app/pages/admin/profile/gas_admin_profile.dart';
import 'package:tripnitor_mobile_app/pages/admin/profile/van_admin_profile.dart';
import 'package:tripnitor_mobile_app/providers/van_provider.dart';
import '../../constants/constant.dart';
import 'admin_drawer.dart';

class VanAdminPage extends ConsumerStatefulWidget {
  const VanAdminPage({super.key});

  @override
  ConsumerState<VanAdminPage> createState() => _VanAdminPageState();
}

class _VanAdminPageState extends ConsumerState<VanAdminPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(vanStateProvider.notifier).getAllVans();
    });
  }

  @override
  Widget build(BuildContext context) {
    final vanState = ref.watch(vanStateProvider);
    return Scaffold(
      backgroundColor: Color(ColorConstants.BACKGROUND_COLOR),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight + 1),
        child: AppBar(
          title: Text(
            'Vans',
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
      body: _vanAdminList(vanState),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => VanForm(
                isEditMode: false,
              ),
            ),
          );
        },
        child: Icon(
          Icons.add,
          color: Color(ColorConstants.BACKGROUND_COLOR),
        ),
        backgroundColor: Color(ColorConstants.PRIMARY_COLOR),
      ),
    );
  }

  Widget _vanAdminList(vanState) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 24.0, top: 32),
          child: Row(
            children: [
              Text(
                "Van'\s List",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView.builder(
              itemCount: vanState.vanList?.length ?? 0,
              itemBuilder: (context, index) {
                return _vanBuildCard(context, vanState.vanList![index]);
              },
            ),
          ),
        ),
        SizedBox(
          height: 24,
        ),
        // Padding(
        //   padding: const EdgeInsets.all(8.0),
        //   child: _DriverBuildCard(context),
        // ),
      ],
    );
  }

  Widget _vanBuildCard(BuildContext context, Van van) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => VanAdminProfile(van: van),
          ),
        );
      },
      child: Card(
        color: Color(ColorConstants.TERTIARY_COLOR),
        elevation: 4,
        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Van Model: ${van.model}',
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Type of Gas: ${van.gas.gasName} | ₱${van.gas.gasPrice}',
                    overflow: TextOverflow.ellipsis,
                  ),
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => VanForm(
                                van: van,
                                isEditMode: true,
                              ),
                            ),
                          );
                        },
                        icon: Icon(Icons.edit, color: Colors.green),
                      ),
                      IconButton(
                        onPressed: () async {
                          final result = await showDialog<bool>(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text("Delete Van"),
                                content: Text(
                                    "Are you sure you want to delete this van?"),
                                actions: [
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.of(context).pop(false),
                                    child: Text("Cancel"),
                                  ),
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.of(context).pop(true),
                                    child: Text("Delete"),
                                  ),
                                ],
                              );
                            },
                          );

                          if (result == true) {
                            await ref
                                .read(vanStateProvider.notifier)
                                .deleteVan(van.id);
                          }
                        },
                        icon: Icon(Icons.delete, color: Colors.red),
                      ),
                    ],
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
