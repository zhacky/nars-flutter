class UserDocument {
  final String imageScr, status;
  final int type;

  UserDocument({
    required this.type,
    required this.imageScr,
    required this.status,
  });
}

List<UserDocument> userDocuments = [
  UserDocument(
    type: 0,
    imageScr: 'assets/images/documents/ID_sample1.png',
    status: 'Waiting for Approval',
  ),
  UserDocument(
    type: 1,
    imageScr: 'assets/images/documents/med_record_sample1.png',
    status: 'Approved',
  ),
];
