import 'dart:math';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const SolitaireApp());
}

class SolitaireApp extends StatelessWidget {
  const SolitaireApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: ' Solitaire',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.green, useMaterial3: true),
      home: const SolitaireScreen(),
    );
  }
}

enum CardSuit { hearts, diamonds, clubs, spades }

enum CardRank {
  ace,
  two,
  three,
  four,
  five,
  six,
  seven,
  eight,
  nine,
  ten,
  jack,
  queen,
  king,
}

extension SuitProperties on CardSuit {
  Color get color => (this == CardSuit.hearts || this == CardSuit.diamonds)
      ? Colors.red
      : Colors.black;
  String get symbol {
    switch (this) {
      case CardSuit.hearts:
        return '♥';
      case CardSuit.diamonds:
        return '♦';
      case CardSuit.clubs:
        return '♣';
      case CardSuit.spades:
        return '♠';
    }
  }
}

extension RankProperties on CardRank {
  int get value => index + 1;
  String get label {
    switch (this) {
      case CardRank.ace:
        return 'A';
      case CardRank.jack:
        return 'J';
      case CardRank.queen:
        return 'Q';
      case CardRank.king:
        return 'K';
      default:
        return value.toString();
    }
  }
}

class PlayingCard {
  final CardSuit suit;
  final CardRank rank;
  bool isFaceUp;

  PlayingCard({required this.suit, required this.rank, this.isFaceUp = false});
}

class SolitaireScreen extends StatefulWidget {
  const SolitaireScreen({super.key});

  @override
  State<SolitaireScreen> createState() => _SolitaireScreenState();
}

class _SolitaireScreenState extends State<SolitaireScreen> {
  List<PlayingCard> stock = [];
  List<PlayingCard> waste = [];
  List<List<PlayingCard>> foundations = List.generate(4, (_) => []);
  List<List<PlayingCard>> tableaus = List.generate(7, (_) => []);

  @override
  void initState() {
    super.initState();
    _initialiseGame();
  }

  void _initialiseGame() {
    List<PlayingCard> deck = [];
    for (var suit in CardSuit.values) {
      for (var rank in CardRank.values) {
        deck.add(PlayingCard(suit: suit, rank: rank));
      }
    }
    deck.shuffle(Random());

    stock = [];
    waste = [];
    foundations = List.generate(4, (_) => []);
    tableaus = List.generate(7, (_) => []);

    for (int i = 0; i < 7; i++) {
      for (int j = i; j < 7; j++) {
        tableaus[j].add(deck.removeLast());
      }
      tableaus[i].last.isFaceUp = true;
    }

    stock = deck;
    setState(() {});
  }

  void _drawCard() {
    setState(() {
      if (stock.isEmpty) {
        stock = waste.reversed.map((card) {
          card.isFaceUp = false;
          return card;
        }).toList();
        waste.clear();
      } else {
        var card = stock.removeLast();
        card.isFaceUp = true;
        waste.add(card);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[800],
      appBar: AppBar(
        title: const Text(' Solitaire', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.green[900],
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: _initialiseGame,
            tooltip: 'Reset Game',
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              _buildTopZone(),
              const SizedBox(height: 24),
              Expanded(child: _buildTableauZone()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopZone() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            GestureDetector(
              onTap: _drawCard,
              child: _buildDeckSlot(
                child: stock.isEmpty
                    ? Icon(
                        Icons.refresh,
                        color: Colors.white.withOpacity(0.5),
                        size: 32,
                      )
                    : const CardBackWidget(),
              ),
            ),
            const SizedBox(width: 8),
            _buildDeckSlot(
              child: waste.isEmpty
                  ? null
                  : DraggableCard(
                      card: waste.last,
                      onDragComplete: () => setState(() => waste.removeLast()),
                    ),
            ),
          ],
        ),
        Row(
          children: List.generate(
            4,
            (index) => Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: DragTarget<Map<String, dynamic>>(
                onWillAcceptWithDetails: (details) {
                  final draggedCard = details.data['card'] as PlayingCard;
                  final cardsList = details.data['cards'] as List<PlayingCard>;
                  if (cardsList.length > 1) return false;

                  final foundation = foundations[index];
                  if (foundation.isEmpty) {
                    return draggedCard.rank == CardRank.ace;
                  } else {
                    return foundation.last.suit == draggedCard.suit &&
                        foundation.last.rank.value + 1 ==
                            draggedCard.rank.value;
                  }
                },
                onAcceptWithDetails: (details) {
                  setState(() {
                    foundations[index].add(details.data['card']);
                    details.data['onComplete']();
                  });
                },
                builder: (context, candidateData, rejectedData) {
                  return _buildDeckSlot(
                    child: foundations[index].isEmpty
                        ? Center(
                            child: Text(
                              'A',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.3),
                                fontSize: 24,
                              ),
                            ),
                          )
                        : PlayingCardWidget(card: foundations[index].last),
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTableauZone() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(7, (pileIndex) {
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: DragTarget<Map<String, dynamic>>(
              onWillAcceptWithDetails: (details) {
                final draggedCard = details.data['card'] as PlayingCard;
                final pile = tableaus[pileIndex];
                if (pile.isEmpty) {
                  return draggedCard.rank == CardRank.king;
                } else {
                  final targetCard = pile.last;
                  return targetCard.isFaceUp &&
                      targetCard.suit.color != draggedCard.suit.color &&
                      targetCard.rank.value - 1 == draggedCard.rank.value;
                }
              },
              onAcceptWithDetails: (details) {
                final movingCards = details.data['cards'] as List<PlayingCard>;
                setState(() {
                  tableaus[pileIndex].addAll(movingCards);
                  details.data['onComplete']();
                });
              },
              builder: (context, candidateData, rejectedData) {
                return _buildTableauPile(pileIndex);
              },
            ),
          ),
        );
      }),
    );
  }

  Widget _buildTableauPile(int pileIndex) {
    final pile = tableaus[pileIndex];
    if (pile.isEmpty) {
      return Container(
        height: 110,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white.withOpacity(0.2), width: 2),
          borderRadius: BorderRadius.circular(8),
        ),
      );
    }

    return Stack(
      clipBehavior: Clip.none,
      children: pile.mapIndexed((cardIndex, card) {
        final double topOffset = cardIndex * 22.0;
        final isLast = cardIndex == pile.length - 1;

        if (!card.isFaceUp) {
          return Positioned(
            top: topOffset,
            left: 0,
            right: 0,
            child: const CardBackWidget(),
          );
        }

        final sublist = pile.sublist(cardIndex);

        return Positioned(
          top: topOffset,
          left: 0,
          right: 0,
          child: Draggable<Map<String, dynamic>>(
            data: {
              'card': card,
              'cards': sublist,
              'onComplete': () {
                setState(() {
                  tableaus[pileIndex].removeRange(cardIndex, pile.length);
                  if (tableaus[pileIndex].isNotEmpty) {
                    tableaus[pileIndex].last.isFaceUp = true;
                  }
                });
              },
            },
            feedback: Material(
              color: Colors.transparent,
              child: SizedBox(
                width: MediaQuery.of(context).size.width / 7.5,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: sublist.mapIndexed((subIdx, subCard) {
                    return Padding(
                      padding: EdgeInsets.only(top: subIdx * 22.0),
                      child: PlayingCardWidget(card: subCard),
                    );
                  }).toList(),
                ),
              ),
            ),
            childWhenDragging: const SizedBox.shrink(),
            child: PlayingCardWidget(card: card),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildDeckSlot({Widget? child}) {
    return Container(
      width: MediaQuery.of(context).size.width / 7.5,
      height: 110,
      decoration: BoxDecoration(
        color: Colors.green[900]?.withOpacity(0.5),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white.withOpacity(0.3), width: 1.5),
      ),
      child: child,
    );
  }
}

class DraggableCard extends StatelessWidget {
  final PlayingCard card;
  final VoidCallback onDragComplete;

  const DraggableCard({
    super.key,
    required this.card,
    required this.onDragComplete,
  });

  @override
  Widget build(BuildContext context) {
    return Draggable<Map<String, dynamic>>(
      data: {
        'card': card,
        'cards': [card],
        'onComplete': onDragComplete,
      },
      feedback: Material(
        color: Colors.transparent,
        child: SizedBox(
          width: MediaQuery.of(context).size.width / 7.5,
          height: 110,
          child: PlayingCardWidget(card: card),
        ),
      ),
      childWhenDragging: const SizedBox.shrink(),
      child: PlayingCardWidget(card: card),
    );
  }
}

class PlayingCardWidget extends StatelessWidget {
  final PlayingCard card;

  const PlayingCardWidget({super.key, required this.card});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 110,
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: const [
          BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: Text(
              card.rank.label,
              style: TextStyle(
                color: card.suit.color,
                fontSize: 18,
                fontWeight: FontWeight.bold,
                height: 1,
              ),
            ),
          ),
          Text(
            card.suit.symbol,
            style: TextStyle(color: card.suit.color, fontSize: 28, height: 1),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Transform.rotate(
              angle: pi,
              child: Text(
                card.rank.label,
                style: TextStyle(
                  color: card.suit.color,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  height: 1,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CardBackWidget extends StatelessWidget {
  const CardBackWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 110,
      decoration: BoxDecoration(
        color: Colors.blue[700]!, // Added ! operator to prevent type errors
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white, width: 2),
        boxShadow: const [
          BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(0, 2)),
        ],
      ),
      child: Center(
        child: Icon(
          Icons.grid_on,
          color: Colors.blue[900]!.withOpacity(
            0.4,
          ), // Added ! operator here as well
          size: 30,
        ),
      ),
    );
  }
}
