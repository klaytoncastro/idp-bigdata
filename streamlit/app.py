import streamlit as st

# Título do aplicativo
st.title("Meu Primeiro Aplicativo Streamlit")

# Título da seção
st.header("Seção 1")

# Texto simples
st.write("Este é um exemplo simples de um aplicativo Streamlit.")

# Adicionando um gráfico
import matplotlib.pyplot as plt
import numpy as np

# Gerando alguns dados aleatórios
data = np.random.randn(1000)

# Criando um histograma
fig, ax = plt.subplots()
ax.hist(data, bins=20)

# Exibindo o gráfico no Streamlit
st.pyplot(fig)

# Adicionando uma opção de seleção
option = st.selectbox("Selecione uma opção", ["Opção 1", "Opção 2", "Opção 3"])

# Exibindo a opção selecionada
st.write("Você selecionou:", option)

