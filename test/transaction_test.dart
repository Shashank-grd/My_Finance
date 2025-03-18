import 'package:flutter_test/flutter_test.dart';
import 'package:myfinance/core/models/transaction.dart';

void main() {
  group('Transaction', () {
    test('should create a Transaction with the correct values', () {
      final transaction = Transaction(
        id: '123',
        title: 'Test Transaction',
        amount: 100.0,
        type: TransactionType.expense,
        categoryId: 'category1',
        date: DateTime(2023, 1, 1),
        note: 'Test note',
      );
      
      expect(transaction.id, '123');
      expect(transaction.title, 'Test Transaction');
      expect(transaction.amount, 100.0);
      expect(transaction.type, TransactionType.expense);
      expect(transaction.categoryId, 'category1');
      expect(transaction.date, DateTime(2023, 1, 1));
      expect(transaction.note, 'Test note');
    });
    
    test('should create a transaction with a new UUID if no ID is provided', () {
      final transaction = Transaction(
        title: 'Test Transaction',
        amount: 100.0,
        type: TransactionType.expense,
        categoryId: 'category1',
        date: DateTime(2023, 1, 1),
      );
      
      expect(transaction.id, isNotNull);
      expect(transaction.id.length, greaterThan(0));
    });
    
    test('should correctly convert to and from JSON', () {
      final original = Transaction(
        id: '123',
        title: 'Test Transaction',
        amount: 100.0,
        type: TransactionType.income,
        categoryId: 'category1',
        date: DateTime(2023, 1, 1),
        note: 'Test note',
      );
      
      final json = original.toJson();
      final fromJson = Transaction.fromJson(json);
      
      expect(fromJson.id, original.id);
      expect(fromJson.title, original.title);
      expect(fromJson.amount, original.amount);
      expect(fromJson.type, original.type);
      expect(fromJson.categoryId, original.categoryId);
      expect(fromJson.date.year, original.date.year);
      expect(fromJson.date.month, original.date.month);
      expect(fromJson.date.day, original.date.day);
      expect(fromJson.note, original.note);
    });
    
    test('should correctly create a copy with updated values', () {
      final original = Transaction(
        id: '123',
        title: 'Original Title',
        amount: 100.0,
        type: TransactionType.expense,
        categoryId: 'category1',
        date: DateTime(2023, 1, 1),
        note: 'Original note',
      );
      
      final copy = original.copyWith(
        title: 'Updated Title',
        amount: 200.0,
        type: TransactionType.income,
      );
      
      expect(copy.id, original.id); // ID should not change
      expect(copy.title, 'Updated Title');
      expect(copy.amount, 200.0);
      expect(copy.type, TransactionType.income);
      expect(copy.categoryId, original.categoryId); // Unchanged
      expect(copy.date, original.date); // Unchanged
      expect(copy.note, original.note); // Unchanged
    });
  });
} 