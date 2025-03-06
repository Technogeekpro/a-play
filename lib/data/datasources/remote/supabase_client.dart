import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseClientService {
  final SupabaseClient client;

  SupabaseClientService(String supabaseUrl, String supabaseKey)
      : client = SupabaseClient(supabaseUrl, supabaseKey);

  // Fetch data from a table
  Future<List<Map<String, dynamic>>> fetchData(String table) async {
    try {
      final response = await client
          .from(table)
          .select()
          .order('created_at', ascending: false);
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      throw Exception('Error fetching data: $e');
    }
  }

  // Insert data into a table
  Future<Map<String, dynamic>> insertData(String table, Map<String, dynamic> data) async {
    try {
      final response = await client
          .from(table)
          .insert(data)
          .select()
          .single();
      return response;
    } catch (e) {
      throw Exception('Error inserting data: $e');
    }
  }

  // Update data in a table
  Future<Map<String, dynamic>> updateData(String table, String id, Map<String, dynamic> data) async {
    try {
      final response = await client
          .from(table)
          .update(data)
          .eq('id', id)
          .select()
          .single();
      return response;
    } catch (e) {
      throw Exception('Error updating data: $e');
    }
  }

  // Delete data from a table
  Future<void> deleteData(String table, String id) async {
    try {
      await client
          .from(table)
          .delete()
          .eq('id', id);
    } catch (e) {
      throw Exception('Error deleting data: $e');
    }
  }

  // Fetch data with filters
  Future<List<Map<String, dynamic>>> fetchDataWithFilters(
    String table, {
    Map<String, dynamic>? equals,
    String? orderBy,
    bool ascending = true,
    int? limit,
  }) async {
    try {
      dynamic query = client.from(table).select();

      // Apply equals filters
      if (equals != null) {
        for (final entry in equals.entries) {
          query = query.eq(entry.key, entry.value);
        }
      }

      // Apply ordering
      if (orderBy != null) {
        query = query.order(orderBy, ascending: ascending);
      }

      // Apply limit
      if (limit != null) {
        query = query.limit(limit);
      }

      final response = await query;
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      throw Exception('Error fetching data with filters: $e');
    }
  }

  // Fetch data with relationships
  Future<List<Map<String, dynamic>>> fetchDataWithRelations(
    String table,
    List<String> relations,
  ) async {
    try {
      final query = client.from(table).select('*, ${relations.join(", ")}');
      final response = await query;
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      throw Exception('Error fetching data with relations: $e');
    }
  }
}
