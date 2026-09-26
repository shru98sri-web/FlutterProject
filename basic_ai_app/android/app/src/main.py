from fastapi import FastAPI, HTTPException
from pydantic import BaseModel

app = FastAPI()

# Define the expected structure for incoming data from Flutter
class PredictionRequest(BaseModel):
    gender: str
    seniorCitizen: int
    partner: int
    dependents: int
    tenure: int
    phoneService: int
    multipleLines: str
    internetService: str
    onlineSecurity: str
    onlineBackup: str
    deviceProtection: str
    techSupport: str
    streamingTV: str
    streamingMovies: str
    contract: str
    paperlessBilling: int
    paymentMethod: str
    monthlyCharges: float
    totalCharges: float

@app.get("/health")
def health_check():
    return {"status": "healthy"}

@app.post("/predict")
def predict_churn(request: PredictionRequest):
    try:
        # Mock logic/ML model placeholder:
        # e.g., if contract is month-to-month, risk might be higher
        is_high_risk = 1 if request.contract == "Month-to-month" else 0
        mock_probability = 0.82 if is_high_risk else 0.15

        return {
            "prediction": is_high_risk,
            "probability": mock_probability
        }
    except Exception as e:
        raise HTTPException(status_code=400, detail=str(e))
