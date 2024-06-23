import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:newsapp/provider/auth_provider.dart';
import 'package:newsapp/provider/comments_provider.dart';
import 'package:newsapp/screens/signup_screen.dart';
import 'package:provider/provider.dart';

class CommentsScreen extends StatefulWidget {
  const CommentsScreen({super.key});

  @override
  State<CommentsScreen> createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
  bool maskEmail = false;
  @override
  void initState() {
    super.initState();
    _initializeRemoteConfig();
  }

  Future<void> _initializeRemoteConfig() async {
    final remoteConfig = FirebaseRemoteConfig.instance;
    await remoteConfig.setDefaults(<String, dynamic>{
      'mask_email': false,
    });
    await remoteConfig.fetchAndActivate();
    setState(() {
      maskEmail = remoteConfig.getBool('mask_email');
    });
    remoteConfig.onConfigUpdated.listen((RemoteConfigUpdate event) async {
      await remoteConfig.activate();
      setState(() {
        maskEmail = remoteConfig.getBool('mask_email');
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final commentsProvider = Provider.of<CommentsProvider>(context);
    final authProvider = Provider.of<AuthenticationProvider>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text(
          'Comments',
          style: Theme.of(context).textTheme.titleSmall,
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.logout,
              color: Colors.white,
            ),
            onPressed: () {
              authProvider.signOut();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const SignupScreen()),
              );
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: commentsProvider.comments.length + 1,
        itemBuilder: (context, index) {
          if (index < commentsProvider.comments.length) {
            final comment = commentsProvider.comments[index];
            final email = comment['email'];
            final name = comment['name'];
            final body = comment['body'];
            return Container(
              padding: const EdgeInsets.all(12),
              margin: const EdgeInsets.only(left: 16, right: 16, top: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
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
                  ),
                  const SizedBox(width: 8),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.7,
                    child: Column(
                      children: [
                        NameRow(
                          firstLabel: 'Name: ',
                          secondLabel: name,
                        ),
                        NameRow(
                          firstLabel: 'Email: ',
                          secondLabel: maskEmail
                              ? commentsProvider.maskEmail(email)
                              : email,
                        ),
                        Text(
                          body,
                          maxLines: 4,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          } else {
            if (commentsProvider.shouldLoadMore(index)) {
              return const Center(child: CircularProgressIndicator());
            } else {
              return const SizedBox.shrink();
            }
          }
        },
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
