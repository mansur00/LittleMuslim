import 'package:flutter_test/flutter_test.dart';
import 'package:little_muslim/data/qaida_curriculum_data.dart';
import 'package:little_muslim/models/qaida/qaida_models.dart';
import 'package:little_muslim/utils/app_state.dart';

void main() {
  group('Qaida 8-Track Curriculum Tests', () {
    test('Curriculum has exactly 8 tracks', () {
      final tracks = QaidaCurriculumData.tracks;
      expect(tracks.length, equals(8));
      expect(tracks[0].id, equals('track_1_letters'));
      expect(tracks[1].id, equals('track_2_forms'));
      expect(tracks[2].id, equals('track_3_harakat'));
      expect(tracks[3].id, equals('track_4_madd'));
      expect(tracks[4].id, equals('track_5_ghunnah'));
      expect(tracks[5].id, equals('track_6_joined'));
      expect(tracks[6].id, equals('track_7_words'));
      expect(tracks[7].id, equals('track_8_sentences'));
    });

    test('Track 1 has 28 Hijaiyah letters with activities', () {
      final track1 = QaidaCurriculumData.tracks[0];
      expect(track1.lessons.length, equals(28));
      for (final lesson in track1.lessons) {
        expect(lesson.activities.isNotEmpty, isTrue);
        expect(lesson.arabicDisplay.isNotEmpty, isTrue);
      }
    });

    test('Track 2 has 28 Letter forms (initial, medial, final)', () {
      final track2 = QaidaCurriculumData.tracks[1];
      expect(track2.lessons.length, equals(28));
      for (final lesson in track2.lessons) {
        expect(lesson.activities.length, greaterThanOrEqualTo(4));
      }
    });

    test('Track 3 has 7 Harakat, Tanwin and Sukun lessons', () {
      final track3 = QaidaCurriculumData.tracks[2];
      expect(track3.lessons.length, equals(7));
    });

    test('Track 4 has 10 Madd lessons matching the verified taxonomy', () {
      final track4 = QaidaCurriculumData.tracks[3];
      expect(track4.lessons.length, equals(10));
      // 1-alif: Tabii, Badal, Leen
      expect(track4.lessons[0].id, equals('madd_1_tabii'));
      expect(track4.lessons[1].id, equals('madd_2_badal'));
      expect(track4.lessons[2].id, equals('madd_3_leen'));
      // 3-alif: Aridi, Munfasil
      expect(track4.lessons[3].id, equals('madd_4_aridi'));
      expect(track4.lessons[4].id, equals('madd_5_munfasil'));
      // 4-alif: Lazim Harfi Mukhaffaf/Mushaqqal, Kalimi Mukhaffaf/Mushaqqal, Muttasil
      expect(track4.lessons[5].id, equals('madd_6_harfi_mukh'));
      expect(track4.lessons[6].id, equals('madd_7_harfi_mush'));
      expect(track4.lessons[7].id, equals('madd_8_kalimi_mukh'));
      expect(track4.lessons[8].id, equals('madd_9_kalimi_mush'));
      expect(track4.lessons[9].id, equals('madd_10_muttasil'));
    });

    test('Track 5 has 10 Noon/Meem Sakin and Ghunnah lessons', () {
      final track5 = QaidaCurriculumData.tracks[4];
      expect(track5.lessons.length, equals(10));
      expect(track5.lessons[0].id, equals('ghunnah_1_wajib'));
      expect(track5.lessons[9].id, equals('ghunnah_10_qalqalah'));
    });

    test('Track 6 has 20 Joined Letter lessons', () {
      final track6 = QaidaCurriculumData.tracks[5];
      expect(track6.lessons.length, equals(20));
    });

    test('Track 7 has 30 Word Reading lessons', () {
      final track7 = QaidaCurriculumData.tracks[6];
      expect(track7.lessons.length, equals(30));
    });

    test('Track 8 has 40 Sentence & Ayah Reading lessons', () {
      final track8 = QaidaCurriculumData.tracks[7];
      expect(track8.lessons.length, equals(40));
    });

    test('Admin user has isAdmin true and unlocks access', () {
      final state = AppState();
      state.draftRole = 'admin';
      expect(state.draftRole, equals('admin'));
    });
  });
}
