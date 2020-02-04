import Foundation

func printDone() -> Void {
    print("MyFunc Done!")
}

func logger(closure: () -> ()) {
    print("Running MyFunc")
    closure()
    printDone()
}

logger {
    DispatchQueue.global(qos: .background).async {
        for i in 1...10 {
            print(i)
        }
    }
}
