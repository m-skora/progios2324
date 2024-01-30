from flask import Flask, request, jsonify
import uuid

app = Flask(__name__)

products = [
    	{"id": 1, "name": "banana", "category_id": 1, "price":5},
    	{"id": 2, "name": "apple", "category_id": 1, "price":3.50},
	{"id": 3, "name": "tomato", "category_id": 2, "price":15.05},  
	{"id": 4, "name": "cabbage", "category_id": 2, "price":0.99},  
]

categories = [
    {"id": 1, "name": "fruit"},
    {"id": 2, "name": "vegetables"}
]

@app.route('/api/products', methods=['GET'])
def get_products():
    print("Received GET request for products")
    return jsonify(products)

@app.route('/api/categories', methods=['GET'])
def get_categories():
    print("Received GET request for categories")
    return jsonify(categories)

class Order:
    def __init__(self, products, payment_token):
        self.id = str(uuid.uuid4())
        self.products = products
        self.payment_token = payment_token

orders = []

@app.route('/processPayment', methods=['POST'])
def process_payment():
    try:
        data = request.get_json()
        payment_token = str(uuid.uuid4())
        print("returned token", payment_token)
        return jsonify({"token": payment_token})
    except Exception as e:
        return 'Błąd podczas przetwarzania płatności: {}'.format(str(e))

@app.route('/api/orders', methods=['POST'])
def create_order():
    try:
        data = request.get_json()
        order = Order(products=data['products'], payment_token=data['token'])
        orders.append(order.__dict__)
        print("added order", order.__dict__)
        return 'Zamówienie zrealizowane poprawnie. Numer zamówienia: {}'.format(order['id'])
    except Exception as e:
        return 'Błąd podczas tworzenia zamówienia: {}'.format(str(e))

if __name__ == '__main__':
    app.run(debug=True)
