import '../../../data/models/listed_vehicle.dart';

abstract class ISellRepository {
  Future<List<ListedVehicle>> getListedVehicles();
  Future<ListedVehicle> addListedVehicle(ListedVehicle vehicle);
}
