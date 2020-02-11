import 'dart:html';

var k = Keyboard();

main() {
  //document.body.innerHtml = '';
  document.body.append(canvas);
  canvas.setAttribute('width', '720');
  canvas.setAttribute('heght', '400');
  canvas.setAttribute('style', 'border: solid green');

  run();
  print(startTime);
}

var canvas = CanvasElement();
var context2D = canvas.context2D;

var lastTimeStep = 0.0;
var deltaTime = 0.0;

var startTime = 0.0;
var x = 0.0; // 0,08
var x2 = 0.08;

var maxFPS = 60;
run() async {
  ///loop(await window.animationFrame);
  await window.requestAnimationFrame(loop);
}

void loop(num timestep) {
  if (timestep < lastTimeStep + (1000 / maxFPS)) {
    run();
    return;
  }

  //if (lastTimeStep == 0) startTime = timestep;

  deltaTime = timestep - lastTimeStep;
  //print(getElapsed());
  //print('Is running.. ${deltaTime} ');

  lastTimeStep = timestep;
  context2D.clearRect(0, 0, 720, 400);
  update(deltaTime);
  draw();

  run();
}

var velocity = 0.08;

update(num dtime) {
  // if (k.isPressed(KeyCode.LEFT)) {
  x += velocity * dtime;

  if (x >= 500 || x <= 0) velocity = -velocity;
  //   x2 -= velocity;
  //   print(x);
  // }

  // if (k.isPressed(KeyCode.RIGHT)) {
  //   x += velocity * dtime;
  //   x2 += velocity;
  //   print(x);
  // }
}

draw() {
  context2D.fillStyle = 'red';
  context2D.fillRect(x, 0, 32, 32);

  context2D.fillStyle = 'blue';
  context2D.fillRect(x2, 50, 32, 32);
}

class Keyboard {
  Map _key = Map<int, num>();

  Keyboard() {
    window.onKeyDown.listen((e) {
      _key.putIfAbsent(e.keyCode, () => e.timeStamp);
      //print('Key pressed: ${e.key} ${_key}');
      //print(startTime);
    });

    window.onKeyUp.listen((e) {
      _key.remove(e.keyCode);
      //print('Key pressed: ${e.key} ${_key}');
      //print(startTime);
    });
  }

  isPressed(final int keyCode) => _key.containsKey(keyCode);
}
