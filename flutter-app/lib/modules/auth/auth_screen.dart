import 'package:flutter/material.dart';

import '../../app_state.dart';
import '../../core/theme.dart';
import '../../widgets/brand.dart';
import '../../widgets/toast.dart';
import 'auth_controller.dart';

/// Écran Connexion / Inscription — refonte navy + or + crème :
/// héros de marque avec photo en arche, panneau crème, onglets segmentés,
/// champs à icône, CTA doré et connexion Google (démo).
class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  late final AuthController _controller;
  var _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialized) return;
    _initialized = true;
    _controller = AuthController(VestaScope.of(context).auth)..addListener(_onChanged);
  }

  void _onChanged() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _controller.removeListener(_onChanged);
    _controller.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final app = VestaScope.of(context);
    final ok = await _controller.submit();
    if (!ok || !mounted) return;
    app.signIn(email: _controller.emailController.text, name: _controller.nameController.text);
    VestaToast.show(context, 'Mode démo : navigation uniquement, aucune donnée enregistrée.');
  }

  void _enterWithoutAccount() {
    VestaScope.of(context).signIn(email: 'visiteur@vesta.tn');
    VestaToast.show(context, 'Mode démo : navigation uniquement, aucune donnée enregistrée.');
  }

  @override
  Widget build(BuildContext context) {
    final c = _controller;
    return Scaffold(
      backgroundColor: VestaColors.sheet,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const _AuthHero(),
            Transform.translate(
              offset: const Offset(0, -30),
              child: _AuthSheet(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Eyebrow('Bienvenue sur Vesta'),
                    const SizedBox(height: 8),
                    Text(
                      'Trouvez votre place.',
                      style: Theme.of(context).extension<VestaTextStyle>()!.serifStyle(31, height: 1.1),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Explorez les biens qui vous ressemblent,\npartout en Tunisie.',
                      style: TextStyle(fontFamily: VestaFonts.sans, fontSize: 13.5, height: 1.5, color: VestaColors.muted),
                    ),
                    const SizedBox(height: 22),
                    _SegmentedTabs(controller: c),
                    const SizedBox(height: 24),
                    if (c.signupTab) _SignupForm(controller: c, onSubmit: _submit) else _LoginForm(controller: c, onSubmit: _submit),
                    const SizedBox(height: 6),
                    const _OrDivider(),
                    const SizedBox(height: 16),
                    _GoogleButton(
                      onTap: () => VestaToast.show(context, 'Connexion Google : prototype de navigation uniquement.'),
                    ),
                    const SizedBox(height: 18),
                    _DemoNote(onEnter: _enterWithoutAccount),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Héros : fond navy, logo, accroche et photo en arche dorée.
class _AuthHero extends StatelessWidget {
  const _AuthHero();

  @override
  Widget build(BuildContext context) {
    final title = Theme.of(context).extension<VestaTextStyle>()!.serifStyle(37, color: Colors.white, height: 1.1);
    return SizedBox(
      height: 372,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Fond dégradé navy.
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: const Alignment(0.75, -0.5),
                  radius: 1.5,
                  colors: [VestaColors.authTop1, VestaColors.authTop2, VestaColors.authTop3],
                  stops: const [0.0, 0.45, 1.0],
                ),
              ),
            ),
          ),

          // Photo en arche, bordure dorée en retrait.
          Positioned(
            right: -58,
            top: -34,
            child: Container(
              width: 288,
              height: 348,
              decoration: BoxDecoration(
                border: Border.all(color: VestaColors.goldEm.withValues(alpha: 0.75), width: 1.5),
                borderRadius: const BorderRadius.horizontal(left: Radius.circular(144)),
              ),
            ),
          ),
          Positioned(
            right: -44,
            top: -22,
            child: Container(
              width: 262,
              height: 330,
              clipBehavior: Clip.antiAlias,
              decoration: const BoxDecoration(
                color: VestaColors.heroPhoto,
                borderRadius: BorderRadius.horizontal(left: Radius.circular(131)),
              ),
              child: Image.asset(
                'assets/images/villa.png',
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => const ColoredBox(color: VestaColors.heroPhoto),
              ),
            ),
          ),

          // Logo.
          const Positioned(left: 24, top: 34, child: BrandLogo(light: true, fontSize: 30)),

          // Accroche.
          Positioned(
            left: 24,
            right: 150,
            top: 116,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Eyebrow('Votre prochain chez-vous', color: VestaColors.eyebrowOnDark),
                const SizedBox(height: 12),
                Text.rich(
                  TextSpan(
                    text: 'Un lieu à vous, ',
                    children: [
                      TextSpan(
                        text: 'une',
                        style: TextStyle(color: VestaColors.goldEm, fontStyle: FontStyle.italic),
                      ),
                      const TextSpan(text: ' histoire à écrire.'),
                    ],
                  ),
                  style: title,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Panneau crème arrondi qui chevauche le héros (avec décorations).
class _AuthSheet extends StatelessWidget {
  const _AuthSheet({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: const BoxDecoration(
        color: VestaColors.sheet,
        borderRadius: BorderRadius.vertical(top: Radius.circular(36)),
      ),
      padding: const EdgeInsets.fromLTRB(26, 34, 26, 34),
      child: Stack(
        children: [
          // Vagues décoratives (derrière le contenu).
          Positioned(right: -70, bottom: -78, child: _Wave(width: 300, height: 170, color: VestaColors.wave)),
          Positioned(left: -80, bottom: -96, child: _Wave(width: 250, height: 150, color: const Color(0xFFF6EEDC))),
          // Feuillage navy en bas à gauche.
          Positioned(left: -6, bottom: 6, child: CustomPaint(size: const Size(74, 96), painter: const _LeafBranchPainter())),
          // Le contenu dimensionne le Stack ; les décors sont ancrés en bas.
          child,
        ],
      ),
    );
  }
}

/// Onde elliptique décorative.
class _Wave extends StatelessWidget {
  const _Wave({required this.width, required this.height, required this.color});

  final double width;
  final double height;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.all(Radius.elliptical(width / 2, height / 2)),
      ),
    );
  }
}

/// Branche de feuilles navy (décor de bas de page).
class _LeafBranchPainter extends CustomPainter {
  const _LeafBranchPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final stem = Paint()
      ..color = VestaColors.ink
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.4
      ..strokeCap = StrokeCap.round;
    final leaf = Paint()..color = VestaColors.ink;

    final path = Path()
      ..moveTo(size.width * 0.06, size.height)
      ..quadraticBezierTo(size.width * 0.42, size.height * 0.6, size.width * 0.72, size.height * 0.1);
    canvas.drawPath(path, stem);

    for (var i = 0; i < 5; i++) {
      final t = 0.18 + i * 0.18;
      final point = _quadratic(
        Offset(size.width * 0.06, size.height),
        Offset(size.width * 0.42, size.height * 0.6),
        Offset(size.width * 0.72, size.height * 0.1),
        t,
      );
      final angle = -0.75 + (i.isEven ? 0.55 : -0.55);
      canvas.save();
      canvas.translate(point.dx, point.dy);
      canvas.rotate(angle);
      canvas.drawOval(Rect.fromCenter(center: Offset.zero, width: 26, height: 11), leaf);
      canvas.restore();
    }
  }

  Offset _quadratic(Offset start, Offset control, Offset end, double t) {
    final mt = 1 - t;
    return Offset(
      mt * mt * start.dx + 2 * mt * t * control.dx + t * t * end.dx,
      mt * mt * start.dy + 2 * mt * t * control.dy + t * t * end.dy,
    );
  }

  @override
  bool shouldRepaint(_LeafBranchPainter oldDelegate) => false;
}

/// Onglets segmentés « CONNEXION / INSCRIPTION ».
class _SegmentedTabs extends StatelessWidget {
  const _SegmentedTabs({required this.controller});

  final AuthController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: VestaColors.sheetTrack,
        borderRadius: BorderRadius.circular(28),
      ),
      child: Row(
        children: [
          _Segment(
            label: 'Connexion',
            active: !controller.signupTab,
            onTap: () => controller.setTab(signup: false),
          ),
          _Segment(
            label: 'Inscription',
            active: controller.signupTab,
            onTap: () => controller.setTab(signup: true),
          ),
        ],
      ),
    );
  }
}

class _Segment extends StatelessWidget {
  const _Segment({required this.label, required this.active, required this.onTap});

  final String label;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: active ? VestaColors.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Text(
            label.toUpperCase(),
            style: TextStyle(
              fontFamily: VestaFonts.sans,
              fontSize: 13,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.6,
              color: active ? Colors.white : VestaColors.muted2,
            ),
          ),
        ),
      ),
    );
  }
}

/// Champ avec libellé capitales et icône de préfixe.
class _Field extends StatelessWidget {
  const _Field({
    required this.label,
    required this.controller,
    required this.icon,
    this.hint,
    this.keyboardType,
    this.textInputAction,
    this.obscure = false,
    this.onToggleObscure,
    this.onSubmitted,
  });

  final String label;
  final TextEditingController controller;
  final IconData icon;
  final String? hint;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final bool obscure;
  final VoidCallback? onToggleObscure;
  final VoidCallback? onSubmitted;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label.toUpperCase(),
            style: const TextStyle(
              fontFamily: VestaFonts.sans,
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.3,
              color: VestaColors.ink,
            ),
          ),
          const SizedBox(height: 9),
          Container(
            height: 54,
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: VestaColors.borderInput),
            ),
            child: Row(
              children: [
                Icon(icon, size: 19, color: VestaColors.muted2),
                const SizedBox(width: 11),
                Expanded(
                  child: TextField(
                    controller: controller,
                    keyboardType: keyboardType,
                    textInputAction: textInputAction,
                    obscureText: obscure,
                    onSubmitted: (_) => onSubmitted?.call(),
                    style: const TextStyle(fontFamily: VestaFonts.sans, fontSize: 13.5, color: VestaColors.ink),
                    decoration: InputDecoration(
                      hintText: hint,
                      isDense: true,
                      contentPadding: EdgeInsets.zero,
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      filled: false,
                      hintStyle: const TextStyle(
                        fontFamily: VestaFonts.sans,
                        fontSize: 13.5,
                        color: VestaColors.placeholder,
                      ),
                    ),
                  ),
                ),
                if (onToggleObscure != null)
                  GestureDetector(
                    onTap: onToggleObscure,
                    behavior: HitTestBehavior.opaque,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Text(
                        obscure ? 'AFFICHER' : 'MASQUER',
                        style: const TextStyle(
                          fontFamily: VestaFonts.sans,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1,
                          color: VestaColors.ink,
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
  }
}

/// Encadré d'erreur.
class _FormError extends StatelessWidget {
  const _FormError({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(color: VestaColors.errorBg, borderRadius: BorderRadius.circular(10)),
      child: Text(
        message,
        style: const TextStyle(fontFamily: VestaFonts.sans, fontSize: 12, color: VestaColors.errorText),
      ),
    );
  }
}

class _LoginForm extends StatelessWidget {
  const _LoginForm({required this.controller, required this.onSubmit});

  final AuthController controller;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _Field(
          label: 'Adresse e-mail',
          controller: controller.emailController,
          icon: Icons.mail_outline,
          hint: 'nom@exemple.com',
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
        ),
        _Field(
          label: 'Mot de passe',
          controller: controller.passwordController,
          icon: Icons.lock_outline,
          hint: 'Votre mot de passe',
          obscure: controller.obscurePassword,
          onToggleObscure: controller.togglePasswordVisibility,
          onSubmitted: onSubmit,
        ),
        if (controller.error != null) _FormError(message: controller.error!),
        _SubmitButton(loading: controller.loading, label: 'Se connecter', onTap: onSubmit),
      ],
    );
  }
}

class _SignupForm extends StatelessWidget {
  const _SignupForm({required this.controller, required this.onSubmit});

  final AuthController controller;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _Field(
          label: 'Nom complet',
          controller: controller.nameController,
          icon: Icons.person_outline,
          hint: 'Votre nom',
          textInputAction: TextInputAction.next,
        ),
        _Field(
          label: 'Adresse e-mail',
          controller: controller.emailController,
          icon: Icons.mail_outline,
          hint: 'nom@exemple.com',
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
        ),
        _Field(
          label: 'Mot de passe',
          controller: controller.passwordController,
          icon: Icons.lock_outline,
          hint: '6 caractères minimum',
          obscure: controller.obscurePassword,
          onToggleObscure: controller.togglePasswordVisibility,
          textInputAction: TextInputAction.next,
        ),
        _Field(
          label: 'Confirmer le mot de passe',
          controller: controller.confirmController,
          icon: Icons.lock_outline,
          hint: 'Répétez le mot de passe',
          obscure: controller.obscureConfirm,
          onToggleObscure: controller.toggleConfirmVisibility,
          onSubmitted: onSubmit,
        ),
        if (controller.error != null) _FormError(message: controller.error!),
        _SubmitButton(loading: controller.loading, label: 'Créer mon compte', onTap: onSubmit),
      ],
    );
  }
}

/// CTA doré façon maquette.
class _SubmitButton extends StatelessWidget {
  const _SubmitButton({required this.label, required this.onTap, this.loading = false});

  final String label;
  final VoidCallback onTap;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 54,
      child: ElevatedButton(
        onPressed: loading ? null : onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: VestaColors.gold,
          disabledBackgroundColor: VestaColors.gold.withValues(alpha: 0.6),
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
        child: loading
            ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    label.toUpperCase(),
                    style: const TextStyle(
                      fontFamily: VestaFonts.sans,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.6,
                    ),
                  ),
                  const SizedBox(width: 14),
                  const Text('→', style: TextStyle(fontSize: 15)),
                ],
              ),
      ),
    );
  }
}

/// Séparateur « OU ».
class _OrDivider extends StatelessWidget {
  const _OrDivider();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(child: Divider(color: VestaColors.borderInput)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: Text(
            'OU',
            style: TextStyle(
              fontFamily: VestaFonts.sans,
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.5,
              color: VestaColors.muted2,
            ),
          ),
        ),
        const Expanded(child: Divider(color: VestaColors.borderInput)),
      ],
    );
  }
}

/// Bouton « Se connecter avec Google ».
class _GoogleButton extends StatelessWidget {
  const _GoogleButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 54,
      child: OutlinedButton(
        onPressed: onTap,
        style: OutlinedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: VestaColors.ink,
          side: const BorderSide(color: VestaColors.borderInput),
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 26,
              height: 26,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(color: VestaColors.borderInput),
              ),
              child: const Text(
                'G',
                style: TextStyle(
                  fontFamily: VestaFonts.sans,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF4285F4),
                  height: 1,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Flexible(
              child: Text(
                'Se connecter avec Google',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontFamily: VestaFonts.sans,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: VestaColors.ink,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Note de démonstration + lien d'entrée sans compte.
class _DemoNote extends StatelessWidget {
  const _DemoNote({required this.onEnter});

  final VoidCallback onEnter;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          'Prototype de navigation uniquement : aucun compte n’est créé.',
          textAlign: TextAlign.center,
          style: TextStyle(fontFamily: VestaFonts.sans, fontSize: 11.5, height: 1.6, color: VestaColors.muted2),
        ),
        const SizedBox(height: 4),
        TextButton(
          onPressed: onEnter,
          child: const Text(
            'Explorer sans compte',
            style: TextStyle(
              fontFamily: VestaFonts.sans,
              fontSize: 13,
              fontWeight: FontWeight.w700,
              decoration: TextDecoration.underline,
              color: VestaColors.ink,
            ),
          ),
        ),
      ],
    );
  }
}
