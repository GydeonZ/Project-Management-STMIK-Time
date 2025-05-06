import 'package:flutter/material.dart';
import 'package:projectmanagementstmiktime/utils/state/finite_state.dart';
import 'package:projectmanagementstmiktime/view_model/cardtugas/view_model_anggota_list.dart';
import 'package:projectmanagementstmiktime/view_model/cardtugas/view_model_comment.dart';
import 'package:projectmanagementstmiktime/view_model/sign_in_sign_up/view_model_signin.dart';
import 'package:provider/provider.dart';

class RoundedTextField extends StatelessWidget {
  final TextEditingController controller;
  final int taskId;

  const RoundedTextField({
    super.key,
    required this.controller,
    required this.taskId,
  });

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<CommentViewModel>(context, listen: false);
    final sp = Provider.of<SignInViewModel>(context, listen: false);
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    final size = MediaQuery.of(context).size;

    bool checkUserCanEdit() {
      // Get the current user ID from SharedPreferences
      final userIdStr = sp.idSharedPreference;
      final currentUserId = userIdStr;

      if (currentUserId == 0) {
        return false;
      }

      // Get anggota list view model
      final anggotaViewModel =
          Provider.of<AnggotaListViewModel>(context, listen: false);

      // If anggota list is not loaded yet or is empty, default to false
      if (anggotaViewModel.modelAnggotaList == null) {
        return false;
      }

      // Check the user role using the existing method in AnggotaListViewModel
      final userRole = anggotaViewModel.getUserRoleFromAnggota(
          anggotaViewModel.modelAnggotaList!, currentUserId);
      // Define which roles can edit - Owner and Admin can edit
      final canEdit = userRole == RoleUserInBoard.owner ||
          userRole == RoleUserInBoard.admin;
      return canEdit;
    }

    return Material(
      // Gunakan Material untuk kontrol elevation yang lebih baik
      color: Colors.white,
      elevation: 4, // Elevation lebih kecil
      child: Container(
        color: Colors.transparent,
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          top: 8,
          bottom: keyboardHeight > 0 ? keyboardHeight : 8,
        ),
        // Hapus BoxDecoration shadow di sini, gunakan elevation dari Material
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // User Avatar
            CircleAvatar(
              radius: 16,
              backgroundColor: Colors.primaries[
                  sp.nameSharedPreference.hashCode % Colors.primaries.length],
              child: Text(
                _getInitials(sp.nameSharedPreference),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
            const SizedBox(width: 10),
            // Text Field - Ukuran Fixed dan Centered
            Container(
              width: size.width * 0.6,
              height: 40, // Fixed height yang lebih kecil
              decoration: BoxDecoration(
                color: const Color(0xFFF5F7FA),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: TextField(
                        controller: controller,
                        maxLines: 1,
                        textAlignVertical: TextAlignVertical.center,
                        decoration: const InputDecoration(
                          hintText: 'Tulis komentar...',
                          hintStyle: TextStyle(
                            color: Color(0xFF9AA5B1),
                            fontSize: 14,
                          ),
                          isDense: true,
                          contentPadding: EdgeInsets.zero,
                          border: InputBorder.none,
                        ),
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF293066),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Tambahkan sedikit jarak
            const SizedBox(width: 10),
            // Send Button
            GestureDetector(
              onTap: () {
                bool canEdit = checkUserCanEdit();
                if (controller.text.trim().isNotEmpty && canEdit) {
                  viewModel.postCommentTask(
                      token: sp.tokenSharedPreference, taskId: taskId);
                  // Sembunyikan keyboard setelah mengirim komentar
                  FocusScope.of(context).unfocus();
                }
              },
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                  color: Color(0xFF293066),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.send,
                  color: Colors.white,
                  size: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getInitials(String name) {
    if (name.isEmpty) return '';

    final nameParts = name.split(' ');
    if (nameParts.length >= 2) {
      return '${nameParts[0][0]}${nameParts[1][0]}'.toUpperCase();
    } else if (nameParts.length == 1 && nameParts[0].isNotEmpty) {
      return nameParts[0][0].toUpperCase();
    }

    return '';
  }
}
