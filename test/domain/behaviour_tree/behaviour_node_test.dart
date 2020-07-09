import 'package:flame_action/domain/behaviour_tree/behaviour_node.dart';
import 'package:flame_action/engine/random/stub_random_generator.dart';
import 'package:flame_action/engine/world.dart';
import 'package:flame_action/engine/entity/entity.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../util/world_context.dart';

class WeightTestBehaviourNode extends BehaviourNode {
  String _name;

  WeightTestBehaviourNode(String name, int weight) : super(weight: weight) {
    _name = name;
  }

  @override
  String get description => '';

  @override
  bool isSatisfied(WorldContext context, Entity entity) {
    return true;
  }

  @override
  String get name => _name;
}

void main() {
  group('BehaviourNode', () {
    group('getSatisfiedNode', () {
      test('Weightに応じて正しいノードが選択されること', () {
        BehaviourNode baseNode = RootBehaviourNode([
          WeightTestBehaviourNode('node1', 10),
          WeightTestBehaviourNode('node2', 90),
        ]);

        StubRandomGenerator randomGenerator = StubRandomGenerator();
        randomGenerator.setNumbers([11, 10]);
        WorldContext context =
            WorldContextUtil.create(randomGenerator: randomGenerator);

        BehaviourNode selectedNode = baseNode.getSatisfiedNode(context, null);
        expect(selectedNode.name, 'node2');

        selectedNode = baseNode.getSatisfiedNode(context, null);
        expect(selectedNode.name, 'node1');
      });
    });
  });
}
