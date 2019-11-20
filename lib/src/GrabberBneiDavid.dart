import 'package:lessons_center_common/lessons_center_common.dart';
import 'package:html/parser.dart' show parse;
import 'package:html/dom.dart';
import 'package:http/http.dart' as http;

const Map<String, int> subjectsIdMap = {
  'גמרא': 29,
  'אמונה': 30,
  'הלכה': 31,
  'הרצאות חול': 40,
  'כתבי הראי"ה': 44,
  'מוסר': 41,
  'פרשיות השבוע': 32,
  'שבת ומועדים': 33,
  'תנ"ך': 34,
  'תפילה': 27,
};

const Map<String, int> ravIdMap = {
  'הרב אלי סדן': 14,
  'הרב אליעזר קשתיאל': 15,
  'הרב אוהד תירוש': 12,
  'הרב יגאל לוינשטיין': 44,
  'הרב יוסף קלנר': 23,
  'הרב גיורא רדלר': 17,
  'הרב שלמה אבינר': 31,
  'הרב אבי רונצקי': 11,
  'הרב אברהם שילר': 41,
  'הרב חיים וידאל': 19,
  'כללי': 37,
  'הרב בני אייזנר זצ"ל': 16,
  'הרב נתנאל אלישיב': 26,
  'הרב שמואל הרשלר': 32,
  'הרב יואל רכל': 22,
  'הרב עידו רוזנטל	': 28,
  'הרב מרדכי הס': 24,
  'הרב קובי דנה': 45,
  'הרב עקיבא קשתיאל': 46,
  'הרב רביד ניסים': 47,
  'הרב דוד בן מאיר': 48,
  'הרב יהודה סדן': 49,
  'יום מהות': 50,
  'הרב איתי הלוי': 51,
  'הרב איתן קופמן': 52,
  'הרב אופיר וולס': 53,
  'הרב אליעזר בראון': 56,
  'הרב אלישע וישליצקי': 57,
  'הרב פנחס עציון': 58,
  'הרצאות חול': 59,
  'הרב יאיר אטון': 60,
  'הרב שי אליאס': 61,
  'הרב דוד טורנר': 63,
  'הרב כפיר אלון': 64,
  "דר' מיכאל אבולעפיה	": 65,
};

Future<List<Lesson>> getLessonsFromUrl(bool isMainPage, String url) async {
  final response = await http.get(url);
  return parseUrlResponse(isMainPage, response.body);
}

Future<List<Lesson>> parseUrlResponse(bool isMainPage, String response) async {
  List<Lesson> results = List();
  var document = parse(response);
  var rows = document.getElementsByTagName("tr");
  for (var row in rows) {
    if (row.classes.contains('titles_list_info')) {
      continue;
    }
    var id, label, rav, ravId, title, sidra, sidraUrl, sidraId, video, audio, subject, subjectId, date, length;
    if (row.parent.parent.attributes.containsKey('id') && row.parent.parent.attributes['id'].endsWith('gvLectures')) {
      label = isMainPage ? ('אחרונים') : '';
    } else if (row.parent.parent.parent.parent.parent.attributes.containsKey('id') && row.parent.parent.parent.parent.parent.attributes['id'].endsWith('recommendedDiv')) {
      label = isMainPage ? ('מומלצים') : '';
    } else {
      continue;
    }
    for (var child in row.nodes) {
      for (var node in child.nodes) {
        if (node.attributes.containsKey('id') && node.attributes['id'].endsWith('_lblId')) {
          id = int.parse(getValueFromNode(node).replaceAll(RegExp("^.|.\$"), ""));
        } else if (node.attributes.containsKey('id') && node.attributes['id'].endsWith('lblRabi')) {
          rav = getValueFromNode(node).replaceAll(RegExp("^.|.\$"), "");
          ravId = ravIdMap[rav];
        } else if (node.attributes.containsKey('id') && node.attributes['id'].endsWith('lblSubject')) {
          subject = getValueFromNode(node).replaceAll(RegExp("^.|.\$"), "");
          subjectId = subjectsIdMap[subject];
        } else if (node.attributes.containsKey('id') && node.attributes['id'].endsWith('hlName')) {
          title = getValueFromNode(node).replaceAll(RegExp("^.|.\$"), "");
        } else if (node.attributes.containsKey('id') && node.attributes['id'].endsWith('hlSerieName')) {
          sidra = getValueFromNode(node).replaceAll(RegExp("^.|.\$"), "");
          sidraUrl = node.attributes['href'].toString();
          sidraId = int.parse(sidraUrl.split('serie=')[1]);
        } else if (node.attributes.containsKey('id') && node.attributes['id'].endsWith('lblDate')) {
          date = getValueFromNode(node).replaceAll(RegExp("^.|.\$"), "");
        } else if (node.attributes.containsKey('id') && node.attributes['id'].endsWith('hlVideo')) {
          video = node.attributes['href'].toString();
          if (video.endsWith('vf/audio/')) {
            video = null;
          } else {
            bool linkValid = await isMediaLinkValid(video);
            if (!linkValid){
              video = null;
            }
          }
        } else if (node.attributes.containsKey('id') && node.attributes['id'].endsWith('hlAudio')) {
          audio = node.attributes['href'].toString();
          bool linkValid = await isMediaLinkValid(audio);
          if (!linkValid){
            audio = null;
          }
        } else if (node.attributes.containsKey('id') && node.attributes['id'].endsWith('_lbllength')) {
          length = getValueFromNode(node).replaceAll(RegExp("^.|.\$"), "");
        }
      }
    }
    if (rav != null && (audio != null || video != null)) {
      Lesson lesson =
          Lesson.named(id, label, title, ravId, rav, video, audio, subjectId, subject, sidraId, sidra, date, length, DateTime.now().millisecondsSinceEpoch, 'bnei_david');
      print(lesson);
      results.add(lesson);
    }
  }
  return results;
}

String getValueFromNode(Node node) => node.nodes.isNotEmpty ? node.nodes[0].toString() : "";

Future<bool> isMediaLinkValid(String link) async => (await http.head(link)).statusCode == 200;
