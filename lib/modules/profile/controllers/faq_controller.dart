import 'package:get/get.dart';
import '../../../data/models/faq_model.dart';

class FaqController extends GetxController {
  final List<FaqModel> faqs = const [
    FaqModel(
      question: 'What is this platform about?',
      answer: 'This platform is a premium vehicle bidding and auction service where you can list your vehicle or place bids on active car, motorcycle, truck, and boat listings in real time.',
    ),
    FaqModel(
      question: 'Is the app free to use?',
      answer: 'Yes, downloading and browsing the vehicle listings is completely free. Fees are only applicable when you list a vehicle or win an auction.',
    ),
    FaqModel(
      question: 'What are the available subscription options?',
      answer: 'We offer standard bidding for free, and special dealer plans with advanced bidding analytics, automated bidding agents, and priority support.',
    ),
    FaqModel(
      question: 'Can I watch live bidding updates?',
      answer: 'Yes! All auctions show active, live bidding progress and updates instantly so you never miss out on your favorite vehicle.',
    ),
  ];
}
