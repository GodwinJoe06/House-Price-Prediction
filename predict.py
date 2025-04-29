import pandas as pd
from sklearn.model_selection import train_test_split
from sklearn.linear_model import LinearRegression
from sklearn.metrics import mean_squared_error

df = pd.read_csv('Chennai Houseing sale.csv') 

print(df.head())

X = df[['AREA', 'INT_SQFT','N_BEDROOM', 'N_BATHROOM']]
y = df['SALES_PRICE']

X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)

model = LinearRegression()
model.fit(X_train, y_train)

# Predict and evaluate
y_pred = model.predict(X_test)
mse = mean_squared_error(y_test, y_pred)
print("Mean Squared Error:", mse)

# Predict price of a new house
new_house = [['Kodambakkam' , 1200,3,2]]  # Replace with actual values
predicted_price = model.predict(new_house)
print("Predicted Price:", predicted_price[0])
