const String LESSONS_TABLE_NAME = 'lessons';

const String columnId = 'id';
const String columnTitle = 'title';
const String columnLabel = 'label';
const String columnSubjectId = 'subjectId';
const String columnSubject = 'subject';
const String columnSeriesId = 'seriesId';
const String columnSeries = 'series';
const String columnLength = 'length';
const String columnDate = 'dateStr';
const String columnRavId = 'ravId';
const String columnRav = 'rav';
const String columnVideoUrl = 'videoUrl';
const String columnAudioUrl = 'audioUrl';
const String columnTimestamp = 'timestamp';
const String columnSource = 'source';

class Lesson implements Comparable<Lesson> {
  final int id;
  final String title;
  final String label;
  final int subjectId;
  final String subject;
  final int seriesId;
  final String series;
  final String dateStr;
  final int ravId;
  final String rav;
  final String length;
  final String videoUrl;
  final String audioUrl;
  final int timestamp;
  final String source;

  Lesson.named(this.id, this.label, this.title, this.ravId, this.rav, this.videoUrl, this.audioUrl, this.subjectId,
      this.subject, this.seriesId,this.series, this.dateStr, this.length, this.timestamp, this.source);

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      columnId: id,
      columnTitle: title,
      columnLabel: label,
      columnSubjectId: subjectId,
      columnSubject: subject,
      columnSeriesId: seriesId,
      columnSeries: series,
      columnDate: dateStr,
      columnRavId: ravId,
      columnRav: rav,
      columnLength: length,
      columnVideoUrl: videoUrl,
      columnAudioUrl: audioUrl,
      columnTimestamp: timestamp,
      columnSource: source,
    };
    return map;
  }

  Lesson.fromMap(Map<String, dynamic> map)
      : this.named(
            map[columnId],
            map[columnLabel],
            map[columnTitle],
            map[columnRavId],
            map[columnRav],
            map[columnVideoUrl],
            map[columnAudioUrl],
            map[columnSubjectId],
            map[columnSubject],
            map[columnSeriesId],
            map[columnSeries],
            map[columnDate],
            map[columnLength],
            map[columnTimestamp],
            map[columnSource]);

  @override
  String toString() {
    return 'Lesson{id: $id, title: $title, label: $label, subjectId: $subjectId, subject: $subject, seriesId: $seriesId, series: $series, dateStr: $dateStr, ravId: $ravId, rav: $rav, length: $length, videoUrl: $videoUrl, audioUrl: $audioUrl, source:$source}';
  }

  @override
  int compareTo(other) {
    List<String> dateOfThis = dateStr.split(' ');
    List<String> dateOfHim = other.dateStr.split(' ');
    if (dateOfThis.length != 3 || dateOfHim.length != 3) {
      return 0;
    }
    if (dateOfThis[2].compareTo(dateOfHim[2]) != 0) {
      return dateOfThis[2].compareTo(dateOfHim[2]);
    }
    if (dateOfThis[1].compareTo(dateOfHim[1]) != 0) {
      //todo implement comperator base on month array with contains...
      return dateOfThis[1].compareTo(dateOfHim[1]);
    }
    return dateOfThis[0].compareTo(dateOfHim[0]);
  }


}
