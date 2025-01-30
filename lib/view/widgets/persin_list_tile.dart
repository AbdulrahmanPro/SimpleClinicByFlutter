import 'package:flutter/material.dart';
import 'package:test_provider_mvvm/model/person_model.dart';

class PersonTile extends StatelessWidget {
  final PersonModel person;
  final VoidCallback onDelete;
  final VoidCallback onTap;

  const PersonTile({
    required Key key,
    required this.person,
    required this.onDelete,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          // gradient: const LinearGradient(
          //   colors: [
          //     Color.fromARGB(255, 6, 131, 159),
          //     Color.fromARGB(255, 8, 153, 179)
          //   ],
          //   begin: Alignment.topLeft,
          //   end: Alignment.bottomRight,
          // ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 25,
              // backgroundColor: Colors.white.withOpacity(0.2),
              child: Icon(
                person.gender == 'M' ? Icons.man : Icons.woman,
                size: 40,
                // color: Colors.white,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    person.personName,
                    style: const TextStyle(
                      // color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    person.email,
                    style: const TextStyle(
                      // color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(
                Icons.delete,
              ),
              onPressed: onDelete,
            ),
          ],
        ),
      ),
    );
  }
}
