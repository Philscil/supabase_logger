import 'dart:async';

import 'package:supabase/supabase.dart';

class SupabaseInsert {

	final String url;
	final String anonKey;
	final String tableName;
	
    /// constructor

	SupabaseInsert (
		this.url,
		this.anonKey,
		this.tableName,
	);


    /// initializes supabase client with the supabase dart package

	Future<SupabaseClient> init() async {
		return SupabaseClient(url, anonKey);
	}


    /// inserts a new row in supabase by using the supabase dart package

	Future<void> insert(SupabaseClient client, String uid, String message, String createdAt) async {
		await client
			.from(tableName)
			.insert({'created_at': createdAt, 'user_id': uid, 'error_message': message});

		return;
	}

}