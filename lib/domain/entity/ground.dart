import '../../engine/services/collision_detect_service.dart';
import 'entity.dart';

class Ground extends Entity {

  double _w;
  double _h;
  double _d;

  Ground(int id, {double x, double y, double z, double w, double h, double d}) {
    this.id = id;
    this.x = x;
    this.y = y;
    this.z = z;
    this._w = w;
    this._h = h;
    this._d = d;
    this.spriteResolver = null;
    this.collidableFlag = true;
    this.tags = ["obstacle"];
  }

  double getW() => _w;
  double getH() => _h;
  double getD() => _d;

  void onCollide(CollisionEvent event) {
  }
}
