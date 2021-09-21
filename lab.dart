import 'dart:math';

abstract class Widget {
  void render();
}

class Container extends Widget {
  @override
  void render() {
    print('Renders container');
  }
}

class Text extends Widget {
  var size;
  Text([this.size = 12]);

  @override
  void render({text = 'Default text'}) {
    print(text + " with size = " + size.toString());
  }

  factory Text.fromString(String s) {
    return Text(int.parse(s));
  }
}

enum Color { red, yellow, green }

mixin PaintableMixin {
  Color _color = Color.red;
  void paint(Color color) {
    _color = color;
  }

  Color get color => _color;
  set color(var c) => _color = c;
}

class PaintableText extends Text with PaintableMixin {
  @override
  void render({text = 'Default text'}) {
    print(text + ' with color = $color');
  }
}

class PaintableContainer extends Container with PaintableMixin {
  @override
  void render() {
    print('Render container with color $color');
  }
}

Function increaseSize(num step) =>
    (num size, num n_times) => size + step * n_times;

main() {
  PaintableText()
    ..paint(Color.red)
    ..render();
  PaintableText()
    ..paint(Color.red)
    ..render(text: 'New text');
  PaintableContainer()
    ..paint(Color.yellow)
    ..render();

  var somethingNull;
  var notNull = somethingNull ?? 10;
  print('somethingNull = $somethingNull\nnotNull = $notNull\n');
  somethingNull ??= notNull;
  print('somethingNull = $somethingNull\nnotNull = $notNull\n');

  // lambda and closure
  var lambda_sum = (a, b) => (a + b);
  print("Sum of 5 and 10 = " + lambda_sum(5, 10).toString());

  var customStepInc = increaseSize(2);
  var value = customStepInc(Text().size, 2);
  print("Increased text size = " + value.toString());

  Text.fromString('10').render();

  var text = Text();
  assert(text.size > 0);

  var rnd = Random();
  var list =
      List.generate(2, (i) => Color.values[rnd.nextInt(Color.values.length)]);
  var one_more_list =
      List.generate(2, (i) => Color.values[rnd.nextInt(Color.values.length)]);

  list.addAll(one_more_list);
  print(list);
  for (var c in list) {
    PaintableText()
      ..paint(c)
      ..render(text: 'Text with random color: ');
  }

  var collection = <String, Color>{
    'Yellow text': Color.yellow,
    'Red text': Color.red,
    'Green text': Color.green
  };
  collection['Green text'] = Color.red;
  for (var e in collection.entries) {
    print('for loop: $e');
  }
}
