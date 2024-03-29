import 'package:app/components/bloc_listener_component.dart';
import 'package:app/domain/interfaces/auth_interface.dart';
import 'package:app/domain/interfaces/day_interface.dart';
import 'package:app/domain/use_cases/auth/get_logged_user_id_use_case.dart';
import 'package:app/domain/use_cases/day/get_user_days_from_month_use_case.dart';
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
      child: _CalendarBlocListener(
        child: CalendarContent(),
      ),
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
        getLoggedUserIdUseCase: GetLoggedUserIdUseCase(
          authInterface: context.read<AuthInterface>(),
        ),
        getUserDaysFromMonthUseCase: GetUserDaysFromMonthUseCase(
          dayInterface: context.read<DayInterface>(),
        ),
      )..add(
          const CalendarEventInitialize(),
        ),
      child: child,
    );
  }
}

class _CalendarBlocListener extends StatelessWidget {
  final Widget child;

  const _CalendarBlocListener({required this.child});

  @override
  Widget build(BuildContext context) {
    return BlocListenerComponent<CalendarBloc, CalendarState, dynamic, dynamic>(
      child: child,
    );
  }
}
