// import 'package:get_storage/get_storage.dart';

// // This class manages local storage using the GetStorage package.
// // It follows the Singleton design pattern to ensure only one instance of the class is ever created.
// class TLocalStorage {
  
//   // This declares a variable that will hold an instance of GetStorage.
//   // The `late` keyword indicates that the variable will be assigned a value later, 
//   // but before it's used, ensuring the app doesn't throw an error.
//   // The `final` keyword means this variable can only be assigned once.
//   late final GetStorage _storage;

//   This is a static variabl to hold the single instance of the TLocalStorage class.
//   // It's static because it belongs to the class itself, not any object of the class.
//   // The `?` means it can initially be null, but once assigned, it won't be null again.
//   static TLocalStorage? _instance;

//   // This is a private constructor. 
//   // The `_internal` naming is a convention to indicate this constructor is not meant to be used outside the class.
//   // It prevents other parts of the code from creating a new instance of the class directly.
//   TLocalStorage._internal();

//   // This is a factory constructor to control how instances of the class are created.
//   // When `TLocalStorage.instance()` is called:
//   // 1. It checks if `_instance` is null (i.e., the class hasn't been initialized yet).
//   // 2. If null, it creates a new instance using the private `_internal` constructor.
//   // 3. If `_instance` is already set, it simply returns the existing instance.
//   factory TLocalStorage.instance() {
//     // If `_instance` is null, assign it to a new TLocalStorage object.
//     _instance ??= TLocalStorage._internal();
//     // Return the single instance of TLocalStorage.
//     return _instance!;
//   }

//   // This static method initializes the GetStorage library for managing local storage.
//   // It MUST be called once before using the TLocalStorage class.
//   // The `bucketName` parameter allows you to create a separate storage container (or namespace)
//   // for each user, ensuring that the data of one user does not interfere with another's data.
//   static Future<void> init(String bucketName) async {
//     // This initializes the GetStorage library with the specified `bucketName`.
//     // - If a bucket with this name doesn't exist, GetStorage will automatically create it.
//     // - This is particularly useful for managing multiple users, as each user can have
//     //   their own unique bucket to store their data independently.
//     await GetStorage.init(bucketName);

//     // Create a new instance of TLocalStorage using the private `_internal` constructor.
//     // This ensures the Singleton instance is properly initialized.
//     _instance = TLocalStorage._internal();

//     // Assign the `_storage` field of the Singleton instance to a specific bucket
//     // identified by the `bucketName`. All subsequent operations in this class
//     // (like saving, reading, or removing data) will use this specific bucket.
//     _instance!._storage = GetStorage(bucketName);
//   }


//   // Generic method to save data
//   Future<void> saveData<T>(String key, T value) async {
//     await _storage.write(key, value);
//   }

//   // Generic method to read data
//   T? readData<T>(String key) {
//     return _storage.read<T>(key);
//   }

//   // Generic method to remove data
//   Future<void> removeData(String key) async {
//     await _storage.remove(key);
//   }

//   // Clear all data in storage
//   Future<void> clearAll() async {
//     await _storage.erase();
//   }
// }


// /// *** *** *** *** *** Example *** *** *** *** *** ///

// // LocalStorage localStorage = LocalStorage();
// //
// // // Save data
// // localStorage.saveData('username', 'JohnDoe');
// //
// // // Read data
// // String? username = localStorage.readData<String>('username');
// // print('Username: $username'); // Output: Username: JohnDoe
// //
// // // Remove data
// // localStorage.removeData('username');
// //
// // // Clear all data
// // localStorage.clearAll();

