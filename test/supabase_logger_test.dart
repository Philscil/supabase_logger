import 'dart:io';

import 'package:dotenv/dotenv.dart';

import 'package:supabase_logger/src/supabase_logger_base.dart';

Future<void> main() async {
	var env = DotEnv()..load();

	String url = env['SUPABASE_URL'].toString();
	String anonKey = env['SUPABASE_ANON_KEY'].toString();

	var supabaseLogger = SupabaseLogger(Directory.current.path, url, anonKey, 'Error Log', '9eb6161e-ee90-4f8a-8383-644efbbb08f2');

	await supabaseLogger.init();

	await supabaseLogger.insert('17:40');

	await supabaseLogger.sync();

  print('test complete.');

  exit(0);
}