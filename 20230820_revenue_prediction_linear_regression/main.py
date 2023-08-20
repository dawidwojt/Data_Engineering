# % pip install scikit-learn
# % pip install pandas
# % pip install matplotlib
# or use:
# % pip install -r requirements.txt

from model import Prediction
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
from sklearn.linear_model import LinearRegression
from sklearn.metrics import mean_absolute_error, r2_score
from sklearn.model_selection import train_test_split


def make_prediction(inputs: list[float], outputs: list[float], input_value: float, plot: bool = False) -> Prediction:
    if len(inputs) != len(outputs):
        raise Exception('Length of inputs and outputs need to match')

    """Creating a dataframe for the data"""
    df = pd.DataFrame({'inputs': inputs, 'outputs': outputs})

    """Reshaping it using Numpy"""
    X = np.array(df['inputs']).reshape(-1,1)
    y = np.array(df['outputs']).reshape(-1,1)

    """Splitting the data: train and test"""
    train_X, test_X, train_y, test_y = train_test_split(X, y, random_state=0, test_size=.30)

    """Initializing the model"""
    model = LinearRegression()
    model.fit(train_X, train_y)

    """Prediction"""
    y_prediction = model.predict([[input_value]])
    y_line = model.predict(X)

    """Test for accuracy"""
    y_test_prediction = model.predict(test_X)

    """PLot"""
    if plot:
        raise display_plot(inputs=X, outputs=y, y_line=y_line)
    return Prediction(value=y_prediction[0][0],
                      r2_score=r2_score(test_y, y_test_prediction),
                      slope=model.coef_[0][0],
                      intercept=model.intercept_[0],
                      mean_absolute_error=mean_absolute_error(test_y, y_test_prediction))


def display_plot(inputs: list[float], outputs: list[float], y_line):
    plt.scatter(inputs, outputs, s=12)
    plt.xlabel('Inputs')
    plt.ylabel('Outputs')
    plt.plot(inputs, y_line, color='r')
    plt.show()


if __name__ == '__main__':
    years: list[int] = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15]
    revenue: list[int] = [100, 121, 91, 140, 202, 190, 191, 251, 299, 389, 380, 450, 478, 601, 577]
    my_input: int = 20
    prediction: Prediction = make_prediction(inputs=years, outputs=revenue, input_value=my_input, plot=True)
    print('Input: ', my_input)
    print(prediction)