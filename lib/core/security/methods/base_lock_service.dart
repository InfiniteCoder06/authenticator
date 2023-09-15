part of security_service;

abstract class _BaseLockService<T extends _BaseLockOptions> {
  Future<bool> unlock(T option);
  Future<bool> set(T option);
  Future<bool> remove(T option);

  Widget buildFooter(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: AppButton(
        backgroundColor: Theme.of(context).colorScheme.elevation.surface1,
        foregroundColor: Theme.of(context).colorScheme.onSurface,
        label: "No Access?",
        onTap: () => {},
      ),
    );
  }
}
