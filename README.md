# Pewlett-Hackard-Analysis

# Overview of the analysis
The objective is to determine the number of retiring employees per title and also the company is starting a mentorship program so it also wants to know the employees who are eligible for this program.

# Results
## Task 1
Three tables where created:
1. Retirement Titles - which has all the titles of current employees who where born between January 1, 1952 and December 31, 1955. See image 1

<img width="709" alt="Screen Shot 2021-11-07 at 13 13 03" src="https://user-images.githubusercontent.com/90527537/140658585-fbe14999-fc64-4c8e-bf8a-f49d09fe0431.png">

2. Unique Titles - this table holds the most recent title of each employee. This table is required because there are emplooyes with different titles due to promotions, so we need the only the most recent title. See image 2

<img width="524" alt="Screen Shot 2021-11-07 at 13 16 55" src="https://user-images.githubusercontent.com/90527537/140658677-0de4d36a-8eb3-4467-ae37-2ce75abbc73b.png">

3. Retiring Titles - holds only the employees with the most recent title that will retire. See image 3

<img width="232" alt="Screen Shot 2021-11-07 at 13 21 43" src="https://user-images.githubusercontent.com/90527537/140658836-672a6adb-85cb-4f29-9117-2a4ce4e8eadc.png">

## Task 2
Next the company wants to know all the employees that are eligible for the mentorship program. The following employees were born between January 1, 1965 and December 31, 1965. The objective of this program is for retiring workers to train and mentor their successors. This with the goal of not having to pay all those who are going to retire and instead enter a part-time job.
See image 4 for a glimpse of the workers who are eligible for this program

<img width="786" alt="Screen Shot 2021-11-07 at 13 34 01" src="https://user-images.githubusercontent.com/90527537/140659245-756c3a40-9e26-42b9-b468-c8dce7a62c6a.png">

# Summary
- How many roles will need to be filled as the "silver tsunami" begins to make an impact?
According to the last table from task 1 there are 90,398 rolles that will need to be filled.

- Are there enough qualified, retirement-ready employees in the departments to mentor the next generation of Pewlett Hackard employees?
According to the table 'mentorship_eligibility' and using the following query:

<img width="282" alt="Screen Shot 2021-11-07 at 13 56 09" src="https://user-images.githubusercontent.com/90527537/140659832-4c06a52c-52df-4dd8-a1bd-8800b500a3c9.png">

There are only 1549 employees ready for the mentoring program and 90,398 retirement ready employees, so yes, there are enough qualified retirement ready to do this mentorship. Althoug the company will need to select the best options to do this mentoring.

