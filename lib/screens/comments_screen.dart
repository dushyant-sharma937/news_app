import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:newsapp/provider/auth_provider.dart';
import 'package:newsapp/provider/comments_provider.dart';
import 'package:newsapp/screens/signup_screen.dart';
import 'package:newsapp/utils/widgets.dart';
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
      body: Consumer<CommentsProvider>(
        builder: (context, commentsProvider, state) {
          if (commentsProvider.isLoading) {
            return const CustomLoadigIndicator();
          } else if (commentsProvider.error != null) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      commentsProvider.error!,
                      style: const TextStyle(color: Colors.red),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: commentsProvider.retryFetchingComments,
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all(
                          Theme.of(context).colorScheme.primary,
                        ),
                        shape: WidgetStateProperty.all(
                          const CircleBorder(),
                        ),
                      ),
                      child: const Icon(
                        Icons.refresh,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ],
                ),
              ),
            );
          } else {
            return ListView.builder(
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
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomCircleAvatar(name: name),
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
                    return const CustomLoadigIndicator();
                  } else {
                    return const SizedBox.shrink();
                  }
                }
              },
            );
          }
        },
      ),
    );
  }
}
