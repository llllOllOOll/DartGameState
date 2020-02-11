import 'dart:html';

//var canvas = CanvasElement();
var canvas = document.querySelector('canvas') as CanvasElement;
var context2D = canvas.context2D;

var rectRedPositionX = 10.0;
var velocity = 0.80;
var limit = 300;

var lastTimeStamp = 0.0;
var deltaTime = 0.0;
var timeStep = 1000 / 60;
//var numUpdateSteps = 0;
var maxFPS = 60;

var fpsDisplay = document.getElementById('fpsDisplay');

void setupCanvas() {
  document.body.append(canvas);
  canvas
    ..setAttribute('width', '350')
    ..setAttribute('height', '200')
    ..setAttribute('style', 'border: solid green');
}

void run() async {
  await window.requestAnimationFrame(loop);
}

void loop(num timestamp) {
  if (timestamp < lastTimeStamp + (1000 / maxFPS)) {
    run();
    return;
  }
  deltaTime = timestamp - lastTimeStamp;
  lastTimeStamp = timestamp;

  var numUpdateSteps = 0;

  while (deltaTime >= timeStep) {
    update(timeStep);
    deltaTime -= timeStep;

    if (++numUpdateSteps >= 240) {
      panic();
      break;
    }
  }

  draw();
  run();
}

void update(elapsedtime) {
  rectRedPositionX += velocity * elapsedtime;

  if (rectRedPositionX >= limit || rectRedPositionX <= 0) velocity = -velocity;
}

void draw() {
  context2D.clearRect(0, 0, 350, 200);

  context2D.fillStyle = 'purple';
  context2D.fillRect(rectRedPositionX, 0, 32, 32);
}

void panic() {
  deltaTime = 0.0;
}

class Keyboard {
  final _key = <int, num>{};

  Keyboard() {
    window.onKeyDown.listen((e) {
      _key.putIfAbsent(e.keyCode, () => e.timeStamp);
    });

    window.onKeyUp.listen((e) {
      _key.remove(e.keyCode);
    });
  }

  bool isPressed(final int keyCode) => _key.containsKey(keyCode);
}

void main() {
  setupCanvas();
  run();
}
