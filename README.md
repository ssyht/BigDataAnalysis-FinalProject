# Big Data Analysis Final Project

This project looks at workload, fatigue, and readiness in elite women's rugby sevens. The goal was to study whether recent workload measures were associated with player wellness outcomes using the Canadian National Women's Rugby Sevens dataset.

For this project, I focused on one main question. I wanted to see whether recent workload measures were related to fatigue, monitoring score, and training readiness. Instead of trying to answer every possible question in the dataset, I chose a smaller and more focused direction so the analysis would stay clear and manageable.

## Project idea

Managing fatigue is important in sports because too much workload can affect performance and possibly increase injury risk. Rugby Sevens is especially intense because players may compete in multiple games over a short period of time. Because of that, I wanted to see how workload variables were connected to self reported wellness and readiness.

## Data used

The analysis used these files from the provided dataset:

`wellness.csv`  
`rpe.csv`  
`games.csv`

I did not include the raw `gps.csv` file in this repository because it was too large for GitHub and was not necessary for the final version of my analysis.

## What I did

I merged the main files using `Date` and `PlayerID`. I removed players 18 through 21 because they did not appear in the actual season data. Since the RPE data had multiple sessions for a player on the same day, I first aggregated the workload data to the player day level.

The main outcome variables in this project were:

`Fatigue`  
`MonitoringScore`  
`TrainingReadiness`

The main predictors were:

`AcuteLoad`  
`ChronicLoad`  
`AcuteChronicRatio`  
`GameDay`

After cleaning and merging the files, I created exploratory graphs and then fit linear regression models with player fixed effects to study how workload was related to the three wellness outcomes.

## Main findings

The results showed that workload variables were meaningfully related to player wellness, although not always in the exact direction I first expected.

Training readiness gave the strongest model fit out of the three outcomes. The acute chronic ratio and game day status were some of the most consistent predictors across the models. Overall, the results suggest that workload metrics can help support athlete monitoring, but the relationship between workload and fatigue is more complex than just saying more workload always means worse outcomes.

## Files in this repo

`code/` contains the R scripts used for cleaning, exploratory analysis, and modeling

`report/` contains the final IEEE style report

`output/figures/` contains the figures used in the report and analysis

`output/tables/` contains the cleaned outputs and model summary tables

## Report

The final report for this project was written in IEEE style format because that was the required submission format for the assignment.

## Repository link in the report

This repository link was also included in the final report submission so the code and project files could be accessed directly.

## Notes

This project focuses on a smaller part of the full challenge. I did not use the full GPS based movement analysis in the final report because I wanted to keep the project focused and because the raw GPS file was very large.

The writing and interpretation in this project were kept simple and direct so the report would reflect my own work and understanding.
