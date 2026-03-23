import 'dart:io';

import 'package:isar/isar.dart';
import 'package:supabase/supabase.dart';
import 'package:supabase_logger/src/log_model.dart';

import 'package:supabase_logger/src/supabase_insert.dart';

class SupabaseLogger {
    final String url;
    final String anonKey;
    final String tableName;
	final String uid;

	final SupabaseInsert supabaseInsert;

	late SupabaseClient client;

	late Isar isar;

	SupabaseLogger(
		this.url,
		this.anonKey,
		this.tableName,
		this.uid,

	) : supabaseInsert = SupabaseInsert(url, anonKey, tableName);

	Future<void> init() async {
		client = await supabaseInsert.init();

		isar = await Isar.open(
			[ErrorLogSchema],
			directory: Directory.current.path,
		);

		return;
	}

	Future<void> insert(String message) async {
		try {
			await supabaseInsert.insert(client, uid, message);
		} on Exception {
			
			await isar.writeTxn(() async {
				final newLog = ErrorLog()
					..uid = uid
					..message = message;

				await isar.errorLogs.put(newLog);
			});
	
		}

		return;
	}

	Future<void> sync() async {
		try {
			final logs = await isar.errorLogs.where().findAll();

			for (var log in logs) {
				await supabaseInsert.insert(client, uid, log.message);
				
				await isar.writeTxn(() async {
					await isar.errorLogs.delete(log.id);
				});
			}

			return;
		} on Exception {
			return;
		}
	}
}