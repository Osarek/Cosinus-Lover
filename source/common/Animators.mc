import Toybox.Lang;

class Animator {
  var fps = 24;
  var timerCounter = 0;
  var maxTimerCounter = 99;
  var myTimer = new Timer.Timer();

  function getTimerMs() {
    return 1000 / fps;
  }

  function tic() {}
}
