import io
from pathlib import Path
from typing import Literal

import joblib
import pandas as pd
from fastapi import FastAPI, File, HTTPException, UploadFile
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel, ConfigDict, Field
from sklearn.base import clone

app = FastAPI(
    title="Air Demand Gap Finder",
    description="Predicts how many air passengers a country carries in a year from its economic indicators.",
)

# CORS: only the websites listed below may call this API from a browser:
# our own Render page (Swagger UI) and the local Flutter web debug address (port 5000).
# We allow only GET and POST, only the Content-Type header, and no cookies,
# because the API needs nothing else. Any other website is blocked by the browser.
# No "*" on purpose: a wildcard would let any site use the API.
# The Flutter mobile app is not a browser, so CORS does not affect it.
app.add_middleware(
    CORSMiddleware,
    allow_origins=[
        "https://air-demand-gap-api.onrender.com",
        "http://localhost:5000",
        "http://127.0.0.1:5000",
    ],
    allow_methods=["GET", "POST"],
    allow_headers=["Content-Type"],
    allow_credentials=False,
)

# the model and the data it was trained on are loaded once, when the server starts
saved = joblib.load(Path(__file__).parent / "best_model.pkl")
model, data = saved["model"], saved["data"]

Region = Literal[
    "East Asia & Pacific",
    "Europe & Central Asia",
    "Latin America & Caribbean",
    "Middle East, North Africa, Afghanistan & Pakistan",
    "North America",
    "South Asia",
    "Sub-Saharan Africa",
]
IncomeGroup = Literal["Low income", "Lower middle income", "Upper middle income", "High income"]


class PredictionInput(BaseModel):
    # strict: a number sent as text, like "5", is rejected instead of converted
    model_config = ConfigDict(strict=True, extra="forbid")

    gdp_per_capita: float = Field(ge=20, le=250_000, description="GDP per person, current US dollars")
    population: int = Field(ge=10_000, le=2_000_000_000, description="Total population")
    land_area: float = Field(ge=1, le=20_000_000, description="Land area in square km")
    urban_pct: float = Field(ge=0, le=100, description="People living in cities, % of population")
    internet_pct: float = Field(ge=0, le=100, description="People using the internet, % of population")
    tourism_receipts_pct: float = Field(ge=0, le=100, description="International tourism receipts, % of exports")
    year: int = Field(ge=1990, le=2040, description="Year of the estimate")
    region: Region
    income_group: IncomeGroup


@app.post("/predict")
def predict(item: PredictionInput):
    row = pd.DataFrame([item.model_dump()])
    passengers = float(model.predict(row)[0])
    return {
        "predicted_passengers": round(passengers),
        "predicted_passengers_millions": round(passengers / 1_000_000, 2),
    }


@app.post("/retrain")
async def retrain(file: UploadFile = File(...)):
    global model, data

    try:
        new = pd.read_csv(io.BytesIO(await file.read()))
    except Exception:
        raise HTTPException(status_code=400, detail="The file could not be read as a CSV.")

    missing = [c for c in data.columns if c not in new.columns]
    if missing:
        raise HTTPException(status_code=400, detail=f"Missing columns: {missing}")

    new = new[list(data.columns)].copy()
    for col in data.select_dtypes("number").columns:
        new[col] = pd.to_numeric(new[col], errors="coerce")
    new = new.dropna(subset=["passengers", "year", "region", "income_group"])
    new = new[new["passengers"] > 0]
    if new.empty:
        raise HTTPException(status_code=400, detail="The file has no usable rows.")

    # the best model is LinearRegression, so we refit on the old rows plus the new rows
    # (for an SGDRegressor we would continue with partial_fit on the new rows instead)
    all_data = pd.concat([data, new], ignore_index=True)
    model = clone(model).fit(all_data.drop(columns="passengers"), all_data["passengers"])
    data = all_data

    return {
        "message": "Model retrained and now used by /predict",
        "new_rows_used": len(new),
        "total_training_rows": len(all_data),
    }


if __name__ == "__main__":
    import uvicorn

    uvicorn.run(app, host="0.0.0.0", port=8000)
