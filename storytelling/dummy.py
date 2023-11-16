# Crie variáveis dummy para a variável 'sex'
tips = pd.get_dummies(tips, columns=['sex'], drop_first=True)

# Divida os dados em atributos (X) e variável alvo (y)
X = tips[['total_bill', 'size', 'sex_Male']]  # Características
y = tips['tip']  # Variável alvo, gorjeta

# Divida os dados em conjuntos de treinamento e teste
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)

# Crie e ajuste um modelo de regressão linear
regression_model = LinearRegression()
regression_model.fit(X_train, y_train)

# Faça previsões
y_pred = regression_model.predict(X_test)

# Avalie o modelo
mse = mean_squared_error(y_test, y_pred)
r2 = r2_score(y_test, y_pred)

print(f'Mean Squared Error: {mse}')
print(f'R-squared (R2): {r2}')
