import 'dart:math';

import 'package:isar/isar.dart';
import 'package:supabase/supabase.dart';
import 'package:supabase_logger/src/log_model.dart';

import 'package:supabase_logger/src/supabase_insert.dart';

class SupabaseLogger {
	final String path;
    final String url;
    final String anonKey;
    final String tableName;
	final String uid;

	final SupabaseInsert supabaseInsert;

	late SupabaseClient client;

	late Isar isar;

	SupabaseLogger(
		this.path,
		this.url,
		this.anonKey,
		this.tableName,
		this.uid,

	) : supabaseInsert = SupabaseInsert(url, anonKey, tableName);

	Future<void> init() async {
		client = await supabaseInsert.init();

		isar = await Isar.open(
			[ErrorLogSchema],
			directory: path,
		);

		return;
	}

	Future<void> insert(String message) async {
		try {
			await supabaseInsert.insert(client, uid, message, DateTime.now().toUtc().toIso8601String());
		} on Exception {

			final logCount = await isar.errorLogs.count();
			
			await isar.writeTxn(() async {
				if (logCount > 50) {
					final oldestLog = await isar.errorLogs
						.where()
						.sortByCreatedAt()
						.findFirst();
					
					if (oldestLog != null) {
						await isar.errorLogs.delete(oldestLog.id);
					}
				}

				final newLog = ErrorLog()
					..uid = uid
					..message = message
					..createdAt = DateTime.now().toUtc().toIso8601String();
				
				

				await isar.errorLogs.put(newLog);
			});
	
		}

		return;
	}

	Future<void> sync() async {
		try {
			final logs = await isar.errorLogs.where().findAll();
			int i = 0;

			for (var log in logs) {
				try {
					await supabaseInsert.insert(client, uid, log.message, log.createdAt);
				
					await isar.writeTxn(() async {
						await isar.errorLogs.delete(log.id);
					});

					if (i >= 10) {
						break;
					}
					i++;
				} on Exception {
					break;
				}
				
			}

			return;
		} on Exception {
			return;
		}
	}
}