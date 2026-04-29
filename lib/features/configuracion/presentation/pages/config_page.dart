import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../providers/config_provider.dart';
import '../../../dashboard/presentation/pages/dashboard_page.dart'
    show AppTopBar;

class ConfigPage extends ConsumerWidget {
  const ConfigPage({super.key});

  static const _tabs = [
    ('perfil', 'Perfil', Icons.person_outline_rounded),
    ('notificaciones', 'Notificaciones', Icons.notifications_outlined),
    ('sistema', 'Sistema', Icons.storage_outlined),
    ('apariencia', 'Apariencia', Icons.palette_outlined),
    ('seguridad', 'Seguridad', Icons.shield_outlined),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeTab = ref.watch(configTabProvider);

    return Scaffold(
      backgroundColor: AppTheme.bgBase,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AppTopBar(title: 'Configuración'),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Configuración',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  const Text(
                    'Administra las preferencias de tu cuenta y del sistema',
                    style: TextStyle(fontSize: 13, color: AppTheme.textMuted),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Tab nav
                      Container(
                        width: 200,
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppTheme.bgCard,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: AppTheme.borderSubtle),
                        ),
                        child: Column(
                          children: _tabs.map((t) {
                            final isActive = activeTab == t.$1;
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 2),
                              child: Material(
                                color: isActive
                                    ? AppTheme.accentBlue
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(9),
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(9),
                                  onTap: () =>
                                      ref
                                              .read(configTabProvider.notifier)
                                              .state =
                                          t.$1,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 9,
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(
                                          t.$3,
                                          size: 15,
                                          color: isActive
                                              ? Colors.white
                                              : AppTheme.textSecondary,
                                        ),
                                        const SizedBox(width: 9),
                                        Text(
                                          t.$2,
                                          style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: isActive
                                                ? FontWeight.w500
                                                : FontWeight.w400,
                                            color: isActive
                                                ? Colors.white
                                                : AppTheme.textSecondary,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                      const SizedBox(width: 16),
                      // Panel
                      Expanded(
                        child: activeTab == 'perfil'
                            ? const _ProfilePanel()
                            : _PlaceholderPanel(tab: activeTab),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfilePanel extends ConsumerWidget {
  const _ProfilePanel();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(profileProvider);
    final saved = ref.watch(profileSavedProvider);

    return profileAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) =>
          Text('Error: $e', style: const TextStyle(color: AppTheme.accentRed)),
      data: (profile) {
        // Init form once
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (ref.read(profileFormProvider) == null) {
            ref.read(profileFormProvider.notifier).init(profile);
          }
        });

        final form = ref.watch(profileFormProvider) ?? profile;

        return Container(
          padding: const EdgeInsets.all(26),
          decoration: BoxDecoration(
            color: AppTheme.bgCard,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppTheme.borderSubtle),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Información del Perfil',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textPrimary,
                ),
              ),
              const Text(
                'Actualiza tu información personal y de contacto',
                style: TextStyle(fontSize: 12, color: AppTheme.textMuted),
              ),
              const SizedBox(height: 22),
              Row(
                children: [
                  Expanded(
                    child: _FormField(
                      label: 'Nombre Completo',
                      initial: form.name,
                      onChanged: (v) =>
                          ref.read(profileFormProvider.notifier).updateName(v),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: _FormField(
                      label: 'Correo Electrónico',
                      initial: form.email,
                      onChanged: (v) =>
                          ref.read(profileFormProvider.notifier).updateEmail(v),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              Row(
                children: [
                  Expanded(
                    child: _FormField(
                      label: 'Rol',
                      initial: form.role,
                      enabled: false,
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: _FormField(
                      label: 'Teléfono',
                      initial: form.phone,
                      onChanged: (v) =>
                          ref.read(profileFormProvider.notifier).updatePhone(v),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              const Divider(color: AppTheme.borderSubtle),
              const SizedBox(height: 14),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      ref.read(profileFormProvider.notifier).init(profile);
                      ref.read(profileSavedProvider.notifier).state = false;
                    },
                    child: const Text(
                      'Cancelar',
                      style: TextStyle(color: AppTheme.textSecondary),
                    ),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton.icon(
                    onPressed: () =>
                        ref.read(profileSavedProvider.notifier).state = true,
                    icon: Icon(
                      saved ? Icons.check_rounded : Icons.save_outlined,
                      size: 15,
                    ),
                    label: Text(saved ? 'Guardado' : 'Guardar Cambios'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.accentBlue,
                      foregroundColor: Colors.white,
                      textStyle: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(9),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class _FormField extends StatefulWidget {
  final String label;
  final String initial;
  final bool enabled;
  final ValueChanged<String>? onChanged;
  const _FormField({
    required this.label,
    required this.initial,
    this.enabled = true,
    this.onChanged,
  });
  @override
  State<_FormField> createState() => _FormFieldState();
}

class _FormFieldState extends State<_FormField> {
  late final TextEditingController _ctrl;
  @override
  void initState() {
    super.initState();
    _ctrl = TextEditingController(text: widget.initial);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        widget.label,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: AppTheme.textSecondary,
        ),
      ),
      const SizedBox(height: 7),
      TextField(
        controller: _ctrl,
        enabled: widget.enabled,
        onChanged: widget.onChanged,
        style: TextStyle(
          fontSize: 13,
          color: widget.enabled ? AppTheme.textPrimary : AppTheme.textMuted,
        ),
        decoration: InputDecoration(
          filled: true,
          fillColor: AppTheme.bgInput,
          contentPadding: const EdgeInsets.symmetric(
            vertical: 10,
            horizontal: 14,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(9),
            borderSide: const BorderSide(color: AppTheme.border),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(9),
            borderSide: const BorderSide(color: AppTheme.border),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(9),
            borderSide: const BorderSide(color: AppTheme.accentBlue),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(9),
            borderSide: const BorderSide(color: AppTheme.borderSubtle),
          ),
        ),
      ),
    ],
  );
}

class _PlaceholderPanel extends StatelessWidget {
  final String tab;
  const _PlaceholderPanel({required this.tab});

  @override
  Widget build(BuildContext context) => Container(
    height: 300,
    decoration: BoxDecoration(
      color: AppTheme.bgCard,
      borderRadius: BorderRadius.circular(14),
      border: Border.all(color: AppTheme.borderSubtle),
    ),
    child: Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.construction_rounded,
            size: 36,
            color: AppTheme.textMuted,
          ),
          const SizedBox(height: 12),
          Text(
            'Sección "$tab" en construcción',
            style: const TextStyle(fontSize: 13, color: AppTheme.textMuted),
          ),
        ],
      ),
    ),
  );
}
