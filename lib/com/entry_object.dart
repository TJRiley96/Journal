

class Entry{
  final DateTime dateModified;
  final String dateID;
  final String entry;
  final String dateLong;
  Entry({required this.dateID, required this.dateLong, required this.entry, required this.dateModified});

  Set<String> getID() => {dateID};
  Map<String, dynamic> toJson() => {
      'date': dateLong,
      'entry': entry,
      'modified': dateModified,
  };

}