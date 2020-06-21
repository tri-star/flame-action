import 'package:flame_action/domain/entity/entity.dart';
import 'package:flame_action/domain/entity/player.dart';
import 'package:flame_action/util/list.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {

  group('ZOrderedCollection', () {

    test('Forで1回ループ出来る', () {
      ZOrderedCollection collection = ZOrderedCollection();
      collection.add(Player(0, null, z: 1));

      int count = 0;
      for(Entity e in collection) {
        expect(e.getZ(), 1);
        count++;
      }
      expect(collection.length, 1);
      expect(count, 1);
    });

    test('Forで2回ループ出来る', () {
      ZOrderedCollection collection = ZOrderedCollection();
      collection.add(Player(0, null, z: 1));
      collection.add(Player(0, null, z: 2));

      int count = 0;
      for(Entity e in collection) {
        count++;
      }
      expect(collection.length, 2);
      expect(count, 2);
    });

  });

  group('ZOrderedListIterator', () {

    test('1つ取り出せる', () {
      Entity player = Player(0, null, z: 1);
      ZOrderedList list = ZOrderedList();
      list.add(player);

      ZOrderedListIterator iterator = ZOrderedListIterator(list);
      iterator.moveNext();

      Entity result = iterator.current;
      expect(result, player);
    });

    test('2つ取り出せる', () {
      Entity player = Player(0, null, z: 1);
      Entity player2 = Player(0, null, z: 2);

      ZOrderedList list = ZOrderedList();
      list.add(player);
      list.add(player2);
      ZOrderedListIterator iterator = ZOrderedListIterator(list);

      iterator.moveNext();
      Entity result = iterator.current;
      expect(result, player);

      iterator.moveNext();
      Entity result2 = iterator.current;
      expect(result2, player2);
    });

    test('終端はnullを返す', () {
      Entity player = Player(0, null, z: 1);
      ZOrderedList list = ZOrderedList();
      list.add(player);

      ZOrderedListIterator iterator = ZOrderedListIterator(list);
      iterator.moveNext();
      iterator.moveNext();
      Entity result = iterator.current;
      expect(result, null);
    });

    test('終端到着後にmoveNextを呼んでもエラーにならない', () {
      Entity player = Player(0, null, z: 1);
      ZOrderedList list = ZOrderedList();
      list.add(player);

      ZOrderedListIterator iterator = ZOrderedListIterator(list);
      iterator.moveNext();
      iterator.moveNext();
      iterator.moveNext();
      Entity result = iterator.current;
      expect(result, null);
    });

    test('2つのインスタンスが別々の位置を保持していること', () {
      Entity player = Player(0, null, z: 1);
      Entity player2 = Player(0, null, z: 2);
      ZOrderedList list = ZOrderedList();
      list.add(player);
      list.add(player2);

      ZOrderedListIterator iterator = ZOrderedListIterator(list);
      ZOrderedListIterator iterator2 = ZOrderedListIterator(list);
      iterator.moveNext();
      iterator2.moveNext();
      iterator.moveNext();
      expect(iterator.current.getZ(), 2);
      expect(iterator2.current.getZ(), 1);
    });

    test('登録時にZ座標の小さい順に格納されること', () {
      Entity player = Player(0, null, z: 1);
      Entity player2 = Player(0, null, z: 1.1);
      ZOrderedList list = ZOrderedList();
      list.add(player2);
      list.add(player);

      ZOrderedListIterator iterator = ZOrderedListIterator(list);
      iterator.moveNext();
      expect(iterator.current.getZ(), 1);
    });

    test('3個のうちの2番目に挿入', () {
      ZOrderedList list = ZOrderedList();
      list.add(Player(0, null, z: 1));
      list.add(Player(0, null, z: 1.3));
      list.add(Player(0, null, z: 1.2));

      ZOrderedListIterator iterator = ZOrderedListIterator(list);
      iterator.moveNext();
      expect(iterator.current.getZ(), 1);
      iterator.moveNext();
      expect(iterator.current.getZ(), 1.2);
      iterator.moveNext();
      expect(iterator.current.getZ(), 1.3);
      iterator.moveNext();
      expect(iterator.current, null);
    });

    test('途中でz-orderが変化しても対応できる(3番目が2番目になる)', () {
      ZOrderedList list = ZOrderedList();
      Player p = Player(0, null, z: 3);
      list.add(Player(0, null, z: 1));
      list.add(Player(0, null, z: 2));
      list.add(p);

      p.addZ(-1.5);
      list.sync();

      ZOrderedListIterator iterator = ZOrderedListIterator(list);
      iterator.moveNext();
      expect(iterator.current.getZ(), 1);
      iterator.moveNext();
      expect(iterator.current.getZ(), 1.5);
      iterator.moveNext();
      expect(iterator.current.getZ(), 2);
      iterator.moveNext();
      expect(iterator.current, null);
    });

    test('途中でz-orderが変化しても対応できる(1度に2つ以上上に移動するケース)', () {
      ZOrderedList list = ZOrderedList();
      Player p = Player(0, null, z: 4);
      list.add(Player(0, null, z: 1));
      list.add(Player(0, null, z: 2));
      list.add(Player(0, null, z: 3));
      list.add(p);

      p.addZ(-2.5);
      list.sync();

      ZOrderedListIterator iterator = ZOrderedListIterator(list);
      iterator.moveNext();
      expect(iterator.current.getZ(), 1);
      iterator.moveNext();
      expect(iterator.current.getZ(), 1.5);
      iterator.moveNext();
      expect(iterator.current.getZ(), 2);
      iterator.moveNext();
      expect(iterator.current.getZ(), 3);
      iterator.moveNext();
      expect(iterator.current, null);
    });

    test('途中でz-orderが変化しても対応できる(リストの先頭が入れ替わる)', () {
      ZOrderedList list = ZOrderedList();
      Player p = Player(0, null, z: 4);
      list.add(Player(0, null, z: 1));
      list.add(Player(0, null, z: 2));
      list.add(Player(0, null, z: 3));
      list.add(p);

      p.addZ(-4);
      list.sync();

      ZOrderedListIterator iterator = ZOrderedListIterator(list);
      iterator.moveNext();
      expect(iterator.current.getZ(), 0);
      iterator.moveNext();
      expect(iterator.current.getZ(), 1);
      iterator.moveNext();
      expect(iterator.current.getZ(), 2);
      iterator.moveNext();
      expect(iterator.current.getZ(), 3);
      iterator.moveNext();
      expect(iterator.current, null);
    });
  });


  group('ZOrderedItem', () {
    test('1つ追加した後でリストの関連が崩れていないこと', () {
      ZOrderedItem item = ZOrderedItem(Player(0, null, z: 1), null);
      ZOrderedItem item2 = ZOrderedItem(Player(0, null, z: 2), null);
      item.append(item2);

      expect(item.entity.getZ(), 1);
      expect(item.next.entity.getZ(), 2);
      expect(item.next.prev.entity.getZ(), 1);
    });

    test('2つ目の手前に挿入してもリストの関係が崩れていないこと', () {
      ZOrderedItem item = ZOrderedItem(Player(0, null, z: 1), null);
      ZOrderedItem item2 = ZOrderedItem(Player(0, null, z: 2), null);
      ZOrderedItem item3 = ZOrderedItem(Player(0, null, z: 3), null);
      item.append(item2);
      item2.insertBefore(item3);

      expect(item.entity.getZ(), 1);
      expect(item.next.entity.getZ(), 3);
      expect(item.next.prev.entity.getZ(), 1);
      expect(item.next.next.entity.getZ(), 2);
      expect(item.next.next.prev.entity.getZ(), 3);
    });

    test('1つ前との入れ替え(3番目と2番目)', () {
      ZOrderedItem item = ZOrderedItem(Player(0, null, z: 1), null);
      ZOrderedItem item2 = ZOrderedItem(Player(0, null, z: 2), null);
      ZOrderedItem item3 = ZOrderedItem(Player(0, null, z: 3), null);
      item.append(item2);
      item2.append(item3);

      item3.swapBefore();

      expect(item.entity.getZ(), 1);
      expect(item.next.entity.getZ(), 3);
      expect(item.next.prev.entity.getZ(), 1);
      expect(item.next.next.entity.getZ(), 2);
      expect(item.next.next.prev.entity.getZ(), 3);
    });


  });

}