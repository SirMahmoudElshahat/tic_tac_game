import 'package:flutter/material.dart';
import 'package:tic_tac_game/game_logic.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String activePlayer = 'x';
  bool gameOver = false;
  int turn = 0;
  String result = '';
  Game game = Game();

  bool isSwitched = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: SafeArea(
        child: MediaQuery.of(context).orientation == Orientation.portrait
            ? Column(
              children: [
                ..._firstBlock(),
                Expanded(child: _expandedGrid(context)),
                ..._lastBlock(),
              ],
            )
            : Row(
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ..._firstBlock(),
                        const SizedBox(
                          height: 20,
                        ),
                        ..._lastBlock(),
                      ],
                    ),
                  ),
                  Expanded(child: _expandedGrid(context)),
                ],
              ),
      ),
    );
  }

  List<Widget> _lastBlock() {
    return [
      Text(
        result,
        style: TextStyle(
          color: Colors.white,
          fontSize: 40,
        ),
        textAlign: TextAlign.center,
      ),
      ElevatedButton.icon(
        onPressed: () {
          setState(() {
            Player.playerO = [];
            Player.playerX = [];
            activePlayer = 'x';
            gameOver = false;
            turn = 0;
            result = '';
          });
        },
        icon: const Icon(Icons.replay,color: Colors.white,),
        label: const Text(
          'Repeat the game',
          style: TextStyle(color: Colors.white),
        ),
        style: ButtonStyle(
          backgroundColor:
              WidgetStateProperty.all(Theme.of(context).splashColor),
        ),
      ),
      const SizedBox(
        height: 10,
      )
    ];
  }

  List<Widget> _firstBlock() {
    return [
      SwitchListTile.adaptive(
          title: const Text(
            'Turn on/off two player mode',
            style: TextStyle(
              color: Colors.white,
              fontSize: 25,
            ),
            textAlign: TextAlign.center,
          ),
          value: isSwitched,
          onChanged: (value) {
            setState(() {
              isSwitched = value;
              Player.playerO = [];
              Player.playerX = [];
              activePlayer = 'x';
              gameOver = false;
              turn = 0;
              result = '';
            });
          }),
      Text(
        gameOver
            ? 'Game end'.toUpperCase()
            : 'It\'s $activePlayer turn'.toUpperCase(),
        style: TextStyle(
          color: Colors.white,
          fontSize: 50,
        ),
        textAlign: TextAlign.center,
      ),
    ];
  }

  Widget _expandedGrid(BuildContext context) {
    return GridView.count(
      padding: const EdgeInsets.all(16),
      mainAxisSpacing: 8.0,
      crossAxisSpacing: 8.0,
      childAspectRatio: 1.0,
      crossAxisCount: 3,
      children: List.generate(
        9,
        (index) => InkWell(
          onTap: gameOver ? null : () => _onTap(index),
          borderRadius: BorderRadius.circular(16),
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).shadowColor,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Center(
              child: Text(
                Player.playerX.contains(index)
                    ? 'X'
                    : Player.playerO.contains(index)
                        ? 'O'
                        : '',
                style: TextStyle(
                  color:
                      Player.playerX.contains(index) ? Colors.blue : Colors.red,
                  fontSize: 52,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  _onTap(int index) async {
    if ((Player.playerX.isEmpty || !Player.playerX.contains(index)) &&
        (Player.playerO.isEmpty || !Player.playerO.contains(index))) {
      game.playGame(index, activePlayer);
      updateState();

      if (isSwitched && !gameOver && turn != 9) {
        await game.autoPlay(activePlayer);
        updateState();
      }
    }
  }

  void updateState() {
    setState(() {
      activePlayer = activePlayer == 'x' ? 'o' : 'x';
      turn++;
      String winnerPlayer = game.checkWinner();
      if (winnerPlayer != '') {
        gameOver = true;
        result = '$winnerPlayer is the winner';
      } else if (!gameOver && turn == 9) {
        gameOver = true;
        result = 'It\'s Draw!';
      }
    });
  }
}
