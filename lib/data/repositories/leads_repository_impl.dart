import 'package:flutter/material.dart';
import '../../core/interfaces/i_leads_repository.dart';
import '../models/lead_model.dart';
import '../models/activity_model.dart';
import '../models/message_model.dart';

class LeadsRepositoryImpl implements ILeadsRepository {
  final List<LeadModel> _leads = [
    LeadModel(
      id: 'l1',
      name: 'John Doe',
      initials: 'JD',
      lastMessage: "I'm interested in the premium plan...",
      time: '2m',
      status: 'hot',
      score: 0.92,
      avatarColor: const Color(0xFF26B14E),
      email: 'john.doe@example.com',
      phone: '+1 (555) 234-5678',
      source: 'CSV Import',
      owner: 'Alex',
      createdDate: 'June 04, 2026',
      messageCount: 12,
      responseRate: 0.83,
      daysActive: 5,
      daysInPipeline: 5,
      bestFollowUpTime: 'Tuesday - Thursday, 10am-2pm',
      aiInsight:
          'John has shown strong buying intent with 3 price-related inquiries. His response speed averages 4 minutes. Best time to follow up is Tuesday-Thursday between 10am-2pm.',
      activities: const [
        ActivityModel(
          id: 'a1_1',
          title: 'Lead created',
          description: '',
          time: '5 days ago',
          icon: Icons.circle,
        ),
        ActivityModel(
          id: 'a1_2',
          title: 'AI welcome sent',
          description: '',
          time: '5 days ago',
          icon: Icons.circle,
        ),
        ActivityModel(
          id: 'a1_3',
          title: 'First reply received',
          description: '',
          time: '4 days ago',
          icon: Icons.circle,
        ),
        ActivityModel(
          id: 'a1_4',
          title: 'Status changed to Hot',
          description: '',
          time: 'Today',
          icon: Icons.circle,
        ),
      ],
      messages: const [
        MessageModel(
          id: 'm1_1',
          text:
              "Hey, I'm interested in your premium plan. Can we schedule a call?",
          time: '10:23 AM',
          isMe: false,
          senderName: 'John Doe',
        ),
        MessageModel(
          id: 'm1_2',
          text:
              "Hi John! I'd love to chat. I'm available tomorrow at 2pm or 4pm EST. Which works for you?",
          time: '10:24 AM',
          isMe: true,
          isSentByAi: true,
        ),
        MessageModel(
          id: 'm1_3',
          text: '2pm works great! Looking forward to it.',
          time: '10:31 AM',
          isMe: false,
          senderName: 'John Doe',
        ),
      ],
      aiSuggestions: const [
        "Hi John! Just checking in — did you have a chance to review the pricing options I sent over? I'd love to help you find the perfect plan for your needs.",
        "Hey John! I noticed you were interested in our premium features. We actually have a limited-time offer running this week — would you like to hear about it?",
        "Hi John, I wanted to make sure you had everything you need to make a decision. Is there anything specific you'd like to know more about?",
      ],
      suggestionTags: const ['Follow-up', 'Promotional', 'Nurturing'],
    ),
    LeadModel(
      id: 'l2',
      name: 'Amy Lin',
      initials: 'AL',
      lastMessage: 'Can you send me more information?',
      time: '20m',
      status: 'hot',
      score: 0.85,
      avatarColor: const Color(0xFF26B14E),
      email: 'amy.lin@example.com',
      phone: '+1 (555) 987-6543',
      source: 'LinkedIn Outreach',
      owner: 'Alex',
      createdDate: 'June 05, 2026',
      messageCount: 8,
      responseRate: 0.75,
      daysActive: 3,
      daysInPipeline: 3,
      bestFollowUpTime: 'Monday - Wednesday, 9am-11am',
      aiInsight:
          'Amy has actively engaged with product materials. Her response speed averages 8 minutes. Best time to follow up is Monday-Wednesday mornings.',
      activities: const [
        ActivityModel(
          id: 'a2_1',
          title: 'Email Sent',
          description: 'Sent product catalog and case studies.',
          time: '30m ago',
          icon: Icons.circle,
        ),
        ActivityModel(
          id: 'a2_2',
          title: 'Outreach Call',
          description: 'Spoke briefly, requested follow-up materials.',
          time: '3h ago',
          icon: Icons.circle,
        ),
      ],
      messages: const [
        MessageModel(
          id: 'm2_1',
          text: "Hi, I'm Amy. I saw your post about CRM solutions.",
          time: '9:00 AM',
          isMe: false,
          senderName: 'Amy Lin',
        ),
        MessageModel(
          id: 'm2_2',
          text:
              'Hello Amy, thanks for reaching out. What tools do you currently use?',
          time: '9:05 AM',
          isMe: true,
          isSentByAi: false,
        ),
        MessageModel(
          id: 'm2_3',
          text: 'Can you send me more information?',
          time: '9:20 AM',
          isMe: false,
          senderName: 'Amy Lin',
        ),
      ],
      aiSuggestions: const [
        'Send product feature comparison deck to Amy.',
        'Offer Amy a 14-day free trial extension.',
        'Ask Amy about her team size and current workflow.',
      ],
      suggestionTags: const ['Follow-up', 'Offer', 'Discovery'],
    ),
    LeadModel(
      id: 'l3',
      name: 'Michael Jordan',
      initials: 'MJ',
      lastMessage: "Let's arrange a contract sign-off.",
      time: '45m',
      status: 'hot',
      score: 0.90,
      avatarColor: const Color(0xFF26B14E),
      email: 'm.jordan@bulls-eye.com',
      phone: '+1 (555) 234-5678',
      source: 'Direct Referral',
      owner: 'Alex',
      createdDate: 'June 03, 2026',
      messageCount: 18,
      responseRate: 0.90,
      daysActive: 7,
      daysInPipeline: 7,
      bestFollowUpTime: 'Wednesday - Friday, 2pm-5pm',
      aiInsight:
          'Michael is at the contract stage with high closing probability. He responds fastest on weekday afternoons.',
      activities: const [
        ActivityModel(
          id: 'a3_1',
          title: 'Lead created',
          description: '',
          time: '7 days ago',
          icon: Icons.circle,
        ),
        ActivityModel(
          id: 'a3_2',
          title: 'Contract Review',
          description: '',
          time: 'Yesterday',
          icon: Icons.circle,
        ),
        ActivityModel(
          id: 'a3_3',
          title: 'Status changed to Hot',
          description: '',
          time: '2 days ago',
          icon: Icons.circle,
        ),
      ],
      messages: const [
        MessageModel(
          id: 'm3_1',
          text: "We've reviewed the proposal. Looks good.",
          time: '11:15 AM',
          isMe: false,
          senderName: 'Michael Jordan',
        ),
        MessageModel(
          id: 'm3_2',
          text:
              "Glad to hear that, Michael! Let me know if you need any adjustments.",
          time: '11:17 AM',
          isMe: true,
          isSentByAi: false,
        ),
        MessageModel(
          id: 'm3_3',
          text: "Let's arrange a contract sign-off.",
          time: '11:30 AM',
          isMe: false,
          senderName: 'Michael Jordan',
        ),
      ],
      aiSuggestions: const [
        'Send Michael the DocuSign contract link.',
        'Confirm the onboarding kickoff date with Michael.',
        'Request billing information from Michael.',
      ],
      suggestionTags: const ['Contract', 'Onboarding', 'Billing'],
    ),
    LeadModel(
      id: 'l4',
      name: 'Sarah Mitchell',
      initials: 'SM',
      lastMessage: 'What packages do you have available?',
      time: '2h',
      status: 'warm',
      score: 0.55,
      avatarColor: const Color(0xFF3B82F6),
      email: 'sarah.m@retailco.com',
      phone: '+1 (555) 876-5432',
      source: 'Inbound Email',
      owner: 'Alex',
      createdDate: 'June 01, 2026',
      messageCount: 5,
      responseRate: 0.55,
      daysActive: 8,
      daysInPipeline: 8,
      bestFollowUpTime: 'Tuesday - Thursday, 11am-1pm',
      aiInsight:
          'Sarah has shown moderate interest. She responds best mid-morning on weekdays.',
      activities: const [
        ActivityModel(
          id: 'a4_1',
          title: 'Email Sent',
          description: 'Sent basic info booklet and pricing link.',
          time: '4h ago',
          icon: Icons.circle,
        ),
      ],
      messages: const [
        MessageModel(
          id: 'm4_1',
          text: 'What packages do you have available?',
          time: '2:15 PM',
          isMe: false,
          senderName: 'Sarah Mitchell',
        ),
      ],
      aiSuggestions: const [
        'Send Sarah the standard pricing leaflet.',
        'Invite Sarah to the weekly webinar session.',
        'Propose a quick 10-minute introduction call with Sarah.',
      ],
      suggestionTags: const ['Pricing', 'Webinar', 'Intro'],
    ),
    LeadModel(
      id: 'l5',
      name: 'Tom Kim',
      initials: 'TK',
      lastMessage: "Sounds good, let's chat next week",
      time: '3h',
      status: 'warm',
      score: 0.48,
      avatarColor: const Color(0xFF3B82F6),
      email: 'tom.kim@startup.io',
      phone: '+1 (555) 345-6789',
      source: 'Product Hunt',
      owner: 'Alex',
      createdDate: 'May 30, 2026',
      messageCount: 4,
      responseRate: 0.45,
      daysActive: 10,
      daysInPipeline: 10,
      bestFollowUpTime: 'Monday - Tuesday, 10am-12pm',
      aiInsight:
          'Tom is open to meeting but not yet committed. A calendar link could accelerate closure.',
      activities: const [
        ActivityModel(
          id: 'a5_1',
          title: 'Met at Meetup',
          description: '',
          time: '3 days ago',
          icon: Icons.circle,
        ),
      ],
      messages: const [
        MessageModel(
          id: 'm5_1',
          text: "Sounds good, let's chat next week",
          time: '1:45 PM',
          isMe: false,
          senderName: 'Tom Kim',
        ),
      ],
      aiSuggestions: const [
        'Set a follow-up reminder for Monday for Tom.',
        'Send Tom a quick calendar meeting link.',
        'Share an onboarding overview guide with Tom.',
      ],
      suggestionTags: const ['Reminder', 'Meeting', 'Nurturing'],
    ),
    LeadModel(
      id: 'l6',
      name: 'Robert Park',
      initials: 'RP',
      lastMessage: "Not sure yet, I'll think about it",
      time: '1d',
      status: 'cold',
      score: 0.30,
      avatarColor: const Color(0xFFEF5744),
      email: 'robert.p@freelance.org',
      phone: '+1 (555) 765-4321',
      source: 'Cold Email',
      owner: 'Alex',
      createdDate: 'May 28, 2026',
      messageCount: 3,
      responseRate: 0.25,
      daysActive: 14,
      daysInPipeline: 14,
      bestFollowUpTime: 'Thursday - Friday, 3pm-5pm',
      aiInsight:
          'Robert is hesitant. A low-pressure nurturing approach is recommended to keep him warm.',
      activities: const [
        ActivityModel(
          id: 'a6_1',
          title: 'Outreach Sent',
          description: '',
          time: '5 days ago',
          icon: Icons.circle,
        ),
      ],
      messages: const [
        MessageModel(
          id: 'm6_1',
          text: "Not sure yet, I'll think about it",
          time: 'Yesterday',
          isMe: false,
          senderName: 'Robert Park',
        ),
      ],
      aiSuggestions: const [
        'Send Robert a low-pressure nurturing email.',
        'Share a product demo recording video with Robert.',
        'Offer Robert a free account tier option.',
      ],
      suggestionTags: const ['Nurturing', 'Demo', 'Offer'],
    ),
    LeadModel(
      id: 'l7',
      name: 'Maria Brown',
      initials: 'MB',
      lastMessage: 'Just browsing, thanks',
      time: '2d',
      status: 'cold',
      score: 0.20,
      avatarColor: const Color(0xFFEF5744),
      email: 'maria.b@personal.me',
      phone: '+1 (555) 456-7890',
      source: 'Web Traffic',
      owner: 'Alex',
      createdDate: 'May 25, 2026',
      messageCount: 2,
      responseRate: 0.15,
      daysActive: 18,
      daysInPipeline: 18,
      bestFollowUpTime: 'Wednesday, 10am-12pm',
      aiInsight:
          'Maria has low engagement. Adding her to a newsletter sequence might re-spark interest.',
      activities: const [
        ActivityModel(
          id: 'a7_1',
          title: 'Pricing Page View',
          description: '',
          time: '3 days ago',
          icon: Icons.circle,
        ),
      ],
      messages: const [
        MessageModel(
          id: 'm7_1',
          text: 'Just browsing, thanks',
          time: '2 days ago',
          isMe: false,
          senderName: 'Maria Brown',
        ),
      ],
      aiSuggestions: const [
        'Add Maria to the monthly newsletter mailing list.',
        'Send Maria a welcome video tutorial.',
        'Share a customer reviews portal link with Maria.',
      ],
      suggestionTags: const ['Newsletter', 'Tutorial', 'Social Proof'],
    ),
  ];

  @override
  Future<List<LeadModel>> getLeads() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return List.from(_leads);
  }

  @override
  Future<LeadModel?> getLeadById(String id) async {
    await Future.delayed(const Duration(milliseconds: 100));
    try {
      return _leads.firstWhere((lead) => lead.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> sendLeadMessage(String leadId, String text) async {
    await Future.delayed(const Duration(milliseconds: 100));
    final index = _leads.indexWhere((lead) => lead.id == leadId);
    if (index != -1) {
      final oldLead = _leads[index];
      final newMsg = MessageModel(
        id: 'm_${DateTime.now().millisecondsSinceEpoch}',
        text: text,
        time: _formatCurrentTime(),
        isMe: true,
        isSentByAi: false,
      );
      final newMessages = List<MessageModel>.from(oldLead.messages)
        ..add(newMsg);
      _leads[index] = oldLead.copyWith(
        messages: newMessages,
        lastMessage: text,
        time: 'Just now',
      );
    }
  }

  @override
  Future<void> addLeadActivity(String leadId, ActivityModel activity) async {
    await Future.delayed(const Duration(milliseconds: 50));
    final index = _leads.indexWhere((lead) => lead.id == leadId);
    if (index != -1) {
      final oldLead = _leads[index];
      final newActivities = List<ActivityModel>.from(oldLead.activities)
        ..insert(0, activity);
      _leads[index] = oldLead.copyWith(activities: newActivities);
    }
  }

  String _formatCurrentTime() {
    final now = DateTime.now();
    final hour = now.hour > 12 ? now.hour - 12 : now.hour;
    final period = now.hour >= 12 ? 'PM' : 'AM';
    final minute = now.minute.toString().padLeft(2, '0');
    return '$hour:$minute $period';
  }
}
