import 'dart:html';

class Colors {
  static const String backgroundMain = '#7FA0F0';
  static const String backgroundGameOver = '#7F1020';
  static const String homeBorder = 'white';
  static const String homeCenter = 'green';
}

void main() {
  final canvas = CanvasElement();
  document.body.append(canvas);

  canvas
    ..width = 400 //mainDiv.clientWidth
    ..height = 400 //mainDiv.clientHeight
    ..focus();

  print('calling GameHost.start');
  final game = GameHost(canvas); 
  game.start();
  //GameHost(canvas).start;
}

class GameHost {
  CanvasElement canvas;
  int lastTimestamp = 0;
  num renderTime; 
  Keyboard keyboard;
  GameState currentState;

  GameHost(this.canvas) {
    print('GameHost constructor');
    keyboard = Keyboard();
    var renderer = Renderer(canvas.context2D, canvas.width, canvas.height);
    currentState = StateLoad(keyboard, renderer);
  }

  void start() {
    print('Inside GameHost -> start');
    requestRedraw();
  }

  void draw(num _) {
    final num time = DateTime.now().millisecondsSinceEpoch;
    //if (renderTime != null)
    ///  showFps(_, 1000 / (time - renderTime));
    renderTime = time;

    var elapsed = 0.0;
    if (lastTimestamp != 0) {
      elapsed = (time - lastTimestamp) / 1000.0;
    }

    lastTimestamp = time;
    
    print('Elapsed Time: ${elapsed}');

    if (currentState != null) {
      var nextState = currentState._update(elapsed);

      currentState._render();
      
      if (currentState != nextState) {
        currentState = nextState;
        currentState._initialize();
      }

    }

    requestRedraw();
  }

  void requestRedraw() {
    window.requestAnimationFrame(draw);
  }
}

class Keyboard {
  final _keys = <int>{};

  Keyboard() {
    window.onKeyDown.listen((KeyboardEvent e) {
      _keys.add(e.keyCode);
    });

    window.onKeyUp.listen((KeyboardEvent e) {
      _keys.remove(e.keyCode);
    });
  }

  bool isPressed(int keyCode) => _keys.contains(keyCode);
}


class Renderer {
  final CanvasRenderingContext2D context;
  final int _width;
  final int _height;
  double _previousGlobalAlpha = 1.0;

  Renderer(this.context, this._width, this._height);

  void pushGlobalAlpha(double alpha) {
    _previousGlobalAlpha = context.globalAlpha;
    context.globalAlpha = alpha;
  }

  void popGlobalAlpha() {
    context.globalAlpha = _previousGlobalAlpha;
  }

  void clip() {
    context.save();
    context.beginPath();
    context.rect(0, 0, _width, _height);
    context.clip();
  }

  void fillRect(final String fill, int width, int height) {
    context
      ..beginPath()
      ..fillStyle = fill
      ..rect(0, 0, width, height)
      ..fill();
  }

  void fillFullRect(final String fill) {
    fillRect(fill, _width, _height);
  }

  void clearAll(String color) {
    clear(_width, _height, color);
  }

  void clear(int w, int h, String color) {
    context
      ..globalAlpha = 1
      ..fillStyle = color
      ..beginPath()
      ..rect(0, 0, w, h)
      ..fill();
  }
}

class GameState {
  final Keyboard _keyboard;
  final Renderer _renderer;
  //final AudioManager _audioManager;
  double _totalElapsed = 0.0;

  GameState(this._keyboard, this._renderer);

  void _initialize() {}

  GameState _update(final double elapsed) {
    _totalElapsed = _totalElapsed + elapsed;
    return this;
  }

  void _render() {}
}


class StateLoad extends GameState {
  final double _loaded = 0.0;
  bool _fullyLoaded = false;
  final double _readyTime = double.maxFinite; // .MAX_FINITE;

  StateLoad(final Keyboard keyboard, final Renderer renderer)
      : super(keyboard, renderer) {
    var clips = [];
  }

  GameState _update(double elapsed) {
    super._update(elapsed);

    if (_fullyLoaded) return  StateInit(_keyboard, _renderer);

    return this;
  }

  void _render() {
    _renderer.clip();
    _renderer.clearAll(Colors.backgroundMain);

    final loadedPercentage = (_loaded * 100.0).toInt();
    final  wasFullyLoaded = _fullyLoaded;
    _fullyLoaded = loadedPercentage == 100;
  }
}

class StateInit extends GameState {
  double _readyTime = 2.0;

  StateInit(final Keyboard keyboard, final Renderer renderer)
      : super(keyboard, renderer);// {}

  void _initialize() {
    // querySelector("#areaGameTextInstruction").style.visibility = "visible";
    // querySelector("#areaScoreB").style.visibility = "hidden";
    // querySelector("#areaScoreT").style.visibility = "hidden";
  }

  GameState _update(double elapsed) {
    super._update(elapsed);
    if (_totalElapsed > _readyTime && _keyboard.isPressed(KeyCode.SPACE)) {
      //querySelector("#areaGameTextInstruction").style.visibility = "hidden";
      return StateGame(_keyboard, _renderer, 1);
    }
    return this;
  }

  void _render() {
    _renderer.clip();
    _renderer.clearAll(Colors.backgroundMain);
    // if (_totalElapsed < _readyTime)
    //   //querySelector("#areaGameTextMain").text = "LOST SOULS";
    // else print('dd');
    //querySelector("#areaGameTextMain").text = "PRESS SPACE TO START";

    //querySelector("#areaGameTextMain").style.visibility = "visible";
  }
}



class StateGame extends GameState {
  static bool _isMusicAllowed = true;

  final int _levelIndex;
  //GameController _controller;

  StateGame(final Keyboard keyboard, final Renderer renderer, this._levelIndex)
      : super(keyboard, renderer) {
    //_controller = createLevel(_levelIndex, 800, 600, renderer.context);
  }

  void _initialize(){ 
    //if (_isMusicAllowed) _audioManager.play("music");

    // querySelector("#areaTime").style.visibility = "visible";
    // querySelector("#areaScoreB").style.visibility = "visible";
    // querySelector("#areaScoreT").style.visibility = "visible";
  }

  GameState _update(double elapsed) {
    super._update(elapsed);

    if (_keyboard.isPressed(KeyCode.M)) {
      ///_audioManager.play("music");
      //_isMusicAllowed = true;
    }

    if (_keyboard.isPressed(KeyCode.N)) {
      //_audioManager.stop("music");
      //_isMusicAllowed = false;
    }

    //_controller.update(elapsed);

    // if (!_controller.entities.any((e) => e is LostSoul)) {
    //   _audioManager.play("levelwon");
    //   return new StateFade(
    //       _keyboard,
    //       _renderer,
    //       _audioManager,
    //       this,
    //       new StateNewLevel(
    //           _keyboard, _renderer, _audioManager, _levelIndex + 1),
    //       1.0,
    //       Colors.backgroundMain);
    // }
    // if (_controller._getTimeLeft() <= 0.0)
    //   return new StateGameOver(_keyboard, _renderer, _audioManager);

    return this;
  }

  void _render() {
    //_controller.render(_totalElapsed);

    // final double fadeOutStartTime = 10.0;
    // final double timeLeft = _controller._getTimeLeft();
    // if (timeLeft <= fadeOutStartTime) {
    //   final double fraction = 1.0 - timeLeft / fadeOutStartTime;

    //   _renderer.pushGlobalAlpha(fraction);
    //   _renderer.fillFullRect(Colors.backgroundGameOver);
    //   _renderer.popGlobalAlpha();
    // }
  }
}