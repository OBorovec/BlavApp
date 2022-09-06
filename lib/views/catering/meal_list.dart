import 'package:blavapp/bloc/catering/filter_meals/filter_meals_bloc.dart';
import 'package:blavapp/model/catering.dart';
import 'package:blavapp/views/catering/meal_list_card.dart';
import 'package:blavapp/views/catering/meal_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:implicitly_animated_reorderable_list/implicitly_animated_reorderable_list.dart';

class MealList extends StatelessWidget {
  const MealList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FilterMealsBloc, FilterMealsState>(
      builder: (context, state) {
        return Column(
          children: [
            if (state.searchActive) ...[
              const SizedBox(height: 8),
              const MealSearch(),
              const Divider(),
            ],
            Expanded(
              child: ImplicitlyAnimatedList<MealItem>(
                items: state.itemsFiltered,
                padding: const EdgeInsets.only(bottom: 64.0),
                areItemsTheSame: (a, b) => a.id == b.id,
                updateDuration: const Duration(milliseconds: 200),
                insertDuration: const Duration(milliseconds: 200),
                removeDuration: const Duration(milliseconds: 200),
                itemBuilder: (context, animation, item, index) {
                  return SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(-1, 0),
                      end: Offset.zero,
                    ).animate(animation),
                    child: MealItemCard(
                      item: item,
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
