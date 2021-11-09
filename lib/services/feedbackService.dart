import 'package:mosaic_doctors/models/sessionData.dart';
import 'package:mosaic_doctors/services/labDatabase.dart';
import 'package:mosaic_doctors/shared/locator.dart';

class FeedbackService {
  static registerFeedback(String? caseId, int rating, String details,
      String? patientName, String? doctorId) async {
    var result = await LabDatabase.postQueryToDB(
        "INSERT INTO `feedback` (`id`, `rate`, `note`, `patient_name`, `order_id`, `doctor_id`, `created_at`, `updated_at`) "
        "VALUES (NULL, '$rating', '$details','$patientName', '$caseId', $doctorId, NULL, NULL)");
    print("Feedback register response : $result");
  }
}
