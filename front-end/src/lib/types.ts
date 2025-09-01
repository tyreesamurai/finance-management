abstract class Account {
  name: string
  balance: number = 0

  constructor(name: string, startingBalance: number = 0) {
    this.name = name
    this.balance = startingBalance
  }

  abstract addIncome(amount: number): void
  abstract addExpense(amount: number): void
}

export class CheckingAccount extends Account {
  addIncome(amount: number): void {
    this.balance += amount
  }
  addExpense(amount: number): void {
    this.balance -= amount
  }
}

export class SavingsAccount extends Account {
  addIncome(amount: number): void {
    this.balance += amount
  }
  addExpense(amount: number): void {
    if (this.balance - amount >= 0) {
      this.balance -= amount
    } else {
      throw new Error('Insufficient funds in savings account')
    }
  }
}

export class CreditAccount extends Account {
  addIncome(amount: number): void {
    this.balance -= amount
  }
  addExpense(amount: number): void {
    this.balance += amount
  }
}

export class BrokerageAccount extends Account {
  addIncome(amount: number): void {
    this.balance += amount
  }
  addExpense(amount: number): void {
    this.balance -= amount
  }
}

abstract class IncomeOrExpense {
  description: string
  amount: number
  date: Date
  constructor(description: string, amount: number, date: Date) {
    this.description = description
    this.amount = amount
    this.date = date
  }
}

export class Income extends IncomeOrExpense {
  constructor(description: string, amount: number, date: Date) {
    super(description, amount, date)
  }
}

export class Expense extends IncomeOrExpense {
  from: Account
  constructor(description: string, amount: number, from: Account, date: Date) {
    super(description, amount, date)
    this.from = from
  }
}
