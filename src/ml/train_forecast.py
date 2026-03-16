from __future__ import annotations

from pathlib import Path

import pandas as pd
from sklearn.linear_model import LinearRegression


def train_round_velocity_model(data: pd.DataFrame) -> tuple[LinearRegression, float]:
    features = data[["qualified_targets", "warm_intro_count", "signal_momentum"]]
    target = data["meetings_booked"]
    model = LinearRegression()
    model.fit(features, target)
    score = model.score(features, target)
    return model, score


def load_training_data() -> pd.DataFrame:
    return pd.read_json(Path("sample_data") / "fundraising_history.json")


def main() -> None:
    data = load_training_data()
    model, score = train_round_velocity_model(data)
    print(
        "Forecast model trained with coefficients="
        f"{model.coef_.round(3).tolist()} and r2={score:.3f}"
    )


if __name__ == "__main__":
    main()
