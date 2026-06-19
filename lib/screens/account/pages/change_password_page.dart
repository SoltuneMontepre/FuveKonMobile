import 'package:flutter/material.dart';
import 'package:fuvekonmobile/core/api/auth_api.dart';
import 'package:fuvekonmobile/core/di/injection.dart';
import 'package:fuvekonmobile/core/theme/app_colors.dart';
import 'package:fuvekonmobile/core/theme/fuvekon_theme_extension.dart';
import 'package:fuvekonmobile/shared/widgets/app_page_layout.dart';
import 'package:fuvekonmobile/shared/widgets/fuve_mint_card.dart';
import 'package:fuvekonmobile/shared/widgets/fuve_pill_button.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _currentController = TextEditingController();
  final _newController = TextEditingController();
  final _confirmController = TextEditingController();
  bool _isSaving = false;
  bool _obscureCurrent = true;
  bool _obscureNew = true;
  bool _obscureConfirm = true;

  @override
  void dispose() {
    _currentController.dispose();
    _newController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() => _isSaving = true);
    try {
      final response = await sl<AuthApi>().changePassword({
        'current_password': _currentController.text,
        'new_password': _newController.text,
        'confirm_password': _confirmController.text,
      });
      if (!mounted) return;
      if (response.isSuccess) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Đã đổi mật khẩu')),
        );
        Navigator.of(context).pop();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response.errorMessage ?? response.message)),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Không thể đổi mật khẩu: $e')),
      );
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  InputDecoration _decoration(String label, {Widget? suffix}) {
    return InputDecoration(
      labelText: label,
      filled: true,
      fillColor: FuvekonColors.inputFill,
      suffixIcon: suffix,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(FuvekonRadii.input),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ext = context.fuvekonTheme;

    return AppPageScaffold(
      title: 'Đổi mật khẩu',
      body: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            FuveMintCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Cập nhật mật khẩu tài khoản',
                    style: TextStyle(
                      color: ext.contentOnCard,
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _currentController,
                    obscureText: _obscureCurrent,
                    enabled: !_isSaving,
                    decoration: _decoration(
                      'Mật khẩu hiện tại',
                      suffix: IconButton(
                        icon: Icon(
                          _obscureCurrent ? Icons.visibility_off : Icons.visibility,
                        ),
                        onPressed: () =>
                            setState(() => _obscureCurrent = !_obscureCurrent),
                      ),
                    ),
                    validator: (v) =>
                        (v == null || v.isEmpty) ? 'Nhập mật khẩu hiện tại' : null,
                  ),
                  const SizedBox(height: FuvekonSpacing.field),
                  TextFormField(
                    controller: _newController,
                    obscureText: _obscureNew,
                    enabled: !_isSaving,
                    decoration: _decoration(
                      'Mật khẩu mới',
                      suffix: IconButton(
                        icon: Icon(
                          _obscureNew ? Icons.visibility_off : Icons.visibility,
                        ),
                        onPressed: () => setState(() => _obscureNew = !_obscureNew),
                      ),
                    ),
                    validator: (v) {
                      if (v == null || v.length < 8) {
                        return 'Mật khẩu mới tối thiểu 8 ký tự';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: FuvekonSpacing.field),
                  TextFormField(
                    controller: _confirmController,
                    obscureText: _obscureConfirm,
                    enabled: !_isSaving,
                    decoration: _decoration(
                      'Xác nhận mật khẩu mới',
                      suffix: IconButton(
                        icon: Icon(
                          _obscureConfirm ? Icons.visibility_off : Icons.visibility,
                        ),
                        onPressed: () =>
                            setState(() => _obscureConfirm = !_obscureConfirm),
                      ),
                    ),
                    validator: (v) {
                      if (v != _newController.text) {
                        return 'Mật khẩu xác nhận không khớp';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: FuvekonSpacing.stackGapLg),
            FuvePillButton(
              label: _isSaving ? 'Đang lưu...' : 'Lưu mật khẩu',
              icon: Icons.lock_outline,
              onPressed: _isSaving ? null : _submit,
            ),
          ],
        ),
      ),
    );
  }
}
