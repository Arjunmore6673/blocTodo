import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:schoolmanage/todos_repository/src/firebase_todos_repository.dart';
import 'package:schoolmanage/todos_repository/todos_repository.dart';
import 'package:schoolmanage/blocs/blocs.dart';
import 'package:schoolmanage/screens/screens.dart';

void main() {
  BlocSupervisor.delegate = SimpleBlocDelegate();
  runApp(TodosApp());
}

class TodosApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<TodosBloc>(
          create: (context) {
            return TodosBloc(
              todosRepository: FirebaseTodosRepository(),
            )..add(LoadTodos());
          },
        )
      ],
      child: MaterialApp(
        title: 'Firestore Todos',
        routes: {
          '/': (context) {
            return MultiBlocProvider(
              providers: [
                BlocProvider<TabBloc>(
                  create: (context) => TabBloc(),
                ),
                BlocProvider<FilteredTodosBloc>(
                  create: (context) => FilteredTodosBloc(
                    todosBloc: BlocProvider.of<TodosBloc>(context),
                  ),
                ),
                BlocProvider<StatsBloc>(
                  create: (context) => StatsBloc(
                    todosBloc: BlocProvider.of<TodosBloc>(context),
                  ),
                ),
              ],
              child: HomeScreen(),
            );
          },
          '/addTodo': (context) {
            return AddEditScreen(
              onSave: (task, note) {
                BlocProvider.of<TodosBloc>(context).add(
                  AddTodo(Todo(task, note: note)),
                );
              },
              isEditing: false,
            );
          },
        },
      ),
    );
  }
}
