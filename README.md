# SQL-Project-Data-Exploration
This is a small project aimed at data exploration using SQL.

The data in this repo is from [Our World In Data](https://ourworldindata.org/covid-deaths).

# Getting started

## Using the CSV files
This data was initially stored in a Postgres database. The CSV files ending with `_pg` are the files that were used in creating tables.

If you are using postgres, be sure to create a new database and use the following files first to create the required tables:
- `create covid_deaths table.sql`
- `create covid_vaccinations table.sql`

Then you will need to import the data into the tables using the following:
- `covid_deaths_pg.csv`
- `covid_vaccinations_pg.csv`

If you're using something like Microsoft SQL Server, you can use the following CSV files to help create the necessary tables:
- `covid_deaths.csv`
- `covid_vaccinations.csv`

The original dataset is also included in this repo and is called `owid-covid-data.csv`.

These files are in the data folder.


# Exploring the data

Included in this repo are the following SQL files to help you get started with data exploration:

- `Explore data.sql`
- `count check.sql`