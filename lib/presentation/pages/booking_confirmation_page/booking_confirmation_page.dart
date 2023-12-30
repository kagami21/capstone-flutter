import 'package:flix_movie/domain/entities/movie_detail/movie_detail.dart';
import 'package:flix_movie/domain/entities/result/result.dart';
import 'package:flix_movie/domain/entities/transaction/transaction.dart';
import 'package:flix_movie/domain/usecases/create_transaction/create_transaction.dart';
import 'package:flix_movie/domain/usecases/create_transaction/create_transaction_param.dart';
import 'package:flix_movie/presentation/extensions/build_context_extension.dart';
import 'package:flix_movie/presentation/extensions/int_extension.dart';
import 'package:flix_movie/presentation/misc/constants.dart';
import 'package:flix_movie/presentation/misc/methods.dart';
import 'package:flix_movie/presentation/pages/booking_confirmation_page/methods/transaction_row.dart';
import 'package:flix_movie/presentation/providers/router/router_provider.dart';
import 'package:flix_movie/presentation/providers/transaction_data/transaction_data_provider.dart';
import 'package:flix_movie/presentation/providers/usecases/create_transaction_provider.dart';
import 'package:flix_movie/presentation/providers/user_data/user_data_provider.dart';
import 'package:flix_movie/presentation/widgets/back_navigation_bar.dart';
import 'package:flix_movie/presentation/widgets/network_image_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class BookingConfirmationPage extends ConsumerWidget {
  final (MovieDetail, Transaction) transactionDetail;

  const BookingConfirmationPage({required this.transactionDetail, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var (movieDetail, transaction) = transactionDetail;

    transaction = transaction.copyWith(
        total: transaction.ticketAmount! * transaction.ticketPrice! +
            transaction.adminFee);

    return Scaffold(
        body: ListView(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 40),
          child: Column(
            children: [
              BackNavigationBar(
                'Booking Confirmation',
                onTap: () => ref.read(routerProvider).pop(),
              ),
              verticalSpace(24),
              NetworkImageCard(
                width: MediaQuery.of(context).size.width - 48,
                height: (MediaQuery.of(context).size.width - 48) * 0.6,
                borderRadius: 15,
                imageUrl:
                    'https://image.tmdb.org/t/p/w500${movieDetail.backdropPath ?? movieDetail.posterPath}',
                fit: BoxFit.cover,
              ),
              verticalSpace(24),
              SizedBox(
                width: MediaQuery.of(context).size.width - 48,
                child: Text(
                  transaction.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              verticalSpace(5),
              const Divider(color: ghostWhite),
              verticalSpace(5),
              transactionRow(
                title: 'Showing Date',
                value: DateFormat('EEEE, d MMMM y').format(
                  DateTime.fromMillisecondsSinceEpoch(
                      transaction.watchingTime ?? 0),
                ),
                width: MediaQuery.of(context).size.width - 48,
              ),
              transactionRow(
                title: 'Theater',
                value: '${transaction.theaterName}',
                width: MediaQuery.of(context).size.width - 48,
              ),
              transactionRow(
                title: 'Seat Numbers',
                value: transaction.seats.join(', '),
                width: MediaQuery.of(context).size.width - 48,
              ),
              transactionRow(
                title: '# of Tickets',
                value: '${transaction.ticketAmount} tickets(s)',
                width: MediaQuery.of(context).size.width - 48,
              ),
              transactionRow(
                title: 'Ticket Price',
                value: '${transaction.ticketPrice?.toIDRCurrencyFormat()}',
                width: MediaQuery.of(context).size.width - 48,
              ),
              transactionRow(
                title: 'Adm. Fee',
                value: transaction.adminFee.toIDRCurrencyFormat(),
                width: MediaQuery.of(context).size.width - 48,
              ),
              const Divider(color: ghostWhite),
              transactionRow(
                title: 'Total Price',
                value: transaction.total.toIDRCurrencyFormat(),
                width: MediaQuery.of(context).size.width - 48,
              ),
              verticalSpace(40),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    int transactionTime = DateTime.now().microsecondsSinceEpoch;

                    transaction = transaction.copyWith(
                        transactionTime: transactionTime,
                        id: 'flix-$transactionTime-${transaction.uid}');

                    CreateTransaction createTransaction =
                        ref.read(createTransactionProvider);

                    await createTransaction(
                            CreateTransactionParam(transaction: transaction))
                        .then((result) {
                      switch (result) {
                        case Success(value: _):
                          ref
                              .read(transactionDataProvider.notifier)
                              .refreshTransactionData();

                          ref.read(userDataProvider.notifier).refreshUserData();

                          ref.read(routerProvider).goNamed('main');

                        case Failed(:final message):
                          context.showSnacBar(message);
                      }
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: backgroundColor,
                    backgroundColor: saffron,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text('Pay Now'),
                ),
              )
            ],
          ),
        )
      ],
    ));
  }
}
