//@dart=2.9
import 'package:market_app/models/product.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DBProvider {
  DBProvider._();

  static final db = DBProvider._();
  static Database _dataBase;

  Future<Database> get dataBase async {
    if (_dataBase != null) return _dataBase;

    _dataBase = await initDB();
    return _dataBase;
  }

  initDB() async {
    return await openDatabase(join(await getDatabasesPath(), 'product.db'),
        onCreate: (db, version) async {
      await db.execute('''
           CREATE TABLE products(
           id TEXT,
           name TEXT,
           brand TEXT,
           image TEXT,
           description TEXT,
           price TEXT,
           category TEXT,
           model TEXT)   
          ''');
    }, version: 1);
  }

  newProduct(Product product) async {
    final db = await dataBase;
    print(
        'newProduct  ${product.id}  -${product.name}  -${product.description}  -${product.model}  -${product.category}  -${product.brand}  -${product.image}  -${product.price}  -');
    var res = await db.rawInsert('''
    INSERT INTO products (
         id , name , brand , image , description , price , category , model ) VALUES  (? , ? , ? , ? , ? , ? , ? , ? )
    ''', [
      product.id,
      product.name,
      product.brand,
      product.image,
      product.description,
      product.price,
      product.category,
      product.model,
    ]);
    return res;
  }

  deletesProduct(String id) async {
    final db = await dataBase;
    var res = await db
      ..rawDelete('DELETE FROM products WHERE id = ?', [id]);
  }

  emptyCart() async {
    final db = await dataBase;
    var res = await db
      ..rawDelete('DELETE FROM products');
  }

  Future calculateTotal() async {
    var dbClient = await dataBase;
    var result =
        await dbClient.rawQuery("SELECT SUM(price) as Total FROM products");
    print(result.toList());
    return result;
  }

  Future countTotalProducts() async {
    var dbClient = await dataBase;
    var result =
        await dbClient.rawQuery("SELECT COUNT(id) as Total FROM products");
    return result;
  }

  Future<List> getProducts() async {
    final db = await dataBase;
    var res = await db.query("products", orderBy: "id DESC");
    print('res $res');
    if (res.length == 0)
      return null;
    else {
      var resMap = res;
      return resMap.isNotEmpty ? resMap : null;
    }
  }

  Future<int> checkIfServiceAdd(String id) async {
    final db = await dataBase;
    int count = Sqflite.firstIntValue(
        await db.rawQuery('SELECT COUNT(*) FROM products WHERE id = ?', [id]));
    print('count : $id   $count');
    return count;
  }
}
