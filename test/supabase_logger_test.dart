import 'package:dotenv/dotenv.dart';

import 'package:supabase_logger/src/supabase_insert.dart';

Future<void> main() async {
	var env = DotEnv()..load();

	String url = env['SUPABASE_URL'].toString();
	String anonKey = env['SUPABASE_ANON_KEY'].toString();

	var supabaseInsert = SupabaseInsert(url, anonKey, 'Error Log');
	
	var client = supabaseInsert.init();

	supabaseInsert.insert(client, '9eb6161e-ee90-4f8a-8383-644efbbb08f2', 'test');
}