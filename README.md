# 🌎 Calculadora de Calidad del Aire

Aplicativo móvil desarrollado en **Flutter**, que permite consultar la **calidad del aire en las principales ciudades de Colombia** utilizando la **API de [Open-Meteo Air Quality](https://open-meteo.com/en/docs/air-quality-api)**.

El usuario puede seleccionar una ciudad, indicar la fecha de exposición y la cantidad de horas al aire libre, para obtener los valores de contaminantes atmosféricos y un **índice de riesgo de exposición personalizado**.

---

## 🚀 Características principales

✅ Consumo de la API **Open-Meteo** (Air Quality API).  
✅ Carga dinámica de ciudades colombianas desde un archivo **JSON local** (`assets/datos/capitales_colombia.json`).  
✅ Cálculo del **índice de exposición** en función de las horas al aire libre.  
✅ Evaluación automática del **nivel de riesgo** (Buena, Moderada, Dañina, Peligrosa, etc.).  
✅ Interfaz intuitiva con selección de ciudad, fecha y tiempo de exposición.  
✅ Resultados visuales y claros para el usuario.

---

## 🧠 Arquitectura del proyecto

El código está organizado siguiendo una estructura limpia:

