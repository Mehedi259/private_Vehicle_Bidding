import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:private_vehicle_bidding/core/interfaces/i_sell_repository.dart';
import 'package:private_vehicle_bidding/data/models/listed_vehicle.dart';
import 'package:private_vehicle_bidding/modules/sell/controllers/add_vehicle_controller.dart';
import 'package:private_vehicle_bidding/modules/sell/controllers/sell_controller.dart';

class MockSellRepository implements ISellRepository {
  final List<ListedVehicle> vehicles = [];

  @override
  Future<List<ListedVehicle>> getListedVehicles() async {
    return vehicles;
  }

  @override
  Future<ListedVehicle> addListedVehicle(ListedVehicle vehicle) async {
    vehicles.add(vehicle);
    return vehicle;
  }
}

class FakeBuildContext extends Fake implements BuildContext {
  @override
  bool get mounted => false;
}

void main() {
  late MockSellRepository mockSellRepo;
  late SellController sellController;
  late AddVehicleController addVehicleController;
  final context = FakeBuildContext();

  setUp(() {
    Get.reset();
    
    mockSellRepo = MockSellRepository();
    sellController = Get.put(SellController(mockSellRepo));
    addVehicleController = Get.put(AddVehicleController());
  });

  group('AddVehicleController Test Suite', () {
    test('Initializes with default step 1 and Car category', () {
      expect(addVehicleController.currentStep.value, equals(1));
      expect(addVehicleController.selectedCategory.value, equals('Car'));
    });

    test('Sets category successfully', () {
      addVehicleController.setCategory('Motorcycle');
      expect(addVehicleController.selectedCategory.value, equals('Motorcycle'));
      
      addVehicleController.setCategory('Truck');
      expect(addVehicleController.selectedCategory.value, equals('Truck'));
    });

    test('Validates required Step 1 fields correctly', () {
      // Initially, required fields are empty, validation should fail
      expect(addVehicleController.validateStep1(), isFalse);

      // Fill in all required fields
      addVehicleController.makeController.text = 'Tesla';
      addVehicleController.modelController.text = 'Model Y';
      addVehicleController.yearController.value = '2023';
      addVehicleController.mileageController.text = '15000';
      addVehicleController.vinController.text = '1YV1234567890';
      addVehicleController.transmissionController.text = 'Automatic';
      addVehicleController.fuelTypeController.text = 'Electric';
      addVehicleController.titleStatusController.value = 'Clean';

      // Validation should now pass
      expect(addVehicleController.validateStep1(), isTrue);
    });

    test('Step transitions: nextStep increments and previousStep decrements', () {
      // Step 1 fails to go to Step 2 if fields are invalid
      addVehicleController.nextStep(context);
      expect(addVehicleController.currentStep.value, equals(1));

      // Fill in fields to make Step 1 valid
      addVehicleController.makeController.text = 'Tesla';
      addVehicleController.modelController.text = 'Model Y';
      addVehicleController.yearController.value = '2023';
      addVehicleController.mileageController.text = '15000';
      addVehicleController.vinController.text = '1YV1234567890';
      addVehicleController.transmissionController.text = 'Automatic';
      addVehicleController.fuelTypeController.text = 'Electric';
      addVehicleController.titleStatusController.value = 'Clean';

      // Next step should go to Step 2
      addVehicleController.nextStep(context);
      expect(addVehicleController.currentStep.value, equals(2));

      // Step 2 fails to go to Step 3 if description is empty
      addVehicleController.descriptionController.clear();
      addVehicleController.nextStep(context);
      expect(addVehicleController.currentStep.value, equals(2));

      // Fill description to make Step 2 valid
      addVehicleController.descriptionController.text = 'A premium electric crossover with low mileage.';
      addVehicleController.nextStep(context);
      expect(addVehicleController.currentStep.value, equals(3));

      // Step 3 fails to go to Step 4 if starting bid is empty or invalid
      addVehicleController.startingBidController.clear();
      addVehicleController.nextStep(context);
      expect(addVehicleController.currentStep.value, equals(3));

      addVehicleController.startingBidController.text = 'invalid_number';
      addVehicleController.nextStep(context);
      expect(addVehicleController.currentStep.value, equals(3));

      // Fill valid starting bid
      addVehicleController.startingBidController.text = '18,000';
      addVehicleController.nextStep(context);
      expect(addVehicleController.currentStep.value, equals(4));

      // Step 4 validation fails if required fields are empty
      addVehicleController.stateController.clear();
      addVehicleController.nextStep(context);
      expect(addVehicleController.currentStep.value, equals(4));

      // Fill location fields to pass Step 4
      addVehicleController.stateController.text = 'Dubai';
      addVehicleController.cityController.text = 'Al Aweer';
      addVehicleController.zipCodeController.text = '7025';
      addVehicleController.nextStep(context);
      expect(addVehicleController.currentStep.value, equals(5));

      // Go back to Step 4
      addVehicleController.previousStep(context);
      expect(addVehicleController.currentStep.value, equals(4));
    });

    test('Submits form and adds listed vehicle to SellController with parsed starting bid price', () async {
      // Setup valid Step 1 data
      addVehicleController.makeController.text = 'Ford';
      addVehicleController.modelController.text = 'F-150';
      addVehicleController.yearController.value = '2022';
      addVehicleController.mileageController.text = '30000';
      addVehicleController.vinController.text = '1FT1234567890';
      addVehicleController.transmissionController.text = 'Automatic';
      addVehicleController.fuelTypeController.text = 'Gasoline';
      addVehicleController.titleStatusController.value = 'Clean';
      
      // Setup valid Step 2 data
      addVehicleController.descriptionController.text = 'Tough, reliable pickup truck.';

      // Setup valid Step 3 data
      addVehicleController.startingBidController.text = '24,500';
      addVehicleController.buyNowPriceController.text = '28,000';

      // Advance to Step 5
      addVehicleController.currentStep.value = 5;

      // Submit
      await addVehicleController.submitForm(context);

      // Check if it added to SellController's listed vehicles
      expect(sellController.listedVehicles.length, equals(1));
      
      final addedVehicle = sellController.listedVehicles.first;
      expect(addedVehicle.title, equals('2022 Ford F-150'));
      expect(addedVehicle.status, equals(VehicleStatus.active));
      expect(addedVehicle.lastBid, equals(24500.0));
      expect(addedVehicle.buyNowPrice, equals(28000.0));
    });

    test('Step 5 Collapsible Summaries: toggleSummary updates expansion state correctly', () {
      expect(addVehicleController.expandedSummaries[0], isFalse);
      expect(addVehicleController.expandedSummaries[1], isFalse);
      expect(addVehicleController.expandedSummaries[2], isFalse);
      expect(addVehicleController.expandedSummaries[3], isFalse);

      addVehicleController.toggleSummary(0);
      expect(addVehicleController.expandedSummaries[0], isTrue);
      expect(addVehicleController.expandedSummaries[1], isFalse);

      addVehicleController.toggleSummary(2);
      expect(addVehicleController.expandedSummaries[2], isTrue);

      addVehicleController.toggleSummary(0);
      expect(addVehicleController.expandedSummaries[0], isFalse);
    });
  });
}
