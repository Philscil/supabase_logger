import 'package:isar/isar.dart';

part 'log_model.g.dart';


/// defines the local storage

@collection
class ErrorLog {
    Id id = Isar.autoIncrement;

    late String uid;
    late String message;
    late String createdAt;
}