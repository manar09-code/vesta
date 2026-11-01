import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../l10n/generated/app_localizations.dart';
import 'profile_avatar.dart';
import 'profile_controller.dart';
import 'profile_messages.dart';
import 'user_repository.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key, required this.profile});

  final UserProfile profile;

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  String? _newPhotoBase64; // set only when the user picked a new photo

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.profile.displayName);
    // Clear an old error left by another screen (after the first build).
    Future.microtask(() {
      if (mounted) ref.read(profileControllerProvider.notifier).clearError();
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _choosePhoto() async {
    final l10n = AppLocalizations.of(context);
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      builder: (sheetContext) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library_outlined),
              title: Text(l10n.profilePhotoGallery),
              onTap: () => Navigator.pop(sheetContext, ImageSource.gallery),
            ),
            ListTile(
              leading: const Icon(Icons.photo_camera_outlined),
              title: Text(l10n.profilePhotoCamera),
              onTap: () => Navigator.pop(sheetContext, ImageSource.camera),
            ),
          ],
        ),
      ),
    );
    if (source == null) return; // sheet dismissed

    final photo =
        await ref.read(profileControllerProvider.notifier).pickPhoto(source);
    if (photo != null && mounted) setState(() => _newPhotoBase64 = photo);
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final saved = await ref.read(profileControllerProvider.notifier).save(
          displayName: _nameController.text,
          photoBase64: _newPhotoBase64,
        );
    if (!saved || !mounted) return;

    final l10n = AppLocalizations.of(context);
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(l10n.profileSaved)));
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final state = ref.watch(profileControllerProvider);

    final String? errorText;
    if (state.error != null) {
      errorText = profileErrorMessage(l10n, state.error!);
    } else if (state.photoError != null) {
      errorText = profilePhotoErrorMessage(l10n, state.photoError!);
    } else {
      errorText = null;
    }

    return Scaffold(
      appBar: AppBar(title: Text(l10n.profileEditTitle)),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            Center(
              child: GestureDetector(
                onTap: state.isLoading ? null : _choosePhoto,
                child: ProfileAvatar(
                  photoBase64: _newPhotoBase64 ?? widget.profile.photoBase64,
                  radius: 56,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Center(
              child: TextButton.icon(
                onPressed: state.isLoading ? null : _choosePhoto,
                icon: const Icon(Icons.photo_camera_outlined),
                label: Text(l10n.profileChangePhoto),
              ),
            ),
            const SizedBox(height: 24),
            Form(
              key: _formKey,
              child: TextFormField(
                controller: _nameController,
                enabled: !state.isLoading,
                textInputAction: TextInputAction.done,
                decoration: InputDecoration(
                  labelText: l10n.profileNameLabel,
                  border: const OutlineInputBorder(),
                ),
                validator: (value) {
                  final error = validateDisplayName(value);
                  return error == null
                      ? null
                      : profileErrorMessage(l10n, error);
                },
              ),
            ),
            if (errorText != null) ...[
              const SizedBox(height: 16),
              Text(
                errorText,
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            ],
            const SizedBox(height: 24),
            FilledButton(
              onPressed: state.isLoading ? null : _save,
              child: state.isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text(l10n.profileSaveButton),
            ),
          ],
        ),
      ),
    );
  }
}
