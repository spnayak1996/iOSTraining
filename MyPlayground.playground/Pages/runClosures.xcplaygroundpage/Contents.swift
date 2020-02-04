import Foundation

func printDone() -> Void {
    print("MyFunc Done!")
}

func runClosure(closure: () -> ()) {
    print("Running MyFunc")
    closure()
    printDone()
}

runClosure {
    DispatchQueue.global(qos: .background).async {
        for i in 1...10 {
            print(i)
        }
    }
}
