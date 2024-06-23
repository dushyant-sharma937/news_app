import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    required this.isLogin,
  });

  final bool isLogin;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.6,
      height: MediaQuery.of(context).size.height * 0.06,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Text(
          isLogin ? 'Login' : 'Signup',
          style: Theme.of(context).textTheme.titleSmall,
        ),
      ),
    );
  }
}

class LoginToSignupText extends StatelessWidget {
  const LoginToSignupText({
    super.key,
    required this.isLogin,
    required this.onPressed,
  });

  final bool isLogin;
  final dynamic onPressed;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (isLogin)
          Text(
            "New Here? ",
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        if (!isLogin)
          Text(
            "Already have an account? ",
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        GestureDetector(
          onTap: onPressed,
          child: Text(
            isLogin ? 'Signup' : 'Login',
            style: Theme.of(context).textTheme.titleSmall!.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                ),
          ),
        ),
      ],
    );
  }
}

InputDecoration inputDecorationCustom(BuildContext context, String label) {
  return InputDecoration(
    labelText: label,
    labelStyle: Theme.of(context).textTheme.bodyMedium,
    fillColor: Colors.white,
    filled: true,
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide.none,
    ),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide.none,
    ),
  );
}

class CustomCircleAvatar extends StatelessWidget {
  const CustomCircleAvatar({
    super.key,
    required this.name,
  });

  final String name;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      maxRadius: 23,
      minRadius: 23,
      backgroundColor: Theme.of(context).colorScheme.secondary,
      child: Text(
        name.substring(0, 1).toUpperCase(),
        style: Theme.of(context)
            .textTheme
            .titleSmall!
            .copyWith(color: Colors.black),
      ),
    );
  }
}

class NameRow extends StatelessWidget {
  const NameRow({
    super.key,
    required this.firstLabel,
    required this.secondLabel,
  });

  final String firstLabel;
  final String secondLabel;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          firstLabel,
          style: Theme.of(context).textTheme.bodySmall,
        ),
        Expanded(
          child: Text(
            secondLabel,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
      ],
    );
  }
}

class CustomLoadigIndicator extends StatelessWidget {
  const CustomLoadigIndicator({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.3,
        width: MediaQuery.of(context).size.height * 0.3,
        child: Lottie.asset(
          'assets/loading.json',
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
