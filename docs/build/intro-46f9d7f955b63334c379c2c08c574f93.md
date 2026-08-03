# 👋 Welcome !

This [Jupyter book](https://jupyterbook.org) was created by [Clement Hardy](https://klemet.github.io/) for the [research theme 4](https://diverseproject.uqo.ca/theme-4-evaluation-various-forest-management-approaches/) of the [DIVERSE project](https://diverseproject.uqo.ca/).

## 🎯 Goal of this documentation

The objective here is to calibrate the parameters of [PnET Succession extension](https://github.com/LANDIS-II-Foundation/Extension-PnET-Succession) for the [LANDIS-II model](https://www.landis-ii.org/). These notebooks are a proof of concept that calibrate 6 species for a Canadian landscape.

PnET-Succession is one of the most complex extensions of LANDIS-II, based on the PnET familly of eco-physiological models. To be certain that the vegetation dynamics that it simulates will be realistic, we need to calibrate it carefully.

The [PnET succession User Guide](https://github.com/LANDIS-II-Foundation/Extension-PnET-Succession/blob/master/deploy/docs/LANDIS-II%20PnET-Succession%20v5.1%20User%20Guide.pdf) contains a lengthy section of calibration tips by [Eric Gustafson](https://research.fs.usda.gov/about/people/gustafson) that I will use as a guide for this calibration process.

```{admonition} Making the calibration of PnET-Succession easier for everyone
:class: tip
One of the main goals of this documentation is to translate the calibration tips of Eric Gustafson into a replicable and entirely documented procedure. As such, any research team should find here a calibration of PnET Succession from A to Z that can be replicated and reused freely.
```

## 🪜 Steps of the calibration

There are many ways to calibrate a model like PnET-Succession. It can be difficult to choose which one to use. Here, I propose an approach based my own understanding of the [calibration tips of Eric Gustafson](https://github.com/LANDIS-II-Foundation/Extension-PnET-Succession/blob/master/deploy/docs/LANDIS-II%20PnET-Succession%20v5.1%20User%20Guide.pdf).

This approach goes through the following steps :

- Generating some initial values for the parameters (or taking them from the litterature) (notebook 3)
- Estimating growth curves in ideal conditions (monoculture, etc.) from empirical data and gathering different informations on our tree species (shade tolerance, etc.) (notebook 4)
- Gathering climate data representative of the study landscape and averaging it to create a "mild" version of the local climate (notebook 5)
- Calibrate the growth curve of each tree species in "ideal conditions" (soil with good water retention, mild climate and monoculture) using the growth curves, information and climate data generated at the previous steps (Notebook 6)
- Assessing the competition between the tree species and making adjustments if necessary (Notebook 7)
- Calibrating `MaxPest` to adjust the frequency of establishment of new age cohorts in the landscape (Notebook 8) 


## 📖 Format of this documentation

This documentation is a Jupyter Book (the HTML pages that you can read at [https://klemet.github.io/PnET-Succession_Calibration_Tool/](https://klemet.github.io/PnET-Succession_Calibration_Tool/)), composed of several files (markdown files and Jupyter notebooks) that you can find in [the Github repository that contains the book](https://github.com/Klemet/PnET-Succession_Calibration_Tool).

The Jupyter notebooks can be run in a Docker container by using the files present in the Github repository, so as to reproduce the exact same environment with which the notebooks were executed. This ensures replicability on the long term.

The Jupyter notebooks can then be transformed into a HTML version using the script present in the notebook `BuildAndUpdateJupyterBook.ipynb`.

➡️ **📖 If you simply want to inform yourself as to the calibration process, just keep reading !**

➡️ **💻 If you want to run the code used for this calibration process on your own computer (for example, to calibrate new species for your own study area), read the instructions of [the readme of the repository](https://github.com/Klemet/PnET-Succession_Calibration_Tool/blob/main/README.md)**. They will help you deploy a Docker image on your computer that will contain the entire environment (including LANDIS-II) used for this calibration within minutes. You can then edit the notebooks so as to calibrate the parameters in your own study area and with different species.

**📖 Happy reading !**

## ✒️ Table of contents

```{tableofcontents}
```

## 🤖 Statement on AI use for this documentation

This documentation has been made with the help of LLMs (Large Language Models), particularly to code the Python functions that were used throughout these notebook to :

- Parse LANDIS-II parameters, write then, and launch LANDIS-II simulations from Python
- Read, edit and save into different format the empirical data or data from previous studies we're using
- Calibrate the parameters through different algorithms

Every function was made one by one, with a careful process of re-reading the code and implementing checks and print statements so that what the functions do and what they output are clear to understand, even for people not familiar with Python. As the author of the original PnET-Succession calibration tool (Clément Hardy), I've had extensive experience with coding in Python for my research before making this documentation, and was able to understand what the LLMs were producing. However, without the help of LLMs, I would most likely not have had the time to make so many functions - which are a big help in making this calibration process more transparent and replicable.

Concerning the text of this documentation, it has been written at 99% by my own hand - which can be too verbose at times. I've only used an LLM to synthesize the text concerning the assumptions (see notebook 0.2) as it was a bit long. An AI model was also used to developed the methodology used in Notebook 7 for assessing the competition between tree species with a factorial experiment to isolate the effect of water and temperature.

The use of AI in research is still a brand new field of ethics and questions. We're all trying to find what's acceptable or not, all the while trying to benefit from what the technology of LLMs can offer us as researchers, and how it can make our research better. I hope that my own use of AI here was reasonable.