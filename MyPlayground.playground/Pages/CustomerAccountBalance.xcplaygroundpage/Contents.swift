import Foundation

struct Constants {
    static let accNoKey = "ACCNOKEY"
}

struct Utils {
    static func getAccountNo() -> Int {
        let currentCount = UserDefaults.standard.integer(forKey: Constants.accNoKey)
        UserDefaults.standard.set(currentCount + 1, forKey: Constants.accNoKey)
        return currentCount + 1
    }
}


class Customer {
    private(set) var name: String
    private var accountNo: Int
    private var balance: Int
    
    init?(name: String) {
        guard !name.isEmpty else {
            print("Name should not be empty")
            return nil
        }
        self.name = name
        self.accountNo = Utils.getAccountNo()
        self.balance = 1000
    }
    
    func displayBalance() {
        print("Hi, \(name). Your account balance for acc. no. \(accountNo) is \(balance) INR")
    }
    
    func deposit(amount: Int) {
        guard amount > 0 else {
            print("Deposit amount should be greater than 0")
            return
        }
        self.balance += amount
        print("Successfully deposited \(amount) INR. Your new balance is \(balance) INR")
    }
    
    func withdraw(amount: Int) -> Int? {
        guard amount > 0 else {
            print("Withdraw amount should be greater than 0")
            return nil
        }
        guard amount <= balance else {
            print("Not enough account balance")
            return nil
        }
        self.balance -= amount
        print("successfully withdrawn \(amount) INR. Your new balance is \(balance) INR")
        return amount
    }
    
}


//test
//UserDefaults.standard.set(0, forKey: Constants.accNoKey) // for reseting the acc no count

let account1 = Customer(name: "name1")
account1?.displayBalance()
account1?.deposit(amount: 300)
account1?.withdraw(amount: 2000)
account1?.displayBalance()
account1?.withdraw(amount: 500)

print()
let account2 = Customer(name: "name2")
account2?.displayBalance()
print()
let account3 = Customer(name: "name3")
account3?.displayBalance()



