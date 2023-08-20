# % pip install -r requirements.txt
# or install one by one:
    # % pip install scikit-learn
    # % pip install pandas
    # % pip install matplotlib


from model import Prediction
import numpy as np
import pandas as pd
import csv
import matplotlib.pyplot as plt
from sklearn.linear_model import LinearRegression
from sklearn.metrics import mean_absolute_error, r2_score
from sklearn.model_selection import train_test_split
from time import sleep

def make_prediction(inputs: list[float], outputs: list[float], input_value: float, c_name: str,  plot: bool = False ) -> Prediction:
    if len(inputs) != len(outputs):
        raise Exception('Length of inputs and outputs need to match')

    """Creating a dataframe for the data"""
    df = pd.DataFrame({'inputs': inputs, 'outputs': outputs})

    """Reshaping it using Numpy to have it in a vertical position"""
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
        display_plot(inputs=X, outputs=y, c_name=c_name, y_line=y_line)
    return Prediction(value=y_prediction[0][0],
                      r2_score=r2_score(test_y, y_test_prediction),
                      slope=model.coef_[0][0],
                      intercept=model.intercept_[0],
                      mean_absolute_error=mean_absolute_error(test_y, y_test_prediction))


def display_plot(inputs: list[float], outputs: list[float], c_name: str, y_line):
    plt.scatter(inputs, outputs, s=20)
    plt.xlabel('Inputs')
    plt.ylabel('Outputs')
    plt.plot(inputs, y_line, color='r')
    plt.title(c_name)
    plt.savefig(f'{c_name}_plot.png')
    plt.clf()



def main():
    my_input: int = int(input('PLease provide a year to predict revenue: '))


    with open("revenue_data.csv", newline='') as revenue_data:
        reader = csv.reader(revenue_data)

        years: list[int] = next(reader)[1:]
        years = [int(s) for s in years] # gets first row
        data_dict: dict = {}
        for row in reader:
            name: str = row[0]
            values: list[int] = row[1:]
            values = [int(s) for s in values]
            data_dict[name] = values
    for company in data_dict:
        name: str = company
        revenue: list[int] = (data_dict[name])
        print(f"Company: {name.upper()} ")
        prediction: Prediction = make_prediction(inputs=years, outputs=revenue, c_name=company, input_value=my_input, plot=True)
        print('Input: ', my_input)
        print(prediction)

main()