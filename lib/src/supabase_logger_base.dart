import 'package:supabase/supabase.dart';

import 'package:supabase_logger/src/supabase_insert.dart';

class SupabaseLogger {
    final String url;
    final String anonKey;
    final String tableName;

	final SupabaseInsert supabaseInsert;

	late SupabaseClient client;

	SupabaseLogger(
		this.url,
		this.anonKey,
		this.tableName,

	) : supabaseInsert = SupabaseInsert(url, anonKey, tableName);

	Future<void> init() async {
		client = await supabaseInsert.init();
	}

	Future<void> insert(String uid, String message) async {
		supabaseInsert.insert(client, uid, message);
	}
}