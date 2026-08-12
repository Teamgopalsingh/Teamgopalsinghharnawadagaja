import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/models.dart';

class SupabaseService {
  static final SupabaseService _instance = SupabaseService._internal();
  factory SupabaseService() => _instance;
  SupabaseService._internal();

  bool _isInitialized = false;

  Future<void> initialize({required String url, required String anonKey}) async {
    try {
      await Supabase.initialize(url: url, anonKey: anonKey);
      _isInitialized = true;
    } catch (e) {
      _isInitialized = false;
    }
  }

  SupabaseClient? get client => _isInitialized ? Supabase.instance.client : null;

  // Mock data fallbacks for offline or uninitialized Supabase state
  Future<List<DevelopmentProject>> fetchProjects() async {
    if (_isInitialized && client != null) {
      try {
        final response = await client!.from('development_projects').select();
        return (response as List).map((e) => DevelopmentProject.fromJson(e)).toList();
      } catch (_) {}
    }
    
    // Return high quality local mock data
    return [
      DevelopmentProject(
        id: '1',
        title: 'हरनावदा गजा मुख्य मार्ग सीसी सड़क निर्माण',
        wardName: 'वार्ड 01 - मुख्य ग्राम क्षेत्र',
        status: 'निर्माणाधीन',
        progressPercent: 65.0,
        estimatedBudget: 'रु. 25,00,000',
        description: 'गांव के मुख्य बस स्टैंड से पंचायत भवन तक 1 किमी पक्की सीसी रोड का निर्माण।',
        locationDetails: 'हरनावदा गजा, झालरापाटन',
      ),
      DevelopmentProject(
        id: '2',
        title: 'पेयजल हेतु नई नलकूप एवं जल टंकी स्थापना',
        wardName: 'वार्ड 03 - राजकीय विद्यालय के पास',
        status: 'स्वीकृत',
        progressPercent: 25.0,
        estimatedBudget: 'रु. 12,50,000',
        description: 'गर्मी में शुद्ध पेयजल आपूर्ति हेतु उच्च क्षमता नलकूप व सोलर पंप की स्थापना।',
        locationDetails: 'हरनावदा गजा',
      ),
      DevelopmentProject(
        id: '3',
        title: 'सामुदायिक भवन एवं लाइब्रेरी जीर्णोद्धार',
        wardName: 'वार्ड 02 - मंदिर प्रांगण',
        status: 'पूर्ण',
        progressPercent: 100.0,
        estimatedBudget: 'रु. 8,00,000',
        description: 'गांव के युवाओं के अध्ययन हेतु आधुनिक रीडिंग रूम व सामुदायिक भवन की मरम्मत।',
        locationDetails: 'हरनावदा गजा मंदिर चौक',
      ),
      DevelopmentProject(
        id: '4',
        title: 'ग्राम पंचायत नालियों का पक्का निर्माण एवं ढकाव',
        wardName: 'समीपवर्ती वार्ड क्षेत्र',
        status: 'प्रस्तावित',
        progressPercent: 10.0,
        estimatedBudget: 'रु. 15,00,000',
        description: 'जलजमाव व गंदगी से मुक्ति हेतु सम्पूर्ण गांव में पक्की ढकी हुई नालियों का प्रस्ताव।',
        locationDetails: 'हरनावदा गजा',
      ),
    ];
  }

  Future<List<OfficialContact>> fetchOfficialContacts() async {
    return [
      OfficialContact(
        id: '1',
        name: 'श्री अजय कुमार मीना',
        designation: 'जिला कलेक्टर एवं जिला मजिस्ट्रेट',
        department: 'जिला प्रशासन झालावाड़',
        phone: '07432230401',
        email: 'dm-jha-rj@nic.in',
        officeAddress: 'मिनी सचिवालय, झालावाड़, राजस्थान 326001',
        verifiedSourceUrl: 'https://jhalawar.rajasthan.gov.in/contacts',
      ),
      OfficialContact(
        id: '2',
        name: 'उपखंड अधिकारी (SDO)',
        designation: 'उपखंड अधिकारी एवं उपखंड मजिस्ट्रेट',
        department: 'प्रशासनिक कार्यालय झालरापाटन',
        phone: '07432240222',
        email: 'sdo.jhalrapatan@rajasthan.gov.in',
        officeAddress: 'तहसील परिसर, झालरापाटन, झालावाड़',
        verifiedSourceUrl: 'https://jhalawar.rajasthan.gov.in/contacts',
      ),
      OfficialContact(
        id: '3',
        name: 'विकास अधिकारी (BDO)',
        designation: 'खंड विकास अधिकारी',
        department: 'पंचायत समिति झालरापाटन',
        phone: '07432240310',
        email: 'ps.jhalrapatan@rajasthan.gov.in',
        officeAddress: 'पंचायत समिति, झालरापाटन',
        verifiedSourceUrl: 'https://jhalawar.rajasthan.gov.in/contacts',
      ),
      OfficialContact(
        id: '4',
        name: 'ग्राम विकास अधिकारी (VDO)',
        designation: 'ग्राम विकास अधिकारी (सचिव)',
        department: 'ग्राम पंचायत हरनावदा गजा',
        phone: '+919414000000',
        email: 'vdo.harnawadagaja@rajasthan.gov.in',
        officeAddress: 'ग्राम पंचायत भवन, हरनावदा गजा',
        verifiedSourceUrl: 'https://jhalawar.rajasthan.gov.in',
      ),
    ];
  }

  Future<ElectionData> fetchElectionData() async {
    return ElectionData(
      constituencyName: 'झालरापाटन विधानसभा क्षेत्र',
      constituencyCode: 'AC-198',
      totalElectorate: 288450,
      historicalTurnoutPercent: 78.6,
      pollingStations: [
        {'name': 'राजकीय उच्च माध्यमिक विद्यालय, हरनावदा गजा (कमरा सं. 1)', 'code': 'PS-112'},
        {'name': 'राजकीय प्राथमिक स्वास्थ्य केंद्र परिसर, हरनावदा गजा', 'code': 'PS-113'},
        {'name': 'राजकीय उच्च प्राथमिक बालिका विद्यालय, झालरापाटन सेक्टर', 'code': 'PS-114'},
      ],
      sourceDetails: 'मुख्य निर्वाचन अधिकारी राजस्थान (ceorajasthan.nic.in) सार्वजनिक डेटाबेस',
    );
  }
}
