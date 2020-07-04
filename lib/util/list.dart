import '../engine/entity/entity.dart';

/// TODO: パフォーマンス上の懸念からEntityのソート以外に削除判定と削除も行っているので、
/// 名称を変える、utilから移動することを検討する
class ZOrderedCollection extends Iterable<Entity> {
  ZOrderedList _list;

  ZOrderedCollection() : _list = ZOrderedList();

  @override
  Iterator<Entity> get iterator => ZOrderedListIterator(_list);

  void add(Entity entity) {
    _list.add(entity);
  }

  void sync() {
    _list.sync();
  }
}

class ZOrderedListIterator extends Iterator<Entity> {
  ZOrderedList _list;
  ZOrderedItem _current;
  bool _started;

  ZOrderedListIterator(ZOrderedList list)
      : _list = list,
        _started = false;

  @override
  Entity get current {
    if (_list == null) {
      return null;
    }
    return _current?.entity;
  }

  @override
  bool moveNext() {
    if (_list == null) {
      return false;
    }
    if (!_started) {
      _started = true;
      _current = _list.getHead();
      return true;
    } else if (_current == null) {
      return false;
    }
    _current = _current.next;
    return _current != null;
  }
}

class ZOrderedList {
  ZOrderedItem _list;

  ZOrderedItem getHead() {
    return _list;
  }

  void add(Entity entity) {
    if (_list == null) {
      _list = ZOrderedItem(entity, null);
      return;
    }
    ZOrderedItem head = _list;
    if (head.entity.getZ() > entity.getZ()) {
      ZOrderedItem newHead = ZOrderedItem(entity, null);
      head.insertBefore(newHead);
      _list = newHead;
      return;
    }

    while (head.next != null) {
      if (head.entity.getZ() > entity.getZ()) {
        head.insertBefore(ZOrderedItem(entity, null));
        return;
      }
      head = head.next;
    }
    if (head.entity.getZ() > entity.getZ()) {
      head.insertBefore(ZOrderedItem(entity, null));
      return;
    }
    head.append(ZOrderedItem(entity, head));
  }

  void sync() {
    ZOrderedItem head = _list;
    while (head != null) {
      if (head.isNeedRemove()) {
        ZOrderedItem tempNext = head.next;
        head.remove();
        head = tempNext;
        continue;
      }
      if (head.isNeedSwap()) {
        _fixOrder(head);
      }
      head = head.next;
    }
  }

  void _fixOrder(ZOrderedItem item) {
    if (item.isHead()) {
      return;
    }
    while (item.isNeedSwap()) {
      item.swapBefore();
    }
    if (item.isHead()) {
      _list = item;
    }
  }

  void _removeItem(ZOrderedItem item) {}
}

class ZOrderedItem {
  Entity _entity;

  ZOrderedItem(Entity entity, ZOrderedItem prev)
      : _entity = entity,
        _prev = prev,
        _next = null;

  ZOrderedItem _prev;
  ZOrderedItem _next;

  Entity get entity => _entity;
  ZOrderedItem get prev => _prev;
  ZOrderedItem get next => _next;

  void insertBefore(ZOrderedItem item) {
    if (_prev != null) {
      item.setPrev(_prev);
      _prev.setNext(item);
    }
    item.setNext(this);
    _prev = item;
  }

  void append(ZOrderedItem item) {
    if (_next != null) {
      item.setNext(_next);
      _next.setPrev(item);
    }
    item.setPrev(this);
    _next = item;
  }

  void swapBefore() {
    if (_prev == null) {
      return;
    }

    if (_prev.prev != null) {
      _prev.prev.setNext(this);
    }

    ZOrderedItem newPrev = _prev.prev;
    _prev.setNext(_next);
    _prev.setPrev(this);
    if (_next != null) {
      _next.setPrev(_prev);
    }
    _next = _prev;
    _prev = newPrev;
  }

  void remove() {
    ZOrderedItem tempPrev = _prev;
    if (_prev != null) {
      _prev.setNext(_next);
      _prev = null;
    }
    if (_next != null) {
      _next.setPrev(tempPrev);
      _next = null;
    }
  }

  void setNext(ZOrderedItem item) {
    _next = item;
  }

  void setPrev(ZOrderedItem item) {
    _prev = item;
  }

  bool isHead() {
    return _prev == null;
  }

  bool isNeedSwap() {
    if (_prev == null) {
      return false;
    }
    return _entity.getZ() < _prev.entity.getZ();
  }

  bool isNeedRemove() {
    return _entity.isDisposed();
  }
}
