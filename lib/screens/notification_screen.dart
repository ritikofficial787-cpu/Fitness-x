import 'package:flutter/material.dart';

/// Notification screen showing a list of user notifications.
class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final List<Map<String, dynamic>> _notifications = [
    {
      'id': 1,
      'title': 'Hey, it\'s time for lunch',
      'message': 'About 1 minute ago',
      'isRead': 0,
    },
    {
      'id': 2,
      'title': 'Don\'t miss your Lowerbody Workout',
      'message': 'About 3 hours ago',
      'isRead': 0,
    },
    {
      'id': 3,
      'title': 'Congratulations, You have finished Upperbody',
      'message': '29 May',
      'isRead': 1,
    },
    {
      'id': 4,
      'title': 'Hey, let\'s add some meals for your target',
      'message': '8 April',
      'isRead': 1,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),
            _buildHeader(),
            const SizedBox(height: 20),
            Expanded(
              child: _notifications.isEmpty
                  ? _buildEmptyState()
                  : _buildNotificationList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: const Color(0xFFF7F8F8),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.arrow_back_ios_new,
                  size: 14, color: Color(0xFF1D1617)),
            ),
          ),
          const Text(
            'Notification',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1D1617),
            ),
          ),
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: const Color(0xFFF7F8F8),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.more_horiz,
                size: 18, color: Color(0xFF1D1617)),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.notifications_none,
            size: 60,
            color: Color(0xFFADA4A5),
          ),
          SizedBox(height: 15),
          Text(
            'No notifications yet',
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFFADA4A5),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationList() {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: _notifications.length,
      separatorBuilder: (_, _) => const Divider(
        color: Color(0xFFF7F8F8),
        height: 1,
      ),
      itemBuilder: (context, index) {
        final notif = _notifications[index];
        final isRead = (notif['isRead'] as int) == 1;

        // Choose icon based on notification content
        IconData icon = Icons.notifications_outlined;
        Color iconColor = const Color(0xFF92A3FD);

        final title = (notif['title'] as String).toLowerCase();
        if (title.contains('workout') || title.contains('finished')) {
          icon = Icons.fitness_center;
          iconColor = const Color(0xFFC58BF2);
        } else if (title.contains('lunch') || title.contains('meal') ||
            title.contains('breakfast')) {
          icon = Icons.restaurant_outlined;
          iconColor = const Color(0xFFFF7F7F);
        } else if (title.contains('congratulations')) {
          icon = Icons.emoji_events_outlined;
          iconColor = const Color(0xFFF7C948);
        }

        return Dismissible(
          key: Key('notif_${notif['id']}'),
          direction: DismissDirection.endToStart,
          background: Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 20),
            color: Colors.red.withValues(alpha: 0.1),
            child: const Icon(Icons.delete_outline, color: Colors.red),
          ),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: isRead
                  ? Colors.white
                  : const Color(0xFF92A3FD).withValues(alpha: 0.05),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: iconColor.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: iconColor, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        notif['title'] as String,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight:
                              isRead ? FontWeight.w400 : FontWeight.w600,
                          color: const Color(0xFF1D1617),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        notif['message'] as String,
                        style: const TextStyle(
                          fontSize: 10,
                          color: Color(0xFFADA4A5),
                        ),
                      ),
                    ],
                  ),
                ),
                if (!isRead)
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: Color(0xFF92A3FD),
                      shape: BoxShape.circle,
                    ),
                  ),
              ],
            ),
          ),
          onDismissed: (_) {
            setState(() {
              _notifications.removeAt(index);
            });
          },
        );
      },
    );
  }
}
