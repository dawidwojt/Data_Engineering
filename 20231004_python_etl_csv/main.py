from etl_code import *
import os.path


file_path = "./data/Credit_raw2.csv"
save_path = "./data/Credit_done.csv"

def run_pipeline(file_path:str, save_path:str):

    #extract
    if os.path.exists(file_path) is not True:
        raise FileNotFoundError(f"File Path {file_path} not found!")
    else:
        df = extract(file_path=file_path)

    #transform
    df = transform(df=df)

    #load
    load(df=df, save_path=save_path)

    return


if __name__ == "__main__":
    # run pipeline
    run_pipeline(file_path=file_path, save_path=save_path)

