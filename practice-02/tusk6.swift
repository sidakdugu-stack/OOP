import Foundation

let n = 1_000_000
var arr1 = Array(0..<n)
var arr2 = arr1          // физического копирования здесь ещё нет

// Меняем только arr2
arr2[0] = -1

assert(arr1[0] == 0)     // первый массив не изменился
assert(arr2[0] == -1)
assert(arr1.count == arr2.count)

print("arr1[0] = \(arr1[0]), arr2[0] = \(arr2[0])")
