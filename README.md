# website_database_analysis
explore information from website database (statistics overflow)


The top popular 10 tags in the website
![top10tags](https://cloud.githubusercontent.com/assets/8493530/9840613/f370151a-5a62-11e5-9a81-242d6e6c2174.png)

![posttypes](https://cloud.githubusercontent.com/assets/8493530/9840609/f36c1898-5a62-11e5-85ac-30e9e9287a3b.png)
![posttypes_score](https://cloud.githubusercontent.com/assets/8493530/9840611/f36e671a-5a62-11e5-9a3d-6e9eb871c05e.png)
![posttypes_score2](https://cloud.githubusercontent.com/assets/8493530/9840612/f36f31ae-5a62-11e5-8512-b3247714ad9d.png)

the average score of question is 36.29, and the the average score of answer is 41.57, 5.28 higher than the average of question's score.   

![score_rep](https://cloud.githubusercontent.com/assets/8493530/9840610/f36d1b4e-5a62-11e5-8625-4f5661746537.png)


Residuals:
    Min      1Q  Median      3Q     Max 
-8158.5   -13.7    -4.2     6.8  5653.4 

Coefficients:
            Estimate Std. Error t value Pr(>|t|)    
(Intercept)  4.34038    1.25821    3.45 0.000562 ***
Score       10.17620    0.01208  842.34  < 2e-16 ***

Residual standard error: 185.4 on 21980 degrees of freedom
Multiple R-squared:   0.97,     Adjusted R-squared:   0.97 
F-statistic: 7.095e+05 on 1 and 21980 DF,  p-value: < 2.2e-16

        Pearson's product-moment correlation

t = 842.3347, df = 21980, p-value < 2.2e-16
alternative hypothesis: true correlation is greater than 0
95 percent confidence interval:
 0.9845246 1.0000000
sample estimates:
      cor 
0.9848617 

Time needed to get answeres quickly.

![creat_time_new](https://cloud.githubusercontent.com/assets/8493530/9888729/a064693a-5bc4-11e5-9706-51b46aa3776a.png)

![anstime](https://cloud.githubusercontent.com/assets/8493530/9888727/a05ea252-5bc4-11e5-8a63-f2ac71ffa27e.png)

![boxplot_time](https://cloud.githubusercontent.com/assets/8493530/9888728/a060c2c6-5bc4-11e5-8e7f-3f904392def6.png)


