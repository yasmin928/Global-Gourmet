import pdfkit   # type: ignore

def generate_html_report():
    # HTML report with images and analysis results
    html = '''
    <html>
    <head>
        <title>Customer Churn Analysis</title>
    </head>
    <body>
        <h1>Exploratory Data Analysis</h1>
        <img src="static/heatmap.png" alt="Correlation Heatmap">
        <img src="static/churn_distribution.png" alt="Churn Distribution">
        <img src="static/boxplot.png" alt="Numerical Features Boxplot">
        
        <h1>Model Evaluation Report</h1>
        <p>Random Forest and Logistic Regression results included below:</p>
        <iframe src="/evaluation_report.html" width="100%" height="400px"></iframe>
    </body>
    </html>
    '''
    
    with open('templates/churn_report.html', 'w') as f:
        f.write(html)
    
    # Convert the HTML report to PDF
    pdfkit.from_file('templates/churn_report.html', 'static/churn_report.pdf')
