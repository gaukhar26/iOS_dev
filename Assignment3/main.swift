import Foundation


let laptop = Product(id: "1", name: "MacBook Air", price: 1299, category: .electronics, description: "13-inch laptop")
let book = Product(id: "2", name: "Swift Basics", price: 29.9, category: .books, description: "Beginner guide")
let headphones = Product(id: "3", name: "AirPods", price: 199, category: .electronics, description: "Wireless earbuds")

let cart = ShoppingCart()
cart.addItem(product: laptop, quantity: 1)
cart.addItem(product: book, quantity: 2)
cart.addItem(product: laptop, quantity: 1) // увеличит количество

print("Subtotal:", cart.subtotal)
print("Items in cart:", cart.itemCount)

cart.discountCode = "SAVE10"
print("Total with discount:", cart.total)

cart.removeItem(productId: book.id)
print("After removing book:", cart.itemCount)


func modifyCart(_ c: ShoppingCart) { c.addItem(product: headphones, quantity: 1) }
modifyCart(cart)
print("Headphones added, total:", cart.itemCount)

let item1 = CartItem(product: laptop, quantity: 1)
var item2 = item1
item2.updateQuantity(5)
print("Value type copy → item1:", item1.quantity, "| item2:", item2.quantity)

let address = Address(street: "Satpaeva 22", city: "Almaty", zipCode: "050013", country: "Kazakhstan")
let order = Order(from: cart, shippingAddress: address)
cart.clearCart()
print("Order items:", order.itemCount, "| Cart now:", cart.itemCount)
