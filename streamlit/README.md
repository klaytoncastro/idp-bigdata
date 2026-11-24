# Introdução ao Streamlit

## O que é o Streamlit?

O Streamlit é uma biblioteca de código aberto em Python que se destaca como uma ferramenta poderosa para criar aplicativos web interativos de maneira rápida e fácil. Ele foi projetado por engenheiros egressos do Google para atender às demandas de cientistas de dados e engenheiros de software que desejavam compartilhar suas análises, visualizações e modelos com um público mais amplo, sem a complexidade comum ao desenvolvimento web ou as limitações de um Jupyter Notebook rodando em ambientes não controlados.

## História e Popularidade

O Streamlit foi lançado em 2018 e rapidamente ganhou popularidade na comunidade de ciência de dados e desenvolvimento de software. Sua ascensão meteórica pode ser atribuída à sua abordagem simples e eficaz de criação de aplicativos web, o que o torna uma escolha atraente para aqueles que não são necessariamente especialistas em desenvolvimento web.

## Comparação com Outras Opções

### Streamlit vs. Dash

O Streamlit e o Dash são duas bibliotecas populares para a criação de aplicativos web em Python, mas cada um deles tem suas próprias características distintas:

- **Streamlit**: Conhecido por sua simplicidade e facilidade de uso, o Streamlit se concentra na criação de aplicativos web a partir de scripts Python, com uma abordagem orientada a widgets. É ótimo para prototipagem rápida e criação de aplicativos simples.

- **Dash**: Por outro lado, o Dash oferece mais controle e flexibilidade, permitindo que os desenvolvedores criem aplicativos web altamente personalizados com componentes interativos. A escolha entre eles depende da complexidade e dos requisitos do projeto.

### Streamlit vs. Desenvolvimento Tradicional

Comparado ao desenvolvimento tradicional de aplicativos web com Flask, HTML, CSS e JavaScript, o Streamlit oferece várias vantagens:

- **Simplicidade**: O Streamlit elimina a necessidade de escrever código HTML, CSS e JavaScript, tornando o desenvolvimento mais acessível para desenvolvedores Python.

- **Produtividade**: A abordagem baseada em scripts do Streamlit permite que você crie aplicativos web rapidamente, economizando tempo e esforço.

- **Integração com Bibliotecas de Ciência de Dados**: O Streamlit se integra facilmente a bibliotecas populares como Pandas, Matplotlib e Plotly, tornando-o uma escolha natural para cientistas de dados.

## Por Que Usar o Streamlit?

O Streamlit oferece uma combinação única de simplicidade e eficácia para criar aplicativos web interativos em Python. Aqui estão algumas razões para considerar o uso do Streamlit:

- **Rapidez de Desenvolvimento**: Você pode criar um aplicativo web funcional em minutos, economizando tempo e esforço no desenvolvimento.

- **Abordagem Baseada em Scripts**: O Streamlit é amigável para desenvolvedores que não são especialistas em desenvolvimento web, permitindo que eles se concentrem em seus scripts Python.

- **Comunidade Ativa**: A comunidade do Streamlit é acolhedora e oferece suporte, tornando-o ideal para desenvolvedores de todos os níveis de experiência.

## Prática

Editem o `app.py`, parem e inicializem novamente o container após o ajuste: 

```python
import numpy as np
import pandas as pd
import plotly.express as px
import plotly.graph_objects as go
import streamlit as st

st.set_page_config(page_title="AirPulse | Big Data Lab", layout="wide")

st.markdown("""
<style>
    .stApp {background: #0b1120; color: #e2e8f0;}
    [data-testid="stSidebar"] {background: #111a2e;}
    [data-testid="stMetric"] {
        background: #162238; padding: 17px 20px; border-radius: 15px;
        border: 1px solid #263852;
    }
    [data-testid="stMetricLabel"] {color: #94a3b8;}
    [data-testid="stMetricValue"] {color: #f8fafc;}
    h1, h2, h3 {letter-spacing: -0.035em;}
    .hero {
        padding: 25px 29px; margin: 8px 0 22px; border-radius: 19px;
        background: linear-gradient(105deg, #122e42 0%, #18234c 55%, #312054 100%);
        border: 1px solid #344b68;
    }
    .eyebrow {color: #67e8f9; font-size: .85rem; font-weight: 700; letter-spacing: .14em;}
    .hero h1 {margin: 7px 0 5px; font-size: 2.7rem; color: #ffffff;}
    .hero p {margin: 0; color: #cbd5e1; font-size: 1.05rem;}
    .tag {border: 1px solid #0e7490; color: #a5f3fc; padding: 4px 10px;
          border-radius: 20px; font-size: .72rem; font-weight: 600;}
</style>
""", unsafe_allow_html=True)

CORES = {"CO": "#22d3ee", "NO₂": "#a78bfa", "Temperatura": "#fb923c"}
PLOT = dict(
    paper_bgcolor="rgba(0,0,0,0)", plot_bgcolor="rgba(0,0,0,0)",
    font=dict(color="#cbd5e1"),
    margin=dict(l=12, r=12, t=45, b=10),
    xaxis=dict(showgrid=False, zeroline=False),
    yaxis=dict(gridcolor="#26344e", zeroline=False),
    hovermode="x unified",
)

@st.cache_data
def simular_dados():
    """Dados sintéticos, reprodutíveis, para a demonstração em sala."""
    rng = np.random.default_rng(42)
    datas = pd.date_range(end=pd.Timestamp("2026-11-19 10:00"), periods=30 * 24, freq="h")
    frames = []
    for estacao, fator in [("Centro", 1.0), ("Zona Norte", 0.76), ("Zona Sul", 1.22)]:
        n = len(datas)
        hora = datas.hour.to_numpy()
        pico = np.exp(-((hora - 8) / 3) ** 2) + 0.9 * np.exp(-((hora - 19) / 3.5) ** 2)
        co = np.maximum(0.1, (2.8 + 2.0 * pico + rng.normal(0, .7, n)) * fator)
        no2 = np.maximum(4, (85 + 43 * pico + rng.normal(0, 18, n)) * fator)
        temperatura = 24 + 5 * np.sin(2 * np.pi * (hora - 7) / 24) + rng.normal(0, 1.2, n)
        umidade = np.clip(62 - .8 * (temperatura - 24) + rng.normal(0, 7, n), 20, 95)
        # Eventos de alta concentração (apenas para enriquecer o exercício).
        indices = rng.choice(n, 11, replace=False)
        co[indices] += rng.uniform(4, 9, len(indices))
        no2[indices] += rng.uniform(70, 145, len(indices))
        frames.append(pd.DataFrame({
            "data_hora": datas, "estacao": estacao,
            "CO": co.round(2), "NO2": no2.round(1),
            "temperatura": temperatura.round(1), "umidade": umidade.round(1),
        }))
    return pd.concat(frames, ignore_index=True)

with st.sidebar:
    st.markdown("### AirPulse")
    st.caption("Laboratório de Engenharia de Dados")
    st.markdown("---")
    estacao = st.selectbox("Estação", ["Centro", "Zona Norte", "Zona Sul"])
    periodo = st.selectbox("Período", ["Últimas 24 horas", "Últimos 7 dias", "Últimos 30 dias"], index=1)
    st.markdown("#### Limites de alerta (didáticos)")
    limite_co = st.slider("CO — valor de demonstração", 3.0, 15.0, 8.0, 0.5)
    limite_no2 = st.slider("NO₂ — valor de demonstração", 80, 250, 180, 10)
    st.markdown("---")
    st.info("**MODO DEMONSTRAÇÃO**\n\nDados sintéticos. Nenhum serviço Kafka, Spark ou MinIO é consultado.")

base = simular_dados()
df = base[base["estacao"] == estacao].sort_values("data_hora").copy()
qtd_horas = {"Últimas 24 horas": 24, "Últimos 7 dias": 168, "Últimos 30 dias": 720}[periodo]
df = df.tail(qtd_horas).copy()
df["alerta"] = (df["CO"] > limite_co) | (df["NO2"] > limite_no2)
df["nivel"] = np.where(df["alerta"], "Alerta", "Normal")
ultimo = df.iloc[-1]
n_alertas = int(df["alerta"].sum())

st.markdown("""
<div class="hero">
  <span class="eyebrow">BIG DATA LAB <span class="tag">DEMO</span></span>
  <h1>AirPulse</h1>
  <p>Da ingestão ao insight: monitore, explore e entenda dados ambientais.</p>
</div>
""", unsafe_allow_html=True)

c1, c2, c3, c4 = st.columns(4)
c1.metric("CO · última leitura", f"{ultimo['CO']:.1f}", "Dados simulados")
c2.metric("NO₂ · última leitura", f"{ultimo['NO2']:.0f}", "Dados simulados")
c3.metric("Temperatura", f"{ultimo['temperatura']:.1f} °C")
c4.metric("Leituras em alerta", f"{n_alertas}", f"{100 * n_alertas / len(df):.1f}% das leituras", delta_color="off")

aba1, aba2, aba3, aba4 = st.tabs(["Monitoramento", "Exploração", "Eventos", "Arquitetura"])

with aba1:
    st.subheader(f"Monitoramento · {estacao}")
    st.caption(f"{len(df)} leituras • {periodo.lower()} • limites definidos na barra lateral")
    a, b = st.columns(2)
    with a:
        fig = go.Figure()
        fig.add_scatter(x=df["data_hora"], y=df["CO"], mode="lines", name="CO", line=dict(color=CORES["CO"], width=2.5), fill="tozeroy", fillcolor="rgba(34,211,238,.10)")
        fig.add_hline(y=limite_co, line_color="#fb7185", line_dash="dash", annotation_text="Limite")
        fig.update_layout(title="Concentração de CO", yaxis_title="Escala didática", **PLOT)
        st.plotly_chart(fig, use_container_width=True)
    with b:
        fig = go.Figure()
        fig.add_scatter(x=df["data_hora"], y=df["NO2"], mode="lines", name="NO₂", line=dict(color=CORES["NO₂"], width=2.5), fill="tozeroy", fillcolor="rgba(167,139,250,.12)")
        fig.add_hline(y=limite_no2, line_color="#fb7185", line_dash="dash", annotation_text="Limite")
        fig.update_layout(title="Concentração de NO₂", yaxis_title="Escala didática", **PLOT)
        st.plotly_chart(fig, use_container_width=True)
    st.markdown("#### Clima no mesmo período")
    fig = px.line(df, x="data_hora", y="temperatura", color_discrete_sequence=[CORES["Temperatura"]])
    fig.update_traces(line_width=2.5)
    fig.update_layout(title="Temperatura ao longo do tempo", yaxis_title="°C", xaxis_title="", **PLOT)
    st.plotly_chart(fig, use_container_width=True)

with aba2:
    st.subheader("Explore as relações entre variáveis")
    a, b = st.columns(2)
    with a:
        fig = px.scatter(df, x="temperatura", y="CO", color="nivel", size="NO2",
                         hover_data=["data_hora", "umidade"],
                         color_discrete_map={"Normal": "#22d3ee", "Alerta": "#fb7185"},
                         title="Temperatura × CO · tamanho = NO₂")
        fig.update_layout(xaxis_title="Temperatura (°C)", yaxis_title="CO", **PLOT)
        st.plotly_chart(fig, use_container_width=True)
    with b:
        corr = df[["CO", "NO2", "temperatura", "umidade"]].corr()
        fig = go.Figure(go.Heatmap(z=corr.to_numpy(), x=corr.columns.tolist(), y=corr.index.tolist(), zmin=-1, zmax=1, colorscale="RdBu_r"))
        for linha, nome_y in enumerate(corr.index):
            for coluna, nome_x in enumerate(corr.columns):
                fig.add_annotation(x=nome_x, y=nome_y, text=f"{corr.iloc[linha, coluna]:.2f}", showarrow=False, font=dict(color="#111827"))
        fig.update_layout(title="Correlação entre variáveis")
        fig.update_layout(**PLOT)
        st.plotly_chart(fig, use_container_width=True)
    st.markdown("#### Dataset filtrado")
    st.dataframe(df.sort_values("data_hora", ascending=False), use_container_width=True, hide_index=True)
    st.download_button("Baixar dados filtrados (CSV)", df.to_csv(index=False).encode("utf-8-sig"), "airpulse_dados.csv", "text/csv")

with aba3:
    st.subheader("Central de eventos")
    if n_alertas:
        st.warning(f"{n_alertas} leituras ultrapassaram pelo menos um limite configurado.")
    else:
        st.success("Nenhum alerta no período selecionado.")
    eventos = df[df["alerta"]].sort_values("data_hora", ascending=False)
    a, b = st.columns([2, 1])
    with a:
        por_hora = df.groupby(df["data_hora"].dt.hour)["alerta"].sum().reindex(range(24), fill_value=0)
        fig = px.bar(x=por_hora.index, y=por_hora.values, title="Alertas por hora do dia", color_discrete_sequence=["#fb7185"])
        fig.update_layout(xaxis_title="Hora", yaxis_title="Quantidade de alertas", **PLOT)
        st.plotly_chart(fig, use_container_width=True)
    with b:
        fig = go.Figure(go.Pie(labels=["Normais", "Alertas"], values=[len(df) - n_alertas, n_alertas], hole=.7,
                               marker_colors=["#22d3ee", "#fb7185"], textinfo="percent"))
        fig.update_layout(title="Distribuição das leituras", **PLOT)
        st.plotly_chart(fig, use_container_width=True)
    st.dataframe(eventos[["data_hora", "CO", "NO2", "temperatura", "nivel"]], use_container_width=True, hide_index=True)

with aba4:
    st.subheader("Onde o Streamlit entra no pipeline?")
    st.code("CSV → Kafka → Spark → MinIO (Parquet) → Streamlit", language="text")
    st.markdown("""
**Na aula:** os indicadores são calculados em memória com dados sintéticos.

**No projeto completo:** substitua a função `simular_dados()` por uma leitura dos Parquets
armazenados no MinIO, preservando os nomes das colunas e os componentes visuais.

**Experimentos sugeridos:** altere o limite de alerta, compare estações, investigue
horários com mais ocorrências e explique os padrões encontrados.
""")

st.caption("Air Quality Dashboard")
```



## Documentação Oficial

Para começar a usar o Streamlit, consulte a [documentação oficial](https://docs.streamlit.io/). Lá, você encontrará tutoriais, exemplos e recursos adicionais para ajudar você a criar seus próprios aplicativos web interativos com facilidade.
