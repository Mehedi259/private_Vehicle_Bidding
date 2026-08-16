import '../../data/models/lead_model.dart';
import '../../data/models/activity_model.dart';

abstract class ILeadsRepository {
  Future<List<LeadModel>> getLeads();
  Future<LeadModel?> getLeadById(String id);
  Future<void> sendLeadMessage(String leadId, String text);
  Future<void> addLeadActivity(String leadId, ActivityModel activity);
}
