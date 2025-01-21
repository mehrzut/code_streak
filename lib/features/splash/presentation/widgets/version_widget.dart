import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:skeletonizer/skeletonizer.dart';

class VersionWidget extends StatelessWidget {
  const VersionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<PackageInfo>(
        future: PackageInfo.fromPlatform(),
        builder: (context, snapshot) {
          return Skeletonizer(
            enabled: !snapshot.hasData,
            enableSwitchAnimation: true,
            child: Text(
              'V${snapshot.data?.version ?? '0.0.0'}',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
          );
        });
  }
}
