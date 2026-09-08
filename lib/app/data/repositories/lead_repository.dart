import 'dart:io';
import 'package:dio/dio.dart' as dio;
import '../providers/api_service.dart';
import '../services/endpoints.dart';

class LeadRepository {
  final ApiService _apiService = ApiService.instance;

  Future<ApiResult<Map<String, dynamic>>> captureManualLead({
    required int expoId,
    required String name,
    required String email,
    required String phone,
    required String website,
    required String whatsapp,
    required String address,
    required String companyName,
    required String designation,
  }) async {
    final formData = dio.FormData.fromMap({
      'expo_id': expoId,
      'name': name,
      'email': email,
      'phone': phone,
      'website': website,
      'whatsapp': whatsapp,
      'address': address,
      'company_name': companyName,
      'designation': designation,
    });

    return await _apiService.post<Map<String, dynamic>>(
      Endpoints.manualLeadCapture,
      body: formData,
      authMode: AuthMode.header,
    );
  }

  Future<ApiResult<Map<String, dynamic>>> scanQrCode({
    required int expoId,
    required String qrCode,
  }) async {
    final formData = dio.FormData.fromMap({
      'expo_id': expoId,
      'qr_code': qrCode,
    });

    return await _apiService.post<Map<String, dynamic>>(
      Endpoints.scanQrCode,
      body: formData,
      authMode: AuthMode.header,
    );
  }

  Future<ApiResult<Map<String, dynamic>>> getDashboardData({required int expoId}) async {
    return await _apiService.get<Map<String, dynamic>>(
      "${Endpoints.dashboard}?expo_id=$expoId",
      authMode: AuthMode.header,
    );
  }

  Future<ApiResult<Map<String, dynamic>>> getAllLeads({required int expoId}) async {
    return await _apiService.get<Map<String, dynamic>>(
      "${Endpoints.leads}?expo_id=$expoId",
      authMode: AuthMode.header,
    );
  }

  Future<ApiResult<Map<String, dynamic>>> getLeadDetails(String id) async {
    return await _apiService.get<Map<String, dynamic>>(
      "${Endpoints.leadShow}/$id",
      authMode: AuthMode.header,
    );
  }

  Future<ApiResult<Map<String, dynamic>>> submitNote(String leadId, String note) async {
    final formData = dio.FormData.fromMap({
      'note': note,
    });

    return await _apiService.post<Map<String, dynamic>>(
      "${Endpoints.leads}/$leadId/submit-note",
      body: formData,
      authMode: AuthMode.header,
    );
  }

  Future<ApiResult<Map<String, dynamic>>> submitTags(String leadId, String tags) async {
    final formData = dio.FormData.fromMap({
      'tags': tags,
    });

    return await _apiService.post<Map<String, dynamic>>(
      "${Endpoints.leads}/$leadId/submit-tags",
      body: formData,
      authMode: AuthMode.header,
    );
  }

  Future<ApiResult<Map<String, dynamic>>> removeTag(String leadId, int tagId) async {
    return await _apiService.delete<Map<String, dynamic>>(
      "${Endpoints.leads}/$leadId/remove-tags?tag_id=$tagId",
      authMode: AuthMode.header,
    );
  }

  Future<ApiResult<Map<String, dynamic>>> submitProducts(String leadId, String products) async {
    final formData = dio.FormData.fromMap({
      'products': products,
    });

    return await _apiService.post<Map<String, dynamic>>(
      "${Endpoints.leads}/$leadId/submit-products",
      body: formData,
      authMode: AuthMode.header,
    );
  }

  Future<ApiResult<Map<String, dynamic>>> removeProduct(String leadId, int productId) async {
    return await _apiService.delete<Map<String, dynamic>>(
      "${Endpoints.leads}/$leadId/remove-products?product_id=$productId",
      authMode: AuthMode.header,
    );
  }

  Future<ApiResult<Map<String, dynamic>>> submitFollowUp({
    required String leadId,
    required String followUpAt,
    required String channel,
    required String remarks,
  }) async {
    final formData = dio.FormData.fromMap({
      'follow_up_at': followUpAt,
      'channel': channel,
      'remarks': remarks,
    });

    return await _apiService.post<Map<String, dynamic>>(
      "${Endpoints.leads}/$leadId/submit-follow-up",
      body: formData,
      authMode: AuthMode.header,
    );
  }

  Future<ApiResult<Map<String, dynamic>>> updateFollowUp({
    required String leadId,
    required int followUpId,
    required String followUpAt,
    required String channel,
    required String remarks,
    required String status,
  }) async {
    final String encodedFollowUpAt = Uri.encodeComponent(followUpAt);
    final String encodedChannel = Uri.encodeComponent(channel);
    final String encodedRemarks = Uri.encodeComponent(remarks);
    final String encodedStatus = Uri.encodeComponent(status);

    return await _apiService.put<Map<String, dynamic>>(
      "${Endpoints.leads}/$leadId/update-follow-up?follow_up_id=$followUpId&follow_up_at=$encodedFollowUpAt&channel=$encodedChannel&remarks=$encodedRemarks&status=$encodedStatus",
      authMode: AuthMode.header,
    );
  }

  Future<ApiResult<Map<String, dynamic>>> removeFollowUp(String leadId, int followUpId) async {
    return await _apiService.delete<Map<String, dynamic>>(
      "${Endpoints.leads}/$leadId/remove-follow-up?follow_up_id=$followUpId",
      authMode: AuthMode.header,
    );
  }

  Future<ApiResult<Map<String, dynamic>>> showFollowUp(String leadId, int followUpId) async {
    return await _apiService.get<Map<String, dynamic>>(
      "${Endpoints.leads}/$leadId/show-follow-up?follow_up_id=$followUpId",
      authMode: AuthMode.header,
    );
  }

  Future<ApiResult<Map<String, dynamic>>> submitDocuments(String leadId, File file) async {
    final formData = dio.FormData.fromMap({
      'file': await dio.MultipartFile.fromFile(file.path, filename: file.path.split('/').last),
    });

    return await _apiService.post<Map<String, dynamic>>(
      "${Endpoints.leads}/$leadId/submit-documents",
      body: formData,
      authMode: AuthMode.header,
    );
  }

  Future<ApiResult<Map<String, dynamic>>> removeDocument(String leadId, int documentId) async {
    return await _apiService.delete<Map<String, dynamic>>(
      "${Endpoints.leads}/$leadId/remove-documents?document_id=$documentId",
      authMode: AuthMode.header,
    );
  }
}
