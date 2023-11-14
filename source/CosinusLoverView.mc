import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;

class CosinusLoverView extends WatchUi.WatchFace {
  var animator;
  var ratio = 0.9;
  function initialize() {
    WatchFace.initialize();
    animator = new Animator();
  }


  // Load your resources here
  function onLayout(dc as Dc) as Void {
    setLayout(Rez.Layouts.WatchFace(dc));
  }

  // Called when this View is brought to the foreground. Restore
  // the state of this View and prepare it to be shown. This includes
  // loading resources into memory.
  function onShow() as Void {
    animator.myTimer.start(method(:timerCallback), animator.getTimerMs(), true);
  }

  // Update the view
  function onUpdate(dc as Dc) as Void {
    animator.timerCounter++;

    // Call the parent onUpdate function to redraw the layout
    View.onUpdate(dc);

    dc.setPenWidth(1);

    var angle = -animator.timerCounter;

    var sin = Math.sin(Math.toRadians(angle));
    var cos = Math.cos(Math.toRadians(angle));

    dc.setColor(Graphics.COLOR_DK_GRAY, Graphics.COLOR_TRANSPARENT);

    //horizontal
    drawLine(dc, -1, 0, 1, 0);
    for (var i = -1; i <= 1; i = i + 0.2) {
      drawLine(dc, i, 0, i, -0.03);
    }

    //vertical
    drawLine(dc, 0, -1, 0, 1);
    for (var i = -1; i <= 1; i = i + 0.2) {
      drawLine(dc, 0, i, 0.03, i);
    }

    fillCircle(dc, cos, sin, 5);


    drawText(dc, 0, -0.9, Graphics.FONT_SYSTEM_XTINY, "90° ", Graphics.TEXT_JUSTIFY_VCENTER|Graphics.TEXT_JUSTIFY_RIGHT);
    drawText(dc, 0, -0.9, Graphics.FONT_SYSTEM_XTINY, " π/2 ", Graphics.TEXT_JUSTIFY_VCENTER|Graphics.TEXT_JUSTIFY_LEFT);

    drawText(dc, -1, -0.1, Graphics.FONT_SYSTEM_XTINY, "  π ", Graphics.TEXT_JUSTIFY_VCENTER| Graphics.TEXT_JUSTIFY_LEFT);
    drawText(dc, -1, 0.1, Graphics.FONT_SYSTEM_XTINY, "180°",  Graphics.TEXT_JUSTIFY_VCENTER|Graphics.TEXT_JUSTIFY_LEFT);

    drawText(dc, 1, -0.1, Graphics.FONT_SYSTEM_XTINY, "2π  ", Graphics.TEXT_JUSTIFY_VCENTER| Graphics.TEXT_JUSTIFY_RIGHT);
    drawText(dc, 1, 0.1, Graphics.FONT_SYSTEM_XTINY, "360°", Graphics.TEXT_JUSTIFY_VCENTER| Graphics.TEXT_JUSTIFY_RIGHT);

    drawText(dc, 0, 0.9, Graphics.FONT_SYSTEM_XTINY, " 3π/2 ",Graphics.TEXT_JUSTIFY_VCENTER| Graphics.TEXT_JUSTIFY_RIGHT );
    drawText(dc, 0, 0.9, Graphics.FONT_SYSTEM_XTINY, " 270°", Graphics.TEXT_JUSTIFY_VCENTER| Graphics.TEXT_JUSTIFY_LEFT);

    dc.setColor(Graphics.COLOR_BLUE, Graphics.COLOR_TRANSPARENT);

    drawText(
      dc,
      0.2,
      -0.2,
      Graphics.FONT_SYSTEM_XTINY,
      -angle + "°",
      Graphics.TEXT_JUSTIFY_VCENTER | Graphics.TEXT_JUSTIFY_CENTER
    );
    if (angle != 0) {
      drawArc(dc, 0, 0, 0.2, Graphics.ARC_COUNTER_CLOCKWISE, 0, -angle);
    }

    // dc.setPenWidth(3);

    dc.setColor(Graphics.COLOR_GREEN, Graphics.COLOR_TRANSPARENT);

    drawLine(dc, 0, 0, cos, sin);

    dc.setColor(Graphics.COLOR_BLUE, Graphics.COLOR_TRANSPARENT);

    dc.setColor(Graphics.COLOR_RED, Graphics.COLOR_TRANSPARENT);

    drawLine(dc, cos, 0, cos, sin);

    var alignCos = Graphics.TEXT_JUSTIFY_CENTER;
    var alignSin = Graphics.TEXT_JUSTIFY_RIGHT;

    if (cos < 0) {
      alignSin = Graphics.TEXT_JUSTIFY_LEFT;
    }

    var yCosText = 0.2;
    var xSinText = -0.05;
    if (cos < 0) {
      xSinText = -xSinText;
    }
    if (sin > 0) {
      yCosText = -yCosText;
    }

    drawText(
      dc,
      cos,
      yCosText,
      Graphics.FONT_SYSTEM_XTINY,
      "cos\n"+cos.format("%.2f"),
      Graphics.TEXT_JUSTIFY_VCENTER | alignCos
    );

    dc.setColor(Graphics.COLOR_YELLOW, Graphics.COLOR_TRANSPARENT);

    drawLine(dc, 0, sin, cos, sin);
    drawText(
      dc,
      xSinText,
      sin,
      Graphics.FONT_SYSTEM_XTINY,
      "sin\n"+sin.format("%.2f"),
      Graphics.TEXT_JUSTIFY_VCENTER | alignSin
    );
  }

  // Called when this View is removed from the screen. Save the
  // state of this View here. This includes freeing resources from
  // memory.
  function onHide() as Void {}

  // The user has just looked at their watch. Timers and animations may be started here.
  function onExitSleep() as Void {
    animator.timerCounter = 0;
    animator.myTimer.start(method(:timerCallback), animator.getTimerMs(), true);
  }

  // Terminate any active timers and prepare for slow updates.
  function onEnterSleep() as Void {
    animator.timerCounter = 0;
    animator.myTimer.stop();
  }

  function timerCallback() as Void {
    animator.timerCounter = (animator.timerCounter + 1) % 360;

    WatchUi.requestUpdate();
    System.println("pif");
  }

  function drawArc(
    dc as Dc,
    x as Number,
    y as Number,
    r as Float,
    attr as Toybox.Graphics.ArcDirection,
    degreeStart as Number,
    degreeEnd as Number
  ) {
    x = xy(dc, x);
    y = xy(dc, y);
    r = (ratio * (r * dc.getWidth())) / 2;
    dc.drawArc(x, y, r, attr, degreeStart, degreeEnd);
  }

  function drawCircle(
    dc as Dc,

    x as Lang.Numeric,
    y as Lang.Numeric,
    radius as Lang.Numeric
  ) as Void {
    x = xy(dc, x);
    y = xy(dc, y);
    dc.drawCircle(x, y, radius);
  }

  function fillCircle(
    dc as Dc,

    x as Lang.Numeric,
    y as Lang.Numeric,
    radius as Lang.Numeric
  ) as Void {
    x = xy(dc, x);
    y = xy(dc, y);
    dc.fillCircle(x, y, radius);
  }

  function drawLine(
    dc as Dc,

    x1 as Lang.Numeric,
    y1 as Lang.Numeric,
    x2 as Lang.Numeric,
    y2 as Lang.Numeric
  ) as Void {
    x1 = xy(dc, x1);
    x2 = xy(dc, x2);
    y1 = xy(dc, y1);
    y2 = xy(dc, y2);
    dc.drawLine(x1, y1, x2, y2);
  }

  function drawText(
    dc as Dc,
    x as Lang.Numeric,
    y as Lang.Numeric,
    font as Graphics.FontType,
    text as Lang.String,
    justification as Graphics.TextJustification or Lang.Number
  ) as Void {
    x = xy(dc, x);
    y = xy(dc, y);
    dc.drawText(x, y, font, text, justification);
  }

  function xy(dc as Dc, xy as Number) {
    return (ratio * (xy * dc.getWidth())) / 2 + dc.getWidth() / 2;
  }
}
