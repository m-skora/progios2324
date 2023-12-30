from flask import Flask, jsonify, request

app = Flask(__name__)

products = [
    	{"id": 1, "name": "banana", "category_id": 1},
    	{"id": 2, "name": "apple", "category_id": 1},
	{"id": 3, "name": "tomato", "category_id": 2},  
	{"id": 4, "name": "cabbage", "category_id": 2},  
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

if __name__ == '__main__':
    app.run(debug=True)

