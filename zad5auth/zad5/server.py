from flask import Flask, request, jsonify

app = Flask(__name__)

users = {
    'user1': 'password1',
    'mikolaj': 'skora',
}

@app.route('/login', methods=['POST'])
def login():
    data = request.get_json()

    username = data.get('username')
    password = data.get('password')

    if username in users and users[username] == password:
        return jsonify({'message': 'login successful'})
    else:
        return jsonify({'message': 'login failed'}), 401

if __name__ == '__main__':
    app.run(debug=True)

