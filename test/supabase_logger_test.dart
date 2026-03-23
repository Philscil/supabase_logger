import 'package:dotenv/dotenv.dart';

import 'package:supabase_logger/src/supabase_logger_base.dart';

Future<void> main() async {
	var env = DotEnv()..load();

	String url = env['SUPABASE_URL'].toString();
	String anonKey = env['SUPABASE_ANON_KEY'].toString();

	var supabaseLogger = SupabaseLogger(url, anonKey, 'Error Log');

	await supabaseLogger.init();

	supabaseLogger.insert('9eb6161e-ee90-4f8a-8383-644efbbb08f2', 'test');
}