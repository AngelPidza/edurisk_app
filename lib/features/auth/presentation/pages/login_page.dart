import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/auth_provider.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});
  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _obscure = true;
  bool _remember = false;

  static const _testCreds = [
    ('Director', 'director@donbosco.edu'),
    ('Tutor', 'tutor@donbosco.edu'),
    ('Docente', 'docente@donbosco.edu'),
  ];

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Listen for success → navigate
    ref.listen<AuthState>(authProvider, (_, next) {
      if (next is AuthSuccess) context.go('/');
    });

    final state = ref.watch(authProvider);

    return Scaffold(
      backgroundColor: const Color(0xFF1E3A5F),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildBrand(),
              const SizedBox(height: 28),
              _buildCard(state),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBrand() => Column(
    children: [
      Container(
        width: 64,
        height: 64,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 20),
          ],
        ),
        alignment: Alignment.center,
        child: const Text(
          'ED',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: Color(0xFF1E3A5F),
          ),
        ),
      ),
      const SizedBox(height: 12),
      const Text(
        'EduRisk',
        style: TextStyle(
          fontSize: 26,
          fontWeight: FontWeight.w800,
          color: Colors.white,
        ),
      ),
      const SizedBox(height: 4),
      const Text(
        'Sistema de Gestión Académica',
        style: TextStyle(fontSize: 14, color: Colors.white70),
      ),
      const SizedBox(height: 2),
      const Text(
        'Colegio Don Bosco',
        style: TextStyle(fontSize: 13, color: Colors.white38),
      ),
    ],
  );

  Widget _buildCard(AuthState state) => Container(
    width: double.infinity,
    constraints: const BoxConstraints(maxWidth: 420),
    padding: const EdgeInsets.all(36),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      boxShadow: [
        BoxShadow(color: Colors.black.withOpacity(0.25), blurRadius: 40),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Iniciar Sesión',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w800,
            color: Color(0xFF0F172A),
          ),
        ),
        const SizedBox(height: 20),

        if (state is AuthFailure) ...[
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(10),
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: const Color(0xFFFEE2E2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              state.message,
              style: const TextStyle(fontSize: 12, color: Color(0xFFDC2626)),
            ),
          ),
        ],

        _label('Correo Electrónico'),
        const SizedBox(height: 7),
        _input(
          controller: _emailCtrl,
          hint: 'usuario@donbosco.edu',
          icon: Icons.email_outlined,
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: 16),

        _label('Contraseña'),
        const SizedBox(height: 7),
        _input(
          controller: _passCtrl,
          hint: '••••••••',
          icon: Icons.lock_outline_rounded,
          obscure: _obscure,
          suffix: IconButton(
            icon: Icon(
              _obscure
                  ? Icons.visibility_outlined
                  : Icons.visibility_off_outlined,
              size: 18,
              color: Colors.grey,
            ),
            onPressed: () => setState(() => _obscure = !_obscure),
          ),
        ),
        const SizedBox(height: 14),

        // Wrap en vez de Row: en pantallas angostas el enlace baja de línea
        // en lugar de salirse de la tarjeta.
        SizedBox(
          width: double.infinity,
          child: Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 18,
                    height: 18,
                    child: Checkbox(
                      value: _remember,
                      onChanged: (v) => setState(() => _remember = v!),
                      activeColor: const Color(0xFF1E3A5F),
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Recordarme',
                    style: TextStyle(fontSize: 13, color: Color(0xFF374151)),
                  ),
                ],
              ),
              TextButton(
                onPressed: () {},
                child: const Text(
                  '¿Olvidaste tu contraseña?',
                  style: TextStyle(
                    fontSize: 13,
                    color: Color(0xFF1E3A5F),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),

        SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: state is AuthLoading
                ? null
                : () {
                    ref
                        .read(authProvider.notifier)
                        .login(_emailCtrl.text, _passCtrl.text);
                  },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1E3A5F),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: state is AuthLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Text(
                    'Ingresar',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                  ),
          ),
        ),
        const SizedBox(height: 18),

        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: const Color(0xFFEFF6FF),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Credenciales de prueba',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1E40AF),
                ),
              ),
              const Text(
                'Toca una para completar el correo y la contraseña.',
                style: TextStyle(fontSize: 11.5, color: Color(0xFF3B5BA9)),
              ),
              const SizedBox(height: 6),
              ..._testCreds.map(
                (c) => MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: () {
                      _emailCtrl.text = c.$2;
                      _passCtrl.text = '12345678';
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 3),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.touch_app_outlined,
                            size: 13,
                            color: Color(0xFF2563EB),
                          ),
                          const SizedBox(width: 5),
                          Flexible(
                            child: Text(
                              '${c.$1}: ${c.$2}',
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 12,
                                color: Color(0xFF2563EB),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );

  Widget _label(String text) => Text(
    text,
    style: const TextStyle(
      fontSize: 13,
      fontWeight: FontWeight.w500,
      color: Color(0xFF374151),
    ),
  );

  Widget _input({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    TextInputType? keyboardType,
    bool obscure = false,
    Widget? suffix,
  }) => TextField(
    controller: controller,
    obscureText: obscure,
    keyboardType: keyboardType,
    style: const TextStyle(fontSize: 13, color: Color(0xFF0F172A)),
    decoration: InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Color(0xFF9CA3AF), fontSize: 13),
      prefixIcon: Icon(icon, size: 18, color: const Color(0xFF9CA3AF)),
      suffixIcon: suffix,
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color(0xFF1E3A5F), width: 1.5),
      ),
    ),
  );
}
