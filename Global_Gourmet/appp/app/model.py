from sklearn.model_selection import train_test_split
from sklearn.ensemble import RandomForestClassifier
from sklearn.linear_model import LogisticRegression
from sklearn.metrics import accuracy_score, precision_score, recall_score, roc_auc_score, classification_report
import pandas as pd

def build_and_train_model(df):
    X = df.drop('Churn', axis=1)
    y = df['Churn']
    
    X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.3, random_state=42)

    # RandomForest model
    rf_model = RandomForestClassifier(random_state=42)
    rf_model.fit(X_train, y_train)
    rf_pred = rf_model.predict(X_test)
    
    # Logistic Regression model
    lr_model = LogisticRegression(random_state=42)
    lr_model.fit(X_train, y_train)
    lr_pred = lr_model.predict(X_test)
    
    # Evaluate RandomForest
    print("RandomForest Model")
    print(f"Accuracy: {accuracy_score(y_test, rf_pred)}")
    print(f"Precision: {precision_score(y_test, rf_pred)}")
    print(f"Recall: {recall_score(y_test, rf_pred)}")
    print(f"ROC-AUC: {roc_auc_score(y_test, rf_pred)}")
    
    # Evaluate Logistic Regression
    print("Logistic Regression Model")
    print(f"Accuracy: {accuracy_score(y_test, lr_pred)}")
    print(f"Precision: {precision_score(y_test, lr_pred)}")
    print(f"Recall: {recall_score(y_test, lr_pred)}")
    print(f"ROC-AUC: {roc_auc_score(y_test, lr_pred)}")

    # Save evaluation results
    evaluation_report = classification_report(y_test, rf_pred, output_dict=True)
    df_report = pd.DataFrame(evaluation_report).transpose()
    df_report.to_html('templates/evaluation_report.html')
    df_report.to_csv('static/evaluation_report.csv')
