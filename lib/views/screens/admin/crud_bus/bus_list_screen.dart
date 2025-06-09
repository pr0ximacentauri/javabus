import 'package:flutter/material.dart';
import 'package:javabus/views/screens/admin/crud_bus/bus_create_screen.dart';
import 'package:javabus/views/screens/admin/crud_bus/bus_update_screen.dart';
import 'package:provider/provider.dart';
import 'package:javabus/models/bus.dart';
import 'package:javabus/viewmodels/bus_view_model.dart';

class BusListScreen extends StatefulWidget {
  const BusListScreen({super.key});

  @override
  State<BusListScreen> createState() => _BusListScreenState();
}

class _BusListScreenState extends State<BusListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<BusViewModel>(context, listen: false).fetchBuses();
    });
  }

  void _navigateToCreate() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => const BusCreateScreen()));
  }

  void _navigateToUpdate(Bus bus) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => BusUpdateScreen(bus: bus)));
  }

  void _delete(int id) async {
    final busVM = Provider.of<BusViewModel>(context, listen: false);
    final success = await busVM.deleteBus(id);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(success ? 'Bus dihapus' : 'Gagal hapus bus')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<BusViewModel>(
      builder: (context, viewModel, _) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Data Bus'),
            actions: [
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: _navigateToCreate,
              ),
            ],
          ),
          body: viewModel.isLoading
              ? const Center(child: CircularProgressIndicator())
              : viewModel.msg != null
                  ? Center(child: Text(viewModel.msg!))
                  : ListView.builder(
                      itemCount: viewModel.buses.length,
                      itemBuilder: (context, index) {
                        final bus = viewModel.buses[index];
                        return ListTile(
                          title: Text('${bus.name} (${bus.busClass})'),
                          subtitle: Text('ID: ${bus.id}'),
                          trailing: PopupMenuButton<String>(
                            onSelected: (value) {
                              if (value == 'edit') {
                                _navigateToUpdate(bus);
                              } else if (value == 'delete') {
                                _delete(bus.id);
                              }
                            },
                            itemBuilder: (context) => [
                              const PopupMenuItem(value: 'edit', child: Text('Update')),
                              const PopupMenuItem(value: 'delete', child: Text('Delete')),
                            ],
                          ),
                        );
                      },
                    ),
        );
      },
    );
  }
}
