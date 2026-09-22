# card-krueger-replication
Replication of selected results from Card &amp; Krueger's minimum wage study using R.
Card & Krueger Minimum Wage Replication

This project replicates selected results from the Card and Krueger minimum wage study using R.

The analysis examines changes in employment at fast-food restaurants in New Jersey and Pennsylvania following New Jersey's minimum wage increase.

Project Overview

The project uses the original Card and Krueger dataset and focuses on reproducing selected results from Tables 3 and 4.

The analysis includes:

Construction of full-time-equivalent (FTE) employment
Comparison of employment changes in New Jersey and Pennsylvania
Difference-in-Differences (DiD) estimation
Regression of employment changes on a New Jersey treatment indicator
Analysis using the initial wage gap relative to the new minimum wage
Data

The original dataset is downloaded directly from David Card's Berkeley website within the R script.

Full-time-equivalent employment is calculated as:

FTE = Full-time employees + Managers + 0.5 × Part-time employees

Employment change is then calculated as:

ΔEmployment = FTE after − FTE before

Difference-in-Differences

New Jersey is treated as the treatment group, while Pennsylvania serves as the comparison group.

The Difference-in-Differences estimate is calculated as:

DiD = ΔEmployment(NJ) − ΔEmployment(PA)

The script reproduces the employment comparison used in Table 3 of the study.

Regression Analysis

Two specifications from Table 4 are examined.

Model (i): New Jersey Indicator

Employment change is regressed on an indicator for whether the restaurant is located in New Jersey:

ΔEmployment = α + β(NJ) + ε

Model (iii): Wage Gap

A wage-gap variable is constructed for New Jersey restaurants whose initial wage was below $5.05:

gap = (5.05 − initial wage) / initial wage

Employment change is then regressed on this wage-gap measure.

Tools & Packages
R
tidyverse
fixest
knitr
kableExtra
Repository Structure
card-krueger-replication/
├── card_krueger.R
└── README.md
Purpose

This project was created as part of my econometrics work and demonstrates the use of R for data preparation, Difference-in-Differences analysis, and regression-based empirical economic analysis.
