import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/services/api_service.dart';
import '../../../core/utils/snackbar_helper.dart';
import '../../../data/models/payment_method_model.dart';

class PaymentMethodsController extends GetxController {
  final RxList<PaymentMethodModel> cards = <PaymentMethodModel>[].obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchCards();
  }

  Future<void> fetchCards() async {
    isLoading.value = true;
    try {
      final response = await ApiService.get('/api/payments/methods/my-cards/', requireAuth: true);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List<dynamic> cardsData = data['cards'] ?? [];
        cards.value = cardsData.map((c) => PaymentMethodModel.fromJson(c)).toList();
      } else {
        SnackbarHelper.showError('Failed to load cards. Error: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error fetching cards: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addTestCard() async {
    isLoading.value = true;
    try {
      final response = await ApiService.post('/api/payments/methods/add-test-card/', {}, requireAuth: true);
      if (response.statusCode == 201) {
        SnackbarHelper.showSuccess('Test card added successfully!');
        await fetchCards();
      } else {
        SnackbarHelper.showError('Failed to add test card. Error: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error adding test card: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> removeCard(int id) async {
    try {
      final response = await ApiService.delete('/api/payments/methods/remove/$id/', null, requireAuth: true);
      if (response.statusCode == 204 || response.statusCode == 200) {
        cards.removeWhere((element) => element.id == id);
        SnackbarHelper.showSuccess('Card removed successfully');
      } else {
        SnackbarHelper.showError('Failed to remove card. Error: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error removing card: $e');
    }
  }
}
