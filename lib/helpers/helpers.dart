import 'package:nars/enumerables/appointment_status.dart';
import 'package:nars/enumerables/document_type.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

extension DateTimeExt on DateTime {
  DateTime get roundMin => DateTime(year, month, day, hour, () {
        if (minute == 0) {
          return 0;
        } else if (minute < 30) {
          return 30;
        } else {
          return 60;
        }
      }());

  DateTime plusThirty(int multiplier) =>
      DateTime(year, month, day, hour, minute + (30 * multiplier));

  DateTime get startOfTheDay => DateTime(year, month, day, 0, 0);
  DateTime get endOfTheDay => DateTime(year, month, day + 1, 0, 0);
}

int dateToInt(DateTime date) => int.parse(
      TimeOfDay.fromDateTime(date).hour.toString() +
          TimeOfDay.fromDateTime(date).minute.toString().padLeft(2, '0'),
    );

int timeToInt(TimeOfDay time) => int.parse(
      time.hour.toString() + time.minute.toString().padLeft(2, '0'),
    );

int ageCompute(DateTime DOB, DateTime curDate) {
  int yearDiff = curDate.year - DOB.year;
  bool monthPassed = (curDate.month - DOB.month) >= 0;
  bool dayPassed = (curDate.day - DOB.day) >= 0;

  return yearDiff - (monthPassed && dayPassed ? 0 : 1);
}

int daysBetween(DateTime from, DateTime to) {
  from = DateTime(from.year, from.month, from.day);
  to = DateTime(to.year, to.month, to.day);
  return (to.difference(from).inHours / 24).round();
}

Color statusColor(value) {
  switch (value) {
    case 'Completed':
      return Colors.greenAccent;
    case 'Approved':
      return Colors.blueAccent.withOpacity(0.6);
    case 'Accepted':
      return Colors.blueAccent.withOpacity(0.6);
    default:
      return Colors.orangeAccent.withOpacity(0.8);
  }
}

String appointHistoryCardButtonTxt(value) {
  switch (value) {
    case 'Completed':
      return 'Book Again';
    case 'Accepted':
      return 'Ongoing';
    case 'For Approval':
      return 'Waiting for Approval';
    case 'Resched Requested':
      return 'Re-schedule Requested';
    default:
      return '';
  }
}

String appointmentHistoryLabel(value) {
  switch (value) {
    case 'WaitingForApproval':
      return 'Waiting for Approval';
    default:
      return value;
  }
}

List<DropdownMenuItem<int>> getGenders() {
  List<DropdownMenuItem<int>> menuItems = [
    const DropdownMenuItem(
      child: Text('Male'),
      value: 0,
    ),
    const DropdownMenuItem(
      child: Text('Female'),
      value: 1,
    ),
  ];
  return menuItems;
}

List<DropdownMenuItem<int>> getSubscriptions() {
  List<DropdownMenuItem<int>> menuItems = [
    const DropdownMenuItem(
      child: Text('Year'),
      value: 0,
    ),
    const DropdownMenuItem(
      child: Text('Month'),
      value: 1,
    ),
  ];
  return menuItems;
}

List<DropdownMenuItem<int>> getUsertypes() {
  List<DropdownMenuItem<int>> menuItems = [
    // TODO: remove "Doctor" option or
    // default to "Nurse" in the screen
    const DropdownMenuItem(
      child: Text('Doctor'),
      value: 2,
    ),
    const DropdownMenuItem(
      child: Text('Nurse'),
      value: 3,
    ),
  ];
  return menuItems;
}

List<DropdownMenuItem<String>> getDays() {
  List<DropdownMenuItem<String>> menuItems = [
    const DropdownMenuItem(
      child: Text('Monday'),
      value: 'Monday',
    ),
    const DropdownMenuItem(
      child: Text('Tuesday'),
      value: 'Tuesday',
    ),
    const DropdownMenuItem(
      child: Text('Wednesday'),
      value: 'Wednesday',
    ),
    const DropdownMenuItem(
      child: Text('Thursday'),
      value: 'Thursday',
    ),
    const DropdownMenuItem(
      child: Text('Friday'),
      value: 'Friday',
    ),
    const DropdownMenuItem(
      child: Text('Saturday'),
      value: 'Saturday',
    ),
    const DropdownMenuItem(
      child: Text('Sunday'),
      value: 'Sunday',
    ),
  ];
  return menuItems;
}

String getAppointmentStatusName(AppointmentStatus status) {
  switch (status) {
    case AppointmentStatus.WaitingForApproval:
      return 'For Approval';
    case AppointmentStatus.ReschedByPatient:
      return 'Resched Requested by Patient';
    case AppointmentStatus.ReschedByPractitioner:
      return 'Resched Requested by Doctor';
    default:
      return status.name;
  }
}

String getCovidStatus(String status) {
  switch (status) {
    case 'NotSure':
      return 'Not Sure';
    default:
      return status;
  }
}

String getNurseService(String status) {
  switch (status) {
    case 'AdministrationOfOralMedication':
      return 'Administration Of Oral Medication';
    case 'FeedingOral':
      return 'Feeding Oral';
    case 'FeedingNGT':
      return 'Feeding NGT';
    case 'GeneralMonitoring':
      return 'General Monitoring';
    case 'AdministrationOfIVMedication':
      return 'Administration Of IV Medication';
    default:
      return status;
  }
}

String getMobility(String status) {
  switch (status) {
    case 'InAWheelchair':
      return 'In a Wheelchair';
    default:
      return status;
  }
}

List<DropdownMenuItem<DocumentType>> getDocumentTypes() {
  List<DropdownMenuItem<DocumentType>> menuItems = [
    const DropdownMenuItem(
      child: Text('Diploma'),
      value: DocumentType.Diploma,
    ),
    const DropdownMenuItem(
      child: Text('License ID'),
      value: DocumentType.LicenseID,
    ),
    const DropdownMenuItem(
      child: Text('Medical Certificate'),
      value: DocumentType.MedicalCertificate,
    ),
    const DropdownMenuItem(
      child: Text('Other'),
      value: DocumentType.Other,
    ),
    const DropdownMenuItem(
      child: Text('PRC ID'),
      value: DocumentType.PRCID,
    ),
    const DropdownMenuItem(
      child: Text('Selfie with PRC ID'),
      value: DocumentType.SelfieWithPRCID,
    ),
    // const DropdownMenuItem(
    //   child: Text('ID'),
    //   value: DocumentType.Other,
    // ),
    // const DropdownMenuItem(
    //   child: Text('Medical Record'),
    //   value: DocumentType.Other,
    // ),
    // const DropdownMenuItem(
    //   child: Text('Medical History'),
    //   value: DocumentType.Other,
    // ),
    // const DropdownMenuItem(
    //   child: Text('PRC ID'),
    //   value: DocumentType.Other,
    // ),
    // const DropdownMenuItem(
    //   child: Text('Selfie with PRC ID'),
    //   value: DocumentType.Other,
    // ),
  ];
  return menuItems;
}

List<DropdownMenuItem<String>> getServices() {
  List<DropdownMenuItem<String>> menuItems = [
    const DropdownMenuItem(
      child: Text('Acidity'),
      value: 'Acidity',
    ),
    const DropdownMenuItem(
      child: Text('Anxiety'),
      value: 'Anxiety',
    ),
    const DropdownMenuItem(
      child: Text('Blood Pressure'),
      value: 'Blood Pressure',
    ),
    const DropdownMenuItem(
      child: Text('Constipitation'),
      value: 'Constipation',
    ),
    const DropdownMenuItem(
      child: Text('Back Pain'),
      value: 'Back Pain',
    ),
    const DropdownMenuItem(
      child: Text('Cough'),
      value: 'Cough',
    ),
    const DropdownMenuItem(
      child: Text('Covid'),
      value: 'Covid',
    ),
    const DropdownMenuItem(
      child: Text('Depression'),
      value: 'Depression',
    ),
    const DropdownMenuItem(
      child: Text('Diabetes'),
      value: 'Diabetes',
    ),
    const DropdownMenuItem(
      child: Text('Fever'),
      value: 'Fever',
    ),
    const DropdownMenuItem(
      child: Text('Hair Fall'),
      value: 'Hair Fall',
    ),
    const DropdownMenuItem(
      child: Text('Headache'),
      value: 'Headache',
    ),
    const DropdownMenuItem(
      child: Text('Infections'),
      value: 'Infections',
    ),
    const DropdownMenuItem(
      child: Text('Stomach Ache'),
      value: 'Stomach Ache',
    ),
    const DropdownMenuItem(
      child: Text('Throat Pain'),
      value: 'Throat Pain',
    ),
    const DropdownMenuItem(
      child: Text('Weight Loss'),
      value: 'Weight Loss',
    ),
  ];
  return menuItems;
}

class CheckboxFormField extends FormField<bool> {
  CheckboxFormField({
    Key? key,
    required Widget title,
    required FormFieldSetter<bool> onSaved,
    required FormFieldValidator<bool> validator,
    bool initialValue = false,
    bool autovalidate = false,
  }) : super(
          key: key,
          onSaved: onSaved,
          validator: validator,
          initialValue: initialValue,
          builder: (FormFieldState<bool> state) {
            return CheckboxListTile(
              contentPadding: const EdgeInsets.all(0),
              dense: state.hasError,
              title: title,
              value: state.value,
              onChanged: state.didChange,
              subtitle: state.hasError
                  ? Builder(
                      builder: (BuildContext context) => Text(
                        state.errorText!,
                        style: TextStyle(color: Theme.of(context).errorColor),
                      ),
                    )
                  : null,
              controlAffinity: ListTileControlAffinity.leading,
            );
          },
        );
}

var phPhoneFormat = MaskTextInputFormatter(
  mask: '(####)-###-####',
  filter: {"#": RegExp(r'[0-9]')},
  type: MaskAutoCompletionType.lazy,
);

class EnumValuesByInt<T> {
  Map<int, T> map;
  Map<T, int>? reverseMap;

  EnumValuesByInt(this.map);

  Map<T, int>? get reverse {
    if (reverseMap == null) {
      reverseMap = map.map((k, v) => new MapEntry(v, k));
    }
    return reverseMap;
  }
}

class EnumValues<T> {
  Map<String, T> map;
  Map<T, String>? reverseMap;

  EnumValues(this.map);

  Map<T, String>? get reverse {
    if (reverseMap == null) {
      reverseMap = map.map((k, v) => new MapEntry(v, k));
    }
    return reverseMap;
  }
}
