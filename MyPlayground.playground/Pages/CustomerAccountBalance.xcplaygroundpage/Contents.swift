import Foundation

enum WithdrawalError: Error {
    case InvalidWithdrawalAmount
    case InsufficientBalance
}

enum InitializationError: Error {
    case EmptyName
}

enum DepositionError: Error {
    case InvalidAmount
}

class Customer {
    let name: String
    let accountNo: Int
    private var balance: Int
    
    private struct Utils {
        private struct Constants {
            static let accNoKey = "ACCNOKEY"
        }
        
        static func getAccountNo() -> Int {
            let currentCount = UserDefaults.standard.integer(forKey: Constants.accNoKey)
            UserDefaults.standard.set(currentCount + 1, forKey: Constants.accNoKey)
            return currentCount + 1
        }
    }
    
    init(accountName: String) throws {
        guard !accountName.isEmpty else {
            throw InitializationError.EmptyName
        }
        self.name = accountName
        self.accountNo = Utils.getAccountNo()
        self.balance = 1000
    }
    
    func displayBalance() {
        print("Hi, \(name). Your account balance for acc. no. \(accountNo) is \(balance) INR")
    }
    
    func deposit(amount: Int) throws -> Int {
        guard amount > 0 else {
            throw DepositionError.InvalidAmount
        }
        self.balance += amount
        print("Deposit Success")
        return amount
    }
    
    func withdraw(amount: Int) throws -> Int {
        guard amount > 0 else {
            throw WithdrawalError.InvalidWithdrawalAmount
        }
        guard amount <= balance else {
            throw WithdrawalError.InsufficientBalance
        }
        self.balance -= amount
        print("Withdraw success")
        return amount
    }
    
}


//test
//UserDefaults.standard.set(0, forKey: Constants.accNoKey) // for reseting the acc no count

//let failedAccount = Customer(accountName: "")             //the commented statements throw error

let account1 = Customer(accountName: "name1")
account1.displayBalance()
//account1.deposit(amount: 0)
account1.deposit(amount: 300)
//account1.withdraw(amount: 2000)
//account1.withdraw(amount: -2000)
account1.displayBalance()
account1.withdraw(amount: 500)

print()
let account2 = Customer(accountName: "name2")
account2.displayBalance()
print()
let account3 = Customer(accountName: "name3")
account3.displayBalance()



