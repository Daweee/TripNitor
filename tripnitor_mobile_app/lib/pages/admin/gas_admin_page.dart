import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tripnitor_mobile_app/models/gas_model.dart';
import 'package:tripnitor_mobile_app/pages/admin/forms/gas_form.dart';
import 'package:tripnitor_mobile_app/pages/admin/profile/gas_admin_profile.dart';
import 'package:tripnitor_mobile_app/providers/gas_provider.dart';
import '../../constants/constant.dart';
import 'admin_drawer.dart';

class GasAdminPage extends ConsumerStatefulWidget {
  const GasAdminPage({super.key});

  @override
  ConsumerState<GasAdminPage> createState() => _GasAdminPageState();
}

class _GasAdminPageState extends ConsumerState<GasAdminPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(gasStateProvider.notifier).getAllGas();
    });
  }

  @override
  Widget build(BuildContext context) {
    final gasState = ref.watch(gasStateProvider);
    return Scaffold(
      backgroundColor: Color(ColorConstants.BACKGROUND_COLOR),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight + 1),
        child: AppBar(
          title: Text(
            'Gas',
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
      body: _gasAdminList(gasState),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => GasForm(),
            ),
          );
        },
        child: Icon(Icons.add),
        backgroundColor: Color(ColorConstants.BACKGROUND_COLOR),
      ),
    );
  }

  Widget _gasAdminList(gasState) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 24.0, top: 32),
          child: Row(
            children: [
              Text(
                "Gas'\s List",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView.builder(
              itemCount: gasState.gasList?.length ?? 0,
              itemBuilder: (context, index) {
                return _gasBuildCard(context, gasState.gasList![index]);
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

  Widget _gasBuildCard(BuildContext context, Gas gas) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => GasAdminProfile(gas: gas),
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
                'Gas ID: ${gas.id}',
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Type of Gas: ${gas.gasName}',
                    overflow: TextOverflow.ellipsis,
                  ),
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //       builder: (context) =>
                          //           DriverProfilePage(driver: driver)),
                          // );
                        },
                        icon: Icon(Icons.edit, color: Colors.green),
                      ),
                      IconButton(
                        onPressed: () async {
                          final result = await showDialog<bool>(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text("Delete Gas"),
                                content: Text(
                                    "Are you sure you want to delete this gas?"),
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
                                .read(gasStateProvider.notifier)
                                .deleteGas(gas.id);
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
