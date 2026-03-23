import 'dart:async';

import 'package:supabase/supabase.dart';

class SupabaseInsert {

	final String url;
	final String anonKey;
	final String tableName;
	
	SupabaseInsert (
		this.url,
		this.anonKey,
		this.tableName,
	);


	Future<SupabaseClient> init() async {
		return SupabaseClient(url, anonKey);
	}

	Future<void> insert(SupabaseClient client, String uid, String message) async {
		await client
			.from(tableName)
			.insert({'user_id': uid, 'error_message': message});

		return;
	}

}