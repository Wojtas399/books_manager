import 'package:app/features/calendar/bloc/calendar_bloc.dart';
import 'package:app/features/calendar/components/calendar_content.dart';
import 'package:app/providers/date_provider.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CalendarScreen extends StatelessWidget {
  const CalendarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const _CalendarBlocProvider(
      child: CalendarContent(),
    );
  }
}

class _CalendarBlocProvider extends StatelessWidget {
  final Widget child;

  const _CalendarBlocProvider({required this.child});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CalendarBloc(
        dateProvider: DateProvider(),
      )..add(
          const CalendarEventInitialize(),
        ),
      child: child,
    );
  }
}
