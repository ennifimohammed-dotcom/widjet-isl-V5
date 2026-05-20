import 'package:flutter/material.dart';
import '../models/dhikr.dart';

class AdhkarProvider extends ChangeNotifier {
  List<DhikrCategory> _categories = [];
  int _tasbihCount = 0;
  int _tasbihTarget = 33;
  bool _isVibrating = false;

  List<DhikrCategory> get categories => _categories;
  int get tasbihCount => _tasbihCount;
  int get tasbihTarget => _tasbihTarget;
  bool get isVibrating => _isVibrating;

  void loadAdhkar() {
    _categories = [
      DhikrCategory(
        name: 'Adhkar du Matin',
        iconName: 'wb_sunny',
        description: 'A reciter entre l\'aube et le lever du soleil',
        adhkar: [
          Dhikr(
            text: 'أَعُوذُ بِاللَّهِ مِنَ الشَّيْطَانِ الرَّجِيمِ',
            transliteration: 'A\'oudhou billahi mina sh-shaytani r-rajim',
            translation: 'Je cherche refuge aupres d\'Allah contre Satan le maudit',
            count: 1,
            source: 'Coran',
          ),
          Dhikr(
            text: 'بِسْمِ اللَّهِ الرَّحْمَنِ الرَّحِيمِ\nقُلْ هُوَ اللَّهُ أَحَدٌ',
            transliteration: 'Bismillahi r-Rahmani r-Rahim. Qul huwa Allahu ahad...',
            translation: 'Sourate Al-Ikhlas (Le Monotheisme Pur)',
            count: 3,
            source: 'Sourate 112',
          ),
          Dhikr(
            text: 'بِسْمِ اللَّهِ الرَّحْمَنِ الرَّحِيمِ\nقُلْ أَعُوذُ بِرَبِّ الْفَلَقِ',
            transliteration: 'Qul a\'oudhou bi rabbi l-falaq...',
            translation: 'Sourate Al-Falaq (L\'Aube naissante)',
            count: 3,
            source: 'Sourate 113',
          ),
          Dhikr(
            text: 'بِسْمِ اللَّهِ الرَّحْمَنِ الرَّحِيمِ\nقُلْ أَعُوذُ بِرَبِّ النَّاسِ',
            transliteration: 'Qul a\'oudhou bi rabbi n-nas...',
            translation: 'Sourate An-Nas (Les Hommes)',
            count: 3,
            source: 'Sourate 114',
          ),
          Dhikr(
            text: 'أَصْبَحْنَا وَأَصْبَحَ الْمُلْكُ لِلَّهِ، وَالْحَمْدُ لِلَّهِ، لَا إِلَهَ إِلَّا اللَّهُ وَحْدَهُ لَا شَرِيكَ لَهُ',
            transliteration: 'Asbahnâ wa asbaha-l-mulku lillâh...',
            translation: 'Nous voici au matin et la royaute appartient a Allah...',
            count: 1,
            source: 'Hadith',
          ),
          Dhikr(
            text: 'سُبْحَانَ اللَّهِ وَبِحَمْدِهِ',
            transliteration: 'Subhâna-llâhi wa bi-hamdih',
            translation: 'Gloire et louange a Allah',
            count: 100,
            source: 'Hadith',
          ),
          Dhikr(
            text: 'لَا إِلَهَ إِلَّا اللَّهُ وَحْدَهُ لَا شَرِيكَ لَهُ، لَهُ الْمُلْكُ وَلَهُ الْحَمْدُ وَهُوَ عَلَى كُلِّ شَيْءٍ قَدِيرٌ',
            transliteration: 'Lâ ilâha illâ-llâhu wahdahu lâ sharîka lah...',
            translation: 'Nulle divinite digne d\'etre adoree en dehors d\'Allah...',
            count: 10,
            source: 'Hadith',
          ),
        ],
      ),
      DhikrCategory(
        name: 'Adhkar du Soir',
        iconName: 'nights_stay',
        description: 'A reciter entre le coucher du soleil et la nuit',
        adhkar: [
          Dhikr(
            text: 'أَمْسَيْنَا وَأَمْسَى الْمُلْكُ لِلَّهِ، وَالْحَمْدُ لِلَّهِ',
            transliteration: 'Amsaynâ wa amsâ-l-mulku lillâh...',
            translation: 'Nous voici au soir et la royaute appartient a Allah...',
            count: 1,
            source: 'Hadith',
          ),
          Dhikr(
            text: 'بِسْمِ اللَّهِ الَّذِي لَا يَضُرُّ مَعَ اسْمِهِ شَيْءٌ فِي الْأَرْضِ وَلَا فِي السَّمَاءِ وَهُوَ السَّمِيعُ الْعَلِيمُ',
            transliteration: 'Bismillâhi-lladhî lâ yadurru ma\'a-smihi shay\'un...',
            translation: 'Au nom d\'Allah, Celui dont le nom preserve de tout mal...',
            count: 3,
            source: 'Hadith',
          ),
        ],
      ),
      DhikrCategory(
        name: 'Apres la Priere',
        iconName: 'mosque',
        description: 'Adhkar a reciter apres chaque priere obligatoire',
        adhkar: [
          Dhikr(
            text: 'أَسْتَغْفِرُ اللَّهَ (x3)',
            transliteration: 'Astaghfiru-llâh (x3)',
            translation: 'Je demande pardon a Allah',
            count: 3,
            source: 'Hadith',
          ),
          Dhikr(
            text: 'اللَّهُمَّ أَنْتَ السَّلَامُ وَمِنْكَ السَّلَامُ تَبَارَكْتَ يَا ذَا الْجَلَالِ وَالْإِكْرَامِ',
            transliteration: 'Allâhumma anta-s-salâmu wa minka-s-salâmu...',
            translation: 'O Allah, Tu es la Paix et de Toi vient la paix...',
            count: 1,
            source: 'Hadith',
          ),
          Dhikr(
            text: 'سُبْحَانَ اللَّهِ',
            transliteration: 'Subhâna-llâh',
            translation: 'Gloire a Allah',
            count: 33,
            source: 'Hadith',
            isTasbih: true,
          ),
          Dhikr(
            text: 'الْحَمْدُ لِلَّهِ',
            transliteration: 'Al-hamdu lillâh',
            translation: 'Louange a Allah',
            count: 33,
            source: 'Hadith',
            isTasbih: true,
          ),
          Dhikr(
            text: 'اللَّهُ أَكْبَرُ',
            transliteration: 'Allâhu akbar',
            translation: 'Allah est le Plus Grand',
            count: 34,
            source: 'Hadith',
            isTasbih: true,
          ),
        ],
      ),
      DhikrCategory(
        name: 'Adhkar Quotidiens',
        iconName: 'favorite',
        description: 'Adhkar a reciter tout au long de la journee',
        adhkar: [
          Dhikr(
            text: 'لَا إِلَهَ إِلَّا اللَّهُ',
            transliteration: 'Lâ ilâha illâ-llâh',
            translation: 'Nulle divinite digne d\'etre adoree en dehors d\'Allah',
            count: 100,
            source: 'Hadith',
            isTasbih: true,
          ),
          Dhikr(
            text: 'سُبْحَانَ اللَّهِ وَبِحَمْدِهِ سُبْحَانَ اللَّهِ الْعَظِيمِ',
            transliteration: 'Subhâna-llâhi wa bi-hamdihi, subhâna-llâhi-l-\'azhîm',
            translation: 'Gloire et louange a Allah, Gloire a Allah le Tres Grand',
            count: 100,
            source: 'Hadith',
            isTasbih: true,
          ),
          Dhikr(
            text: 'اللَّهُمَّ صَلِّ عَلَى مُحَمَّدٍ وَعَلَى آلِ مُحَمَّدٍ',
            transliteration: 'Allâhumma salli \'alâ Muhammad wa \'alâ âli Muhammad',
            translation: 'O Allah, prie sur Muhammad et sur la famille de Muhammad',
            count: 10,
            source: 'Hadith',
          ),
          Dhikr(
            text: 'حَسْبُنَا اللَّهُ وَنِعْمَ الْوَكِيلُ',
            transliteration: 'Hasbunâ-llâhu wa ni\'ma-l-wakîl',
            translation: 'Allah nous suffit, et quel excellent Garant !',
            count: 7,
            source: 'Coran 3:173',
          ),
        ],
      ),
    ];
    notifyListeners();
  }

  void incrementTasbih() {
    _tasbihCount++;
    if (_tasbihCount >= _tasbihTarget) {
      _isVibrating = true;
      _tasbihCount = 0;
      Future.delayed(const Duration(milliseconds: 500), () {
        _isVibrating = false;
        notifyListeners();
      });
    }
    notifyListeners();
  }

  void resetTasbih() {
    _tasbihCount = 0;
    _isVibrating = false;
    notifyListeners();
  }

  void setTasbihTarget(int target) {
    _tasbihTarget = target;
    _tasbihCount = 0;
    notifyListeners();
  }

  double get tasbihProgress {
    if (_tasbihTarget == 0) return 0.0;
    return _tasbihCount / _tasbihTarget;
  }
}
